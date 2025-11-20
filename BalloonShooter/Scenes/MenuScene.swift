//
//  MenuScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//  Redesigned on 11/20/25 - Modern Simplistic UI
//

import SpriteKit

class MenuScene: SKScene {

    private var selectedMode: GameMode = .arcade
    private var modeSelectorLabel: SKLabelNode?
    private var highScoreLabel: SKLabelNode?
    private var totalStatsLabel: SKLabelNode?

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupPlayButton()
        setupModeSelector()
        setupSecondaryButtons()
        setupStats()
    }

    private func setupBackground() {
        // Modern gradient background using DesignSystem
        let gradient = DesignSystem.createGradientBackground(size: self.size)
        gradient.zPosition = -10
        addChild(gradient)

        // Add floating decorative balloons with parallax effect
        for i in 0..<6 {
            let balloon = createDecorativeBalloon()
            let minX: CGFloat = 50
            let maxX = max(minX + 1, size.width - 50)
            let minY: CGFloat = 100
            let maxY = max(minY + 1, size.height - 200)

            balloon.position = CGPoint(
                x: CGFloat.random(in: minX...maxX),
                y: CGFloat.random(in: minY...maxY)
            )
            balloon.zPosition = -5
            addChild(balloon)

            // Gentle floating animation with varied timing
            let duration = 3.0 + Double(i) * 0.4
            let moveDistance: CGFloat = 15 + CGFloat(i) * 3
            let moveUp = SKAction.moveBy(x: 0, y: moveDistance, duration: duration)
            moveUp.timingMode = .easeInEaseOut
            let moveDown = moveUp.reversed()
            balloon.run(SKAction.repeatForever(SKAction.sequence([moveUp, moveDown])))

            // Slight horizontal drift
            let driftLeft = SKAction.moveBy(x: -10, y: 0, duration: duration * 1.5)
            driftLeft.timingMode = .easeInEaseOut
            let driftRight = driftLeft.reversed()
            balloon.run(SKAction.repeatForever(SKAction.sequence([driftLeft, driftRight])))
        }
    }

    private func createDecorativeBalloon() -> SKShapeNode {
        let size: CGFloat = CGFloat.random(in: 35...50)
        let path = UIBezierPath(ovalIn: CGRect(x: -size/2, y: -size/2, width: size, height: size))
        let balloon = SKShapeNode(path: path.cgPath)

        let colors = [
            DesignSystem.Colors.regular,
            DesignSystem.Colors.shield,
            DesignSystem.Colors.golden,
            DesignSystem.Colors.multi,
            DesignSystem.Colors.speed
        ]
        balloon.fillColor = colors.randomElement()!
        balloon.strokeColor = .white
        balloon.lineWidth = 2
        balloon.alpha = 0.4

        // Add subtle glow
        balloon.glowWidth = 2

        return balloon
    }

    private func setupTitle() {
        let centerX = size.width / 2
        let topY = size.height - 100

        // Main title with modern styling
        let title = SKLabelNode(text: "BALLOON")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.heroSize
        title.fontColor = .white
        title.position = CGPoint(x: centerX, y: topY)
        title.zPosition = 10
        addChild(title)

        // Add subtle text stroke
        let titleStroke = SKLabelNode(text: "BALLOON")
        titleStroke.fontName = DesignSystem.Typography.titleFont
        titleStroke.fontSize = DesignSystem.Typography.heroSize
        titleStroke.fontColor = DesignSystem.Colors.textStroke
        titleStroke.position = CGPoint(x: 0, y: -3)
        titleStroke.zPosition = -1
        title.addChild(titleStroke)

        let subtitle = SKLabelNode(text: "SHOOTER")
        subtitle.fontName = DesignSystem.Typography.titleFont
        subtitle.fontSize = DesignSystem.Typography.heroSize
        subtitle.fontColor = .white
        subtitle.position = CGPoint(x: centerX, y: topY - 60)
        subtitle.zPosition = 10
        addChild(subtitle)

        // Add stroke to subtitle
        let subtitleStroke = SKLabelNode(text: "SHOOTER")
        subtitleStroke.fontName = DesignSystem.Typography.titleFont
        subtitleStroke.fontSize = DesignSystem.Typography.heroSize
        subtitleStroke.fontColor = DesignSystem.Colors.textStroke
        subtitleStroke.position = CGPoint(x: 0, y: -3)
        subtitleStroke.zPosition = -1
        subtitle.addChild(subtitleStroke)

        // Tagline
        let tagline = SKLabelNode(text: "Aim carefully, pop wisely!")
        tagline.fontName = DesignSystem.Typography.bodyFont
        tagline.fontSize = DesignSystem.Typography.bodySize
        tagline.fontColor = DesignSystem.Colors.textSecondary
        tagline.position = CGPoint(x: centerX, y: topY - 105)
        tagline.alpha = 0.9
        addChild(tagline)
    }

    private func setupPlayButton() {
        let centerX = size.width / 2
        let centerY = size.height / 2

        // Large prominent PLAY button
        let playButton = DesignSystem.createButton(
            title: "PLAY",
            width: 280,
            height: 80,
            style: .primary
        )
        playButton.position = CGPoint(x: centerX, y: centerY + 20)
        playButton.name = "playButton"
        addChild(playButton)

        // Add subtle pulsing animation to draw attention
        let pulseUp = SKAction.scale(to: 1.05, duration: 1.0)
        pulseUp.timingMode = .easeInEaseOut
        let pulseDown = pulseUp.reversed()
        playButton.run(SKAction.repeatForever(SKAction.sequence([pulseUp, pulseDown])))
    }

    private func setupModeSelector() {
        let centerX = size.width / 2
        let centerY = size.height / 2

        // Mode selector card
        let selectorWidth: CGFloat = 280
        let selectorHeight: CGFloat = 60

        let selectorCard = DesignSystem.createCard(width: selectorWidth, height: selectorHeight)
        selectorCard.position = CGPoint(x: centerX, y: centerY - 80)
        selectorCard.name = "modeSelector"
        addChild(selectorCard)

        // Mode label
        let modeLabel = SKLabelNode(text: "Game Mode:")
        modeLabel.fontName = DesignSystem.Typography.bodyFont
        modeLabel.fontSize = DesignSystem.Typography.captionSize
        modeLabel.fontColor = DesignSystem.Colors.textDark
        modeLabel.horizontalAlignmentMode = .left
        modeLabel.position = CGPoint(x: centerX - selectorWidth/2 + 20, y: centerY - 80 + 10)
        addChild(modeLabel)

        // Selected mode text
        modeSelectorLabel = SKLabelNode(text: "\(selectedMode.icon) \(selectedMode.displayName)")
        modeSelectorLabel?.fontName = DesignSystem.Typography.titleFont
        modeSelectorLabel?.fontSize = DesignSystem.Typography.bodySize
        modeSelectorLabel?.fontColor = DesignSystem.Colors.textDark
        modeSelectorLabel?.horizontalAlignmentMode = .left
        modeSelectorLabel?.position = CGPoint(x: centerX - selectorWidth/2 + 20, y: centerY - 80 - 15)
        if let label = modeSelectorLabel {
            addChild(label)
        }

        // Dropdown indicator
        let dropdownIcon = SKLabelNode(text: "▾")
        dropdownIcon.fontSize = 20
        dropdownIcon.fontColor = DesignSystem.Colors.textDark
        dropdownIcon.position = CGPoint(x: centerX + selectorWidth/2 - 25, y: centerY - 80 - 8)
        dropdownIcon.verticalAlignmentMode = .center
        addChild(dropdownIcon)
    }

    private func setupSecondaryButtons() {
        let centerX = size.width / 2
        let bottomY: CGFloat = 140

        // Settings icon button
        let settingsButton = DesignSystem.createIconButton(icon: "[S]", size: 55)
        settingsButton.position = CGPoint(x: centerX - 60, y: bottomY)
        settingsButton.name = "settingsButton"
        addChild(settingsButton)

        // How to Play icon button
        let helpButton = DesignSystem.createIconButton(icon: "[?]", size: 55)
        helpButton.position = CGPoint(x: centerX + 60, y: bottomY)
        helpButton.name = "helpButton"
        addChild(helpButton)
    }

    private func setupStats() {
        let centerX = size.width / 2
        let bottomY: CGFloat = 60

        // High score for selected mode
        highScoreLabel = SKLabelNode(text: "Best: \(DataManager.shared.getHighScore(for: selectedMode))")
        highScoreLabel?.fontName = DesignSystem.Typography.numberFont
        highScoreLabel?.fontSize = DesignSystem.Typography.bodySize
        highScoreLabel?.fontColor = .white
        highScoreLabel?.position = CGPoint(x: centerX, y: bottomY + 10)
        if let label = highScoreLabel {
            addChild(label)
        }

        // Total balloons popped
        totalStatsLabel = SKLabelNode(text: "Total Popped: \(DataManager.shared.totalBalloonsPopped)")
        totalStatsLabel?.fontName = DesignSystem.Typography.bodyFont
        totalStatsLabel?.fontSize = DesignSystem.Typography.captionSize
        totalStatsLabel?.fontColor = DesignSystem.Colors.textSecondary
        totalStatsLabel?.position = CGPoint(x: centerX, y: bottomY - 15)
        if let label = totalStatsLabel {
            addChild(label)
        }
    }

    private func updateStats() {
        highScoreLabel?.text = "Best: \(DataManager.shared.getHighScore(for: selectedMode))"
        totalStatsLabel?.text = "Total Popped: \(DataManager.shared.totalBalloonsPopped)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let name = node.name {
                handleTouch(name: name, node: node)
            } else if let parent = node.parent, let parentName = parent.name {
                handleTouch(name: parentName, node: parent)
            }
        }
    }

    private func handleTouch(name: String, node: SKNode) {
        // Add button press animation
        if name != "modeSelector" {
            let press = SKAction.scale(to: 0.9, duration: 0.1)
            let release = SKAction.scale(to: 1.0, duration: 0.1)
            node.run(SKAction.sequence([press, release]))
        }

        switch name {
        case "playButton":
            startGame()
        case "modeSelector":
            showModeSelection()
        case "settingsButton":
            showSettings()
        case "helpButton":
            showHowToPlay()
        default:
            break
        }
    }

    private func startGame() {
        GameManager.shared.currentMode = selectedMode

        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }

    private func showModeSelection() {
        guard let view = self.view else { return }

        let modeScene = ModeSelectionScene(size: self.size, currentMode: selectedMode, previousScene: self)
        modeScene.scaleMode = .aspectFill

        // Use closure callback instead of delegate
        modeScene.onModeSelected = { [weak self] mode in
            self?.handleModeSelection(mode)
        }

        let transition = SKTransition.fade(withDuration: 0.2)
        view.presentScene(modeScene, transition: transition)
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

    // MARK: - Mode Selection Handler

    private func handleModeSelection(_ mode: GameMode) {
        selectedMode = mode
        modeSelectorLabel?.text = "\(mode.icon) \(mode.displayName)"
        updateStats()

        // Add subtle feedback animation
        modeSelectorLabel?.run(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
    }
}
