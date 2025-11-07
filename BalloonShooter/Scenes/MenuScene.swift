//
//  MenuScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class MenuScene: SKScene {

    private var selectedMode: GameMode = .arcade

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupModeSelection()
        setupButtons()
        setupStats()
    }

    private func setupBackground() {
        let topColor = UIColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 1.0)
        let bottomColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)

        let background = SKShapeNode(rect: self.frame)
        background.fillColor = bottomColor
        background.strokeColor = .clear
        background.zPosition = -10
        addChild(background)

        // Add floating balloons decoration
        for i in 0..<5 {
            let balloon = createDecorativeBalloon()
            balloon.position = CGPoint(
                x: CGFloat.random(in: 50...size.width - 50),
                y: CGFloat.random(in: 100...size.height - 200)
            )
            addChild(balloon)

            // Floating animation
            let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 2.0 + Double(i) * 0.5)
            moveUp.timingMode = .easeInEaseOut
            let moveDown = moveUp.reversed()
            balloon.run(SKAction.repeatForever(SKAction.sequence([moveUp, moveDown])))
        }
    }

    private func createDecorativeBalloon() -> SKShapeNode {
        let size: CGFloat = 40
        let path = UIBezierPath(ovalIn: CGRect(x: -size/2, y: -size/2, width: size, height: size))
        let balloon = SKShapeNode(path: path.cgPath)
        balloon.fillColor = [UIColor.red, .blue, .green, .yellow, .purple].randomElement()!
        balloon.strokeColor = .clear
        balloon.alpha = 0.6
        return balloon
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "BALLOON SHOOTER")
        title.fontSize = 48
        title.fontName = "Arial-BoldMT"
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height - 120)
        title.zPosition = 10

        // Add shadow effect
        let shadow = SKLabelNode(text: "BALLOON SHOOTER")
        shadow.fontSize = 48
        shadow.fontName = "Arial-BoldMT"
        shadow.fontColor = .black
        shadow.alpha = 0.3
        shadow.position = CGPoint(x: 2, y: -2)
        title.addChild(shadow)

        addChild(title)

        let subtitle = SKLabelNode(text: "Aim carefully, pop wisely!")
        subtitle.fontSize = 20
        subtitle.fontName = "Arial"
        subtitle.fontColor = .white
        subtitle.position = CGPoint(x: size.width / 2, y: size.height - 170)
        addChild(subtitle)
    }

    private func setupModeSelection() {
        let modesY = size.height - 280
        let modes: [GameMode] = [.arcade, .timeAttack, .precision, .survival]

        for (index, mode) in modes.enumerated() {
            let yPos = modesY - CGFloat(index * 80)

            let modeButton = createModeButton(mode: mode, at: CGPoint(x: size.width / 2, y: yPos))
            addChild(modeButton)
        }
    }

    private func createModeButton(mode: GameMode, at position: CGPoint) -> SKNode {
        let container = SKNode()
        container.position = position
        container.name = "mode_\(mode.displayName)"

        // Background
        let background = SKShapeNode(rect: CGRect(x: -140, y: -30, width: 280, height: 60), cornerRadius: 10)
        background.fillColor = selectedMode == mode ? .systemBlue : .white.withAlphaComponent(0.3)
        background.strokeColor = .white
        background.lineWidth = 2
        container.addChild(background)

        // Title
        let title = SKLabelNode(text: mode.displayName)
        title.fontSize = 24
        title.fontName = "Arial-BoldMT"
        title.fontColor = .white
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: 0, y: 8)
        container.addChild(title)

        // Description
        let desc = SKLabelNode(text: mode.description)
        desc.fontSize = 12
        desc.fontName = "Arial"
        desc.fontColor = .white
        desc.verticalAlignmentMode = .center
        desc.position = CGPoint(x: 0, y: -10)
        container.addChild(desc)

        return container
    }

    private func setupButtons() {
        // Play button
        let playButton = createButton(text: "PLAY", at: CGPoint(x: size.width / 2, y: 220))
        playButton.name = "playButton"
        addChild(playButton)

        // Settings button
        let settingsButton = createButton(text: "Settings", at: CGPoint(x: size.width / 2, y: 150))
        settingsButton.name = "settingsButton"
        addChild(settingsButton)

        // How to Play button
        let howToPlayButton = createButton(text: "How to Play", at: CGPoint(x: size.width / 2, y: 80))
        howToPlayButton.name = "howToPlayButton"
        addChild(howToPlayButton)
    }

    private func createButton(text: String, at position: CGPoint) -> SKNode {
        let container = SKNode()
        container.position = position

        let background = SKShapeNode(rect: CGRect(x: -100, y: -25, width: 200, height: 50), cornerRadius: 25)
        background.fillColor = .green
        background.strokeColor = .white
        background.lineWidth = 3
        container.addChild(background)

        let label = SKLabelNode(text: text)
        label.fontSize = 28
        label.fontName = "Arial-BoldMT"
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        container.addChild(label)

        return container
    }

    private func setupStats() {
        let dataManager = DataManager.shared

        let statsY: CGFloat = 40
        let statsText = "Best: \(dataManager.getHighScore(for: .arcade)) | Total Popped: \(dataManager.totalBalloonsPopped)"

        let stats = SKLabelNode(text: statsText)
        stats.fontSize = 16
        stats.fontName = "Arial"
        stats.fontColor = .white
        stats.position = CGPoint(x: size.width / 2, y: statsY)
        addChild(stats)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let name = node.name {
                handleTouch(name: name)
            } else if let parent = node.parent, let parentName = parent.name {
                handleTouch(name: parentName)
            }
        }
    }

    private func handleTouch(name: String) {
        if name == "playButton" {
            startGame()
        } else if name == "settingsButton" {
            showSettings()
        } else if name == "howToPlayButton" {
            showHowToPlay()
        } else if name.hasPrefix("mode_") {
            // Mode selection
            let modeName = name.replacingOccurrences(of: "mode_", with: "")
            if modeName == GameMode.arcade.displayName {
                selectedMode = .arcade
            } else if modeName == GameMode.timeAttack.displayName {
                selectedMode = .timeAttack
            } else if modeName == GameMode.precision.displayName {
                selectedMode = .precision
            } else if modeName == GameMode.survival.displayName {
                selectedMode = .survival
            }

            // Refresh mode buttons
            for child in children {
                if let name = child.name, name.hasPrefix("mode_") {
                    child.removeFromParent()
                }
            }
            setupModeSelection()
        }
    }

    private func startGame() {
        GameManager.shared.currentMode = selectedMode

        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }

    private func showSettings() {
        let settingsScene = SettingsScene(size: self.size)
        settingsScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .left, duration: 0.3)
        view?.presentScene(settingsScene, transition: transition)
    }

    private func showHowToPlay() {
        let howToPlayScene = HowToPlayScene(size: self.size)
        howToPlayScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .left, duration: 0.3)
        view?.presentScene(howToPlayScene, transition: transition)
    }
}
