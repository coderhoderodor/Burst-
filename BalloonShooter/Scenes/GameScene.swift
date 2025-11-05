//
//  GameScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // Game state
    private var gameManager = GameManager.shared
    private var dataManager = DataManager.shared
    private var audioManager = AudioManager.shared

    // UI Elements
    private var scoreLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var waveLabel: SKLabelNode!
    private var comboLabel: SKLabelNode!
    private var pauseButton: SKShapeNode!
    private var powerUpLabels: [PowerUpType: SKLabelNode] = [:]

    // Game elements
    private var bow: SKShapeNode!
    private var arrow: SKShapeNode!
    private var trajectoryLine: SKShapeNode?
    private var player: SKNode!

    // Tracking
    private var touchStartPoint: CGPoint?
    private var balloons: [BalloonNode] = []
    private var arrows: [ArrowNode] = []
    private var bombs: [BombNode] = []
    private var lastUpdateTime: TimeInterval = 0
    private var gameTime: TimeInterval = 0
    private var nextBalloonSpawnTime: TimeInterval = 0
    private var balloonsInCurrentWave: Int = 0
    private var isPaused: Bool = false

    // Statistics
    private var arrowsShot: Int = 0
    private var arrowsHit: Int = 0

    override func didMove(to view: SKView) {
        setupPhysics()
        setupBackground()
        setupPlayer()
        setupBow()
        setupUI()
        startGame()
    }

    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }

    private func setupBackground() {
        // Create gradient background
        let topColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
        let bottomColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)

        let background = SKShapeNode(rect: self.frame)
        background.fillColor = bottomColor
        background.strokeColor = .clear
        background.zPosition = -10
        addChild(background)
    }

    private func setupPlayer() {
        player = SKNode()
        player.position = CGPoint(x: size.width / 2, y: 50)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 10))
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.bomb
        addChild(player)
    }

    private func setupBow() {
        // Create bow at bottom center
        let bowPath = UIBezierPath()
        bowPath.move(to: CGPoint(x: -30, y: -10))
        bowPath.addQuadCurve(to: CGPoint(x: -30, y: 10), controlPoint: CGPoint(x: -40, y: 0))
        bowPath.move(to: CGPoint(x: 30, y: -10))
        bowPath.addQuadCurve(to: CGPoint(x: 30, y: 10), controlPoint: CGPoint(x: 40, y: 0))

        bow = SKShapeNode(path: bowPath.cgPath)
        bow.strokeColor = .brown
        bow.lineWidth = 4
        bow.position = CGPoint(x: size.width / 2, y: 100)
        addChild(bow)

        // Create arrow (initially hidden)
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 0, y: 0))
        arrowPath.addLine(to: CGPoint(x: 0, y: 40))

        arrow = SKShapeNode(path: arrowPath.cgPath)
        arrow.strokeColor = .brown
        arrow.lineWidth = 3
        arrow.isHidden = true
        bow.addChild(arrow)
    }

    private func setupUI() {
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 60)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)

        // Lives label
        livesLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        livesLabel.fontSize = 28
        livesLabel.fontColor = .red
        livesLabel.position = CGPoint(x: 60, y: size.height - 60)
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.zPosition = 100
        addChild(livesLabel)

        // Wave label
        waveLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        waveLabel.fontSize = 28
        waveLabel.fontColor = .white
        waveLabel.position = CGPoint(x: size.width - 60, y: size.height - 60)
        waveLabel.horizontalAlignmentMode = .right
        waveLabel.zPosition = 100
        addChild(waveLabel)

        // Combo label (initially hidden)
        comboLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        comboLabel.fontSize = 24
        comboLabel.fontColor = .yellow
        comboLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        comboLabel.zPosition = 100
        comboLabel.isHidden = true
        addChild(comboLabel)

        // Pause button
        let pausePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 40, height: 40))
        pauseButton = SKShapeNode(path: pausePath.cgPath)
        pauseButton.fillColor = .white.withAlphaComponent(0.3)
        pauseButton.strokeColor = .white
        pauseButton.lineWidth = 2
        pauseButton.position = CGPoint(x: 20, y: 20)
        pauseButton.zPosition = 100
        addChild(pauseButton)

        let pauseLabel = SKLabelNode(text: "⏸")
        pauseLabel.fontSize = 24
        pauseLabel.position = CGPoint(x: 20, y: 10)
        pauseLabel.verticalAlignmentMode = .center
        pauseButton.addChild(pauseLabel)

        updateUI()
    }

    private func startGame() {
        gameManager.startNewGame(mode: gameManager.currentMode)
        gameTime = 0
        nextBalloonSpawnTime = 0
        balloonsInCurrentWave = 0
        updateUI()
    }

    private func updateUI() {
        scoreLabel.text = "Score: \(gameManager.score)"

        // Lives display
        let heartsText = String(repeating: "❤️", count: max(0, gameManager.lives))
        livesLabel.text = heartsText

        waveLabel.text = "Wave \(gameManager.currentWave)"

        // Combo
        if gameManager.combo >= 3 {
            comboLabel.text = "Combo x\(gameManager.combo / 3 + 1)"
            comboLabel.isHidden = false
        } else {
            comboLabel.isHidden = true
        }

        // Time display for Time Attack mode
        if gameManager.currentMode == .timeAttack, let timeLimit = gameManager.currentMode.timeLimit {
            let remaining = max(0, timeLimit - gameTime)
            waveLabel.text = String(format: "⏱ %.0f", remaining)
        }

        // Arrows remaining for Precision mode
        if let arrowsRemaining = gameManager.arrowsRemaining {
            livesLabel.text = "🏹 \(arrowsRemaining)"
        }

        // Shield indicator
        if gameManager.hasShield {
            let shieldLabel = SKLabelNode(text: "🛡️ SHIELD")
            shieldLabel.fontSize = 20
            shieldLabel.fontColor = .cyan
            shieldLabel.position = CGPoint(x: size.width / 2, y: 150)
            shieldLabel.name = "shieldIndicator"

            // Remove old indicator
            childNode(withName: "shieldIndicator")?.removeFromParent()
            addChild(shieldLabel)
        } else {
            childNode(withName: "shieldIndicator")?.removeFromParent()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Check if pause button was tapped
        if pauseButton.contains(location) {
            togglePause()
            return
        }

        if isPaused { return }

        // Start drawing bow
        touchStartPoint = location
        arrow.isHidden = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let startPoint = touchStartPoint else { return }
        if isPaused { return }

        let currentPoint = touch.location(in: self)
        let bowPosition = bow.position

        // Calculate pull vector
        let dx = bowPosition.x - currentPoint.x
        let dy = bowPosition.y - currentPoint.y
        let distance = sqrt(dx * dx + dy * dy)
        let maxPullDistance: CGFloat = 150

        // Limit pull distance
        let pullDistance = min(distance, maxPullDistance)
        let angle = atan2(dy, dx)

        // Update arrow rotation and scale
        arrow.zRotation = angle - .pi / 2
        let scale = pullDistance / 50.0
        arrow.setScale(scale)

        // Show trajectory line
        showTrajectory(from: bowPosition, angle: angle, power: pullDistance / maxPullDistance)

        // Slow motion effect when fully pulled
        if pullDistance >= maxPullDistance * 0.9 && !gameManager.hasPowerUp(.slowMotion) {
            gameManager.activatePowerUp(.slowMotion)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touchStartPoint != nil else { return }
        if isPaused { return }

        let currentPoint = touch.location(in: self)
        let bowPosition = bow.position

        // Calculate shoot vector
        let dx = bowPosition.x - currentPoint.x
        let dy = bowPosition.y - currentPoint.y
        let distance = sqrt(dx * dx + dy * dy)
        let maxPullDistance: CGFloat = 150

        let pullDistance = min(distance, maxPullDistance)
        let angle = atan2(dy, dx)
        let power = pullDistance / maxPullDistance

        // Shoot arrow
        if power > 0.1 {
            shootArrow(from: bowPosition, angle: angle, power: power)
        }

        // Reset
        arrow.isHidden = true
        touchStartPoint = nil
        trajectoryLine?.removeFromParent()
        trajectoryLine = nil
    }

    private func showTrajectory(from position: CGPoint, angle: CGFloat, power: CGFloat) {
        trajectoryLine?.removeFromParent()

        let path = UIBezierPath()
        path.move(to: .zero)

        // Simulate trajectory
        let segments = 20
        let timeStep: CGFloat = 0.1
        let speed = power * 15.0
        var vx = cos(angle) * speed
        var vy = sin(angle) * speed
        var x: CGFloat = 0
        var y: CGFloat = 0

        for _ in 0..<segments {
            x += vx * timeStep * 10
            y += vy * timeStep * 10
            vy -= 0.98 * timeStep * 10 // Gravity

            path.addLine(to: CGPoint(x: x, y: y))
        }

        trajectoryLine = SKShapeNode(path: path.cgPath)
        trajectoryLine?.strokeColor = .white.withAlphaComponent(0.5)
        trajectoryLine?.lineWidth = 2
        trajectoryLine?.position = position
        trajectoryLine?.zPosition = 50

        // Dashed line effect
        let pattern: [CGFloat] = [10, 5]
        trajectoryLine?.path = path.cgPath

        addChild(trajectoryLine!)
    }

    private func shootArrow(from position: CGPoint, angle: CGFloat, power: CGFloat) {
        // Check if can shoot (precision mode)
        if gameManager.currentMode == .precision {
            guard gameManager.useArrow() else {
                gameOver()
                return
            }
        }

        arrowsShot += 1
        audioManager.playSound(.arrowShoot)
        audioManager.playHaptic(.light)

        // Multi-arrow power-up
        let arrowCount = gameManager.hasPowerUp(.multiArrow) ? 3 : 1
        let angleSpread: CGFloat = gameManager.hasPowerUp(.multiArrow) ? 0.2 : 0

        for i in 0..<arrowCount {
            let offset = CGFloat(i - arrowCount / 2) * angleSpread
            let arrowNode = ArrowNode(from: position, angle: angle + offset, power: power)
            addChild(arrowNode)
            arrows.append(arrowNode)
        }

        updateUI()
    }

    private func spawnBalloon() {
        guard balloons.count < gameManager.maxSimultaneousBalloons else { return }
        guard balloonsInCurrentWave < gameManager.balloonsPerWave else { return }

        // Determine balloon type based on wave and mode
        let type = selectBalloonType()

        // Random position at top
        let margin: CGFloat = 50
        let x = CGFloat.random(in: margin...(size.width - margin))
        let y = size.height - 100

        let balloon = BalloonNode(type: type, at: CGPoint(x: x, y: y))
        addChild(balloon)
        balloons.append(balloon)
        balloonsInCurrentWave += 1
    }

    private func selectBalloonType() -> BalloonType {
        // Phase 1: Only regular balloons
        if gameManager.currentWave == 1 {
            return .regular
        }

        // Phase 2+: Include bomb balloons
        let random = Double.random(in: 0...1)

        if gameManager.currentWave >= 4 {
            // Phase 4+: Include special balloons
            if random < 0.05 {
                return .golden
            } else if random < 0.10 {
                return .shield
            } else if random < 0.15 {
                return .speed
            } else if random < 0.20 {
                return .mystery
            } else if random < 0.25 {
                return .multi
            }
        }

        // Bomb balloon ratio
        if random < gameManager.bombBalloonRatio {
            return .bomb
        }

        return .regular
    }

    override func update(_ currentTime: TimeInterval) {
        if isPaused { return }

        // Delta time
        let deltaTime = lastUpdateTime == 0 ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameTime += deltaTime

        // Update power-ups
        gameManager.updatePowerUps(delta: deltaTime)

        // Time Attack mode
        if gameManager.currentMode == .timeAttack, let timeLimit = gameManager.currentMode.timeLimit {
            if gameTime >= timeLimit {
                gameOver()
                return
            }
        }

        // Spawn balloons
        if currentTime >= nextBalloonSpawnTime {
            spawnBalloon()
            nextBalloonSpawnTime = currentTime + Double.random(in: 1.0...2.0)
        }

        // Update arrows
        for arrow in arrows {
            arrow.update(deltaTime: deltaTime)

            // Remove if off screen
            if arrow.position.y > size.height + 50 || arrow.position.y < -50 ||
               arrow.position.x < -50 || arrow.position.x > size.width + 50 {
                arrow.removeFromParent()
            }
        }
        arrows.removeAll { $0.parent == nil }

        // Update balloons (movement for speed type)
        for balloon in balloons {
            // Keep balloons in bounds
            if balloon.position.x < 50 || balloon.position.x > size.width - 50 {
                balloon.physicsBody?.velocity.dx *= -1
            }
        }

        // Update bombs
        for bomb in bombs {
            // Check if bomb reached bottom
            if bomb.position.y < player.position.y {
                bomb.explode {
                    self.audioManager.playSound(.explosion)
                    self.audioManager.playHaptic(.heavy)
                    self.shakeScreen()
                }

                let gameIsOver = gameManager.loseLife()
                updateUI()

                if gameIsOver {
                    gameOver()
                }
            }
        }
        bombs.removeAll { $0.parent == nil }

        // Check if wave complete
        if balloonsInCurrentWave >= gameManager.balloonsPerWave && balloons.isEmpty {
            completeWave()
        }

        updateUI()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        // Arrow hit balloon
        if (bodyA.categoryBitMask == PhysicsCategory.arrow && bodyB.categoryBitMask == PhysicsCategory.balloon) ||
           (bodyA.categoryBitMask == PhysicsCategory.balloon && bodyB.categoryBitMask == PhysicsCategory.arrow) {

            let arrowNode = bodyA.categoryBitMask == PhysicsCategory.arrow ? bodyA.node : bodyB.node
            let balloonNode = bodyA.categoryBitMask == PhysicsCategory.balloon ? bodyA.node as? BalloonNode : bodyB.node as? BalloonNode

            handleBalloonHit(balloon: balloonNode, arrow: arrowNode)
        }
    }

    private func handleBalloonHit(balloon: BalloonNode?, arrow: SKNode?) {
        guard let balloon = balloon, let arrow = arrow else { return }

        arrowsHit += 1
        gameManager.incrementCombo()
        audioManager.playSound(.balloonPop)
        audioManager.playHaptic(.medium)

        // Handle based on balloon type
        switch balloon.balloonType {
        case .regular:
            gameManager.addScore(balloon.balloonType.points)

        case .bomb:
            // Drop bomb
            let bomb = BombNode(at: balloon.position)
            addChild(bomb)
            bombs.append(bomb)
            audioManager.playSound(.bombFall)

        case .shield:
            gameManager.addScore(balloon.balloonType.points)
            gameManager.hasShield = true

        case .golden:
            gameManager.addScore(balloon.balloonType.points)
            // Golden balloon effect
            showBonusText("+\(balloon.balloonType.points)", at: balloon.position, color: .yellow)

        case .multi:
            gameManager.addScore(balloon.balloonType.points)
            // Spawn smaller balloons
            for i in 0..<3 {
                let angle = CGFloat(i) * (.pi * 2 / 3)
                let offset = CGPoint(x: cos(angle) * 50, y: sin(angle) * 50)
                let newPos = CGPoint(x: balloon.position.x + offset.x, y: balloon.position.y + offset.y)
                let smallBalloon = BalloonNode(type: .regular, at: newPos)
                smallBalloon.setScale(0.6)
                addChild(smallBalloon)
                balloons.append(smallBalloon)
            }

        case .mystery:
            // 50/50 chance
            if Bool.random() {
                let bonus = 50
                gameManager.addScore(bonus)
                showBonusText("+\(bonus)", at: balloon.position, color: .green)
            } else {
                let bomb = BombNode(at: balloon.position)
                addChild(bomb)
                bombs.append(bomb)
            }

        case .speed:
            gameManager.addScore(balloon.balloonType.points)
            showBonusText("+\(balloon.balloonType.points)", at: balloon.position, color: .green)
        }

        // Pop balloon
        balloon.pop {
            // Balloon removed
        }
        balloons.removeAll { $0 == balloon }

        // Remove arrow
        arrow.removeFromParent()

        updateUI()
    }

    private func showBonusText(_ text: String, at position: CGPoint, color: UIColor) {
        let label = SKLabelNode(text: text)
        label.fontSize = 30
        label.fontColor = color
        label.fontName = "Arial-BoldMT"
        label.position = position
        label.zPosition = 200
        addChild(label)

        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let group = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()

        label.run(SKAction.sequence([group, remove]))
    }

    private func completeWave() {
        gameManager.completeWave()
        balloonsInCurrentWave = 0

        // Show wave complete message
        let message = SKLabelNode(text: "Wave \(gameManager.currentWave - 1) Complete!")
        message.fontSize = 40
        message.fontColor = .yellow
        message.fontName = "Arial-BoldMT"
        message.position = CGPoint(x: size.width / 2, y: size.height / 2)
        message.zPosition = 200
        addChild(message)

        let fadeOut = SKAction.fadeOut(withDuration: 2.0)
        let remove = SKAction.removeFromParent()
        message.run(SKAction.sequence([fadeOut, remove]))

        updateUI()
    }

    private func shakeScreen() {
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: -10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 10, y: 0, duration: 0.05),
            SKAction.moveBy(x: 0, y: 0, duration: 0.05)
        ])
        camera?.run(shake)
    }

    private func togglePause() {
        isPaused.toggle()

        if isPaused {
            // Show pause menu
            showPauseMenu()
        } else {
            // Hide pause menu
            childNode(withName: "pauseMenu")?.removeFromParent()
        }
    }

    private func showPauseMenu() {
        let overlay = SKShapeNode(rect: self.frame)
        overlay.fillColor = .black.withAlphaComponent(0.7)
        overlay.strokeColor = .clear
        overlay.zPosition = 500
        overlay.name = "pauseMenu"
        addChild(overlay)

        let title = SKLabelNode(text: "PAUSED")
        title.fontSize = 48
        title.fontName = "Arial-BoldMT"
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        overlay.addChild(title)

        let resumeLabel = SKLabelNode(text: "Resume")
        resumeLabel.fontSize = 32
        resumeLabel.fontName = "Arial-BoldMT"
        resumeLabel.fontColor = .green
        resumeLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        resumeLabel.name = "resumeButton"
        overlay.addChild(resumeLabel)

        let menuLabel = SKLabelNode(text: "Main Menu")
        menuLabel.fontSize = 32
        menuLabel.fontName = "Arial-BoldMT"
        menuLabel.fontColor = .white
        menuLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 60)
        menuLabel.name = "menuButton"
        overlay.addChild(menuLabel)
    }

    private func gameOver() {
        // Save stats
        dataManager.saveHighScore(gameManager.score, for: gameManager.currentMode)
        dataManager.totalBalloonsPopped += gameManager.balloonsPopped
        dataManager.bestWave = gameManager.currentWave

        let accuracy = arrowsShot > 0 ? Double(arrowsHit) / Double(arrowsShot) : 0
        dataManager.bestAccuracy = accuracy

        // Transition to game over scene
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.finalScore = gameManager.score
        gameOverScene.waveReached = gameManager.currentWave
        gameOverScene.accuracy = accuracy
        gameOverScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(gameOverScene, transition: transition)
    }
}
