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
    // Game elements
    private var bowNode: SKNode!
    private var bowBody: SKShapeNode!
    private var bowString: SKShapeNode!
    private var arrow: ArrowNode? // Changed to ArrowNode type and optional
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
    private var isGamePaused: Bool = false

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
        // Create container for bow
        bowNode = SKNode()
        bowNode.position = CGPoint(x: size.width / 2, y: 100)
        addChild(bowNode)
        
        // Create Bow Body (The wood part)
        let bowPath = UIBezierPath()
        bowPath.move(to: CGPoint(x: -40, y: 0))
        bowPath.addQuadCurve(to: CGPoint(x: 40, y: 0), controlPoint: CGPoint(x: 0, y: 40))
        
        bowBody = SKShapeNode(path: bowPath.cgPath)
        bowBody.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0) // Wood color
        bowBody.lineWidth = 5
        bowBody.lineCap = .round
        bowNode.addChild(bowBody)
        
        // Create Bow String (Dynamic part)
        bowString = SKShapeNode()
        bowString.strokeColor = .white
        bowString.lineWidth = 2
        bowNode.addChild(bowString)
        
        updateBowString(pullAmount: 0)
    }
    
    private func updateBowString(pullAmount: CGFloat) {
        // 1. Update Bow Body (Bending Effect)
        // As we pull, the tips should move slightly inwards and follow the pull direction
        let maxBend: CGFloat = 10.0
        let bendFactor = min(pullAmount / 100.0, 1.0) // 0.0 to 1.0
        let tipOffset = maxBend * bendFactor
        
        let bowPath = UIBezierPath()
        // Left tip moves right and down (towards pull)
        let leftTip = CGPoint(x: -40 + tipOffset, y: -tipOffset)
        // Right tip moves left and down
        let rightTip = CGPoint(x: 40 - tipOffset, y: -tipOffset)
        
        bowPath.move(to: leftTip)
        // Control point stays roughly same but maybe moves down slightly less
        bowPath.addQuadCurve(to: rightTip, controlPoint: CGPoint(x: 0, y: 40 - tipOffset * 0.5))
        
        bowBody.path = bowPath.cgPath
        
        // 2. Update Bow String
        let stringPath = UIBezierPath()
        stringPath.move(to: leftTip)
        stringPath.addLine(to: CGPoint(x: 0, y: -pullAmount))
        stringPath.addLine(to: rightTip)
        bowString.path = stringPath.cgPath
    }
    
    private func animateStringRelease() {
        let action = SKAction.customAction(withDuration: 0.3) { [weak self] node, elapsedTime in
            guard let self = self else { return }
            
            // Damped oscillation
            let t = CGFloat(elapsedTime / 0.3)
            let amplitude: CGFloat = 20.0
            let decay = exp(-5 * t)
            let oscillation = amplitude * decay * cos(20 * t)
            
            // The string vibrates around 0
            self.updateBowString(pullAmount: oscillation)
        }
        bowNode.run(action) { [weak self] in
            self?.updateBowString(pullAmount: 0)
        }
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

        // Add pause bars
        let bar1 = SKShapeNode(rect: CGRect(x: 12, y: 12, width: 5, height: 16))
        bar1.fillColor = .white
        bar1.strokeColor = .clear
        pauseButton.addChild(bar1)

        let bar2 = SKShapeNode(rect: CGRect(x: 23, y: 12, width: 5, height: 16))
        bar2.fillColor = .white
        bar2.strokeColor = .clear
        pauseButton.addChild(bar2)

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
        if gameManager.currentMode == .precision, let arrowsRemaining = gameManager.arrowsRemaining {
            // Arrows remaining for Precision mode
            livesLabel.text = "Arrows: \(arrowsRemaining)"
        } else {
            // Hearts for lives
            livesLabel.text = "Lives: \(max(0, gameManager.lives))"
        }

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
            waveLabel.text = String(format: "Time: %.0fs", remaining)
        }

        // Shield indicator
        if gameManager.hasShield {
            let shieldLabel = SKLabelNode(text: "SHIELD ACTIVE")
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

        // Handle pause menu button touches
        if isGamePaused {
            let touchedNode = atPoint(location)

            if touchedNode.name == "resumeButton" {
                togglePause()
                return
            }

            if touchedNode.name == "menuButton" {
                // Return to main menu
                let menuScene = MenuScene(size: self.size)
                menuScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 0.5)
                view?.presentScene(menuScene, transition: transition)
                return
            }

            return // Consume any other touches while paused
        }

        // Start drawing bow
        touchStartPoint = location

        // Create a preview arrow on the bow
        arrow?.removeFromParent()
        arrow = ArrowNode(from: .zero, angle: 0, power: 0)
        // Initial position: Tail on string. String is at 0. Tail is at -45 relative to center.
        // So Center should be at +45.
        arrow?.position = CGPoint(x: 0, y: 45)
        arrow?.zRotation = CGFloat.pi / 2 // Point up relative to bow (forward)
        // Disable physics for preview arrow (it should only move with the bow, not fall)
        arrow?.physicsBody?.isDynamic = false
        bowNode.addChild(arrow!)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let startPoint = touchStartPoint else { return }
        if isGamePaused { return }

        let currentPoint = touch.location(in: self)
        
        // Calculate pull vector
        let dx = startPoint.x - currentPoint.x
        let dy = startPoint.y - currentPoint.y
        let distance = sqrt(dx * dx + dy * dy)
        // Max pull distance based on arrow length (90). Tip is at +45.
        // We want tip to stay in front of bow (0).
        // Arrow Center = 45 - pull. Tip = 90 - pull.
        // 90 - pull > 30 (margin) => pull < 60.
        let maxPullDistance: CGFloat = 60
        
        // Limit pull distance
        let pullDistance = min(distance, maxPullDistance)
        
        // Calculate aiming angle (from bow center to touch point)
        // We want the bow to point towards where we are dragging FROM (opposite to pull)
        // Actually, standard mechanics: drag back to shoot forward.
        // So we aim based on the drag vector relative to the bow?
        // Let's keep it simple: Dragging anywhere on screen controls the bow angle and power.
        
        // Angle from bow to current touch
        let angleToTouch = atan2(currentPoint.y - bowNode.position.y, currentPoint.x - bowNode.position.x)
        
        // We want to shoot in the OPPOSITE direction of the drag if we are dragging "back"
        // But usually in these games, you touch and drag back.
        // Let's rotate the bow to point towards the finger, but the arrow points opposite?
        // No, let's make the bow follow the finger angle relative to the bow position.
        
        let angle = atan2(currentPoint.y - bowNode.position.y, currentPoint.x - bowNode.position.x)
        // Rotate bow to face the touch point (or opposite?)
        // If I drag down-left, I want to shoot up-right.
        // So the bow should face up-right.
        
        let shootAngle = angle + CGFloat.pi
        bowNode.zRotation = shootAngle - CGFloat.pi / 2 // Adjust for bow's default orientation (up)

        // Update bow string
        updateBowString(pullAmount: pullDistance)
        
        // Update arrow position on the string
        // Arrow length is ~90. Center is 0. Tail is at -45.
        // We want tail (-45) to be at string position (-pullDistance).
        // So Center = -pullDistance + 45.
        arrow?.position = CGPoint(x: 0, y: -pullDistance + 45)
        
        // Show trajectory
        // Global angle for trajectory
        let globalAngle = shootAngle
        showTrajectory(from: bowNode.position, angle: globalAngle, power: pullDistance / maxPullDistance)

        // Slow motion effect when fully pulled
        if pullDistance >= maxPullDistance * 0.9 && !gameManager.hasPowerUp(.slowMotion) {
            gameManager.activatePowerUp(.slowMotion)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let startPoint = touchStartPoint else { return }
        if isGamePaused { return }

        let currentPoint = touch.location(in: self)
        
        // Calculate pull
        let dx = startPoint.x - currentPoint.x
        let dy = startPoint.y - currentPoint.y
        let distance = sqrt(dx * dx + dy * dy)
        let maxPullDistance: CGFloat = 60
        let pullDistance = min(distance, maxPullDistance)
        let power = pullDistance / maxPullDistance
        
        // Calculate angle
        let angle = atan2(currentPoint.y - bowNode.position.y, currentPoint.x - bowNode.position.x)
        let shootAngle = angle + CGFloat.pi

        // Shoot arrow
        if power > 0.1 {
            shootArrow(from: bowNode.position, angle: shootAngle, power: power)
        }

        // Reset
        arrow?.removeFromParent()
        arrow = nil
        // Animate release instead of instant reset
        animateStringRelease()
        touchStartPoint = nil
        trajectoryLine?.removeFromParent()
        trajectoryLine = nil
        
        // Reset bow rotation (optional, smooth return?)
        let rotateBack = SKAction.rotate(toAngle: 0, duration: 0.2)
        bowNode.run(rotateBack)
    }

    private func showTrajectory(from position: CGPoint, angle: CGFloat, power: CGFloat) {
        trajectoryLine?.removeFromParent()

        let path = UIBezierPath()
        path.move(to: .zero)

        // Simulate trajectory
        let segments = 20
        let timeStep: CGFloat = 0.1
        let speed = power * 3000.0 // Match arrow speed
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

        // Randomly choose left or right side (50/50)
        let fromLeft = Bool.random()

        // Random vertical position
        let margin: CGFloat = 80
        let startY = CGFloat.random(in: margin...(size.height - margin))

        // Start position: off-screen left or right
        let startX: CGFloat = fromLeft ? -100 : size.width + 100
        let targetX: CGFloat = fromLeft ? size.width + 100 : -100

        let balloon = BalloonNode(type: type, at: CGPoint(x: startX, y: startY))
        addChild(balloon)
        balloons.append(balloon)
        balloonsInCurrentWave += 1

        // Animate balloon floating horizontally across screen
        let floatDuration: TimeInterval = 3.5
        let moveHorizontalAction = SKAction.moveBy(x: targetX - startX, y: 0, duration: floatDuration)
        moveHorizontalAction.timingMode = .easeOut

        // Add vertical bobbing motion
        let swayDistance: CGFloat = 25
        let swayDuration: TimeInterval = 2.0
        let swayUp = SKAction.moveBy(x: 0, y: swayDistance, duration: swayDuration)
        swayUp.timingMode = .easeInEaseOut
        let swayDown = SKAction.moveBy(x: 0, y: -swayDistance, duration: swayDuration)
        swayDown.timingMode = .easeInEaseOut
        let swaySequence = SKAction.sequence([swayUp, swayDown])
        let swayForever = SKAction.repeatForever(swaySequence)

        // Run both actions simultaneously
        balloon.run(moveHorizontalAction)
        balloon.run(swayForever, withKey: "sway")
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
        if isGamePaused { return }

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
            // Faster spawn rate: 0.6 to 1.2 seconds (instead of 1.0 to 2.0)
            // This increases spawn frequency by ~40%
            nextBalloonSpawnTime = currentTime + Double.random(in: 0.6...1.2)
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

        // Update balloons (check if they've exited the screen)
        for balloon in balloons {
            // Remove if balloon has floated off-screen horizontally
            if balloon.position.x < -150 || balloon.position.x > size.width + 150 {
                balloon.removeFromParent()
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
        isGamePaused.toggle()

        if isGamePaused {
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
