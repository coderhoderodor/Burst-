//
//  StatsScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/20/25.
//

import SpriteKit

class StatsScene: SKScene {

    private var dataManager = DataManager.shared
    private var selectedModeIndex = 0
    private let modes: [GameMode] = [.arcade, .timeAttack, .precision, .survival]
    private var modeCardsContainer: SKNode?

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupModeStats()
        setupLifetimeStats()
        setupBackButton()
    }

    private func setupBackground() {
        let gradient = DesignSystem.createGradientBackground(size: self.size)
        gradient.zPosition = -10
        addChild(gradient)
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "Your Stats")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.titleSize
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(title)

        // Add text stroke
        let stroke = SKLabelNode(text: "Your Stats")
        stroke.fontName = DesignSystem.Typography.titleFont
        stroke.fontSize = DesignSystem.Typography.titleSize
        stroke.fontColor = DesignSystem.Colors.textStroke
        stroke.position = CGPoint(x: 0, y: -3)
        stroke.zPosition = -1
        title.addChild(stroke)
    }

    private func setupModeStats() {
        let centerX = size.width / 2
        let centerY = size.height / 2

        // Mode tabs
        setupModeTabs(at: size.height - 180)

        // Stats card for selected mode
        modeCardsContainer = SKNode()
        modeCardsContainer?.position = CGPoint(x: centerX, y: centerY + 50)
        if let container = modeCardsContainer {
            addChild(container)
        }

        updateModeStats()
    }

    private func setupModeTabs(at yPos: CGFloat) {
        let centerX = size.width / 2
        let tabWidth: CGFloat = 70
        let tabSpacing: CGFloat = 10
        let totalWidth = CGFloat(modes.count) * tabWidth + CGFloat(modes.count - 1) * tabSpacing
        let startX = centerX - totalWidth / 2

        for (index, mode) in modes.enumerated() {
            let xPos = startX + CGFloat(index) * (tabWidth + tabSpacing) + tabWidth/2
            let tab = createModeTab(mode: mode, index: index, selected: index == selectedModeIndex)
            tab.position = CGPoint(x: xPos, y: yPos)
            addChild(tab)
        }
    }

    private func createModeTab(mode: GameMode, index: Int, selected: Bool) -> SKNode {
        let container = SKNode()
        container.name = "modeTab_\(index)"

        let width: CGFloat = 70
        let height: CGFloat = 60

        // Tab background
        let background = SKShapeNode(rect: CGRect(x: -width/2, y: -height/2, width: width, height: height), cornerRadius: 12)
        background.fillColor = selected ?
            DesignSystem.Colors.buttonPrimary :
            UIColor(white: 1.0, alpha: 0.2)
        background.strokeColor = selected ? .white : DesignSystem.Colors.cloudWhite
        background.lineWidth = selected ? 3 : 2
        container.addChild(background)

        // Icon
        let icon = SKLabelNode(text: mode.icon)
        icon.fontSize = 28
        icon.verticalAlignmentMode = .center
        container.addChild(icon)

        return container
    }

    private func updateModeStats() {
        modeCardsContainer?.removeAllChildren()

        let mode = modes[selectedModeIndex]
        let cardWidth: CGFloat = min(350, size.width - 40)
        let cardHeight: CGFloat = 200

        // Stats card
        let card = DesignSystem.createCard(width: cardWidth, height: cardHeight)
        card.fillColor = UIColor(white: 1.0, alpha: 0.3)
        modeCardsContainer?.addChild(card)

        // Mode name
        let modeName = SKLabelNode(text: mode.displayName)
        modeName.fontName = DesignSystem.Typography.titleFont
        modeName.fontSize = DesignSystem.Typography.subtitleSize
        modeName.fontColor = .white
        modeName.position = CGPoint(x: 0, y: cardHeight/2 - 40)
        modeCardsContainer?.addChild(modeName)

        // High Score
        let highScore = dataManager.getHighScore(for: mode)
        let scoreLabel = SKLabelNode(text: "High Score")
        scoreLabel.fontName = DesignSystem.Typography.bodyFont
        scoreLabel.fontSize = DesignSystem.Typography.captionSize
        scoreLabel.fontColor = DesignSystem.Colors.textSecondary
        scoreLabel.position = CGPoint(x: 0, y: 30)
        modeCardsContainer?.addChild(scoreLabel)

        let scoreValue = SKLabelNode(text: "\(highScore)")
        scoreValue.fontName = DesignSystem.Typography.numberFont
        scoreValue.fontSize = DesignSystem.Typography.numberSize
        scoreValue.fontColor = DesignSystem.Colors.accent
        scoreValue.position = CGPoint(x: 0, y: -5)
        modeCardsContainer?.addChild(scoreValue)

        // Mode-specific description
        let desc = SKLabelNode(text: mode.description)
        desc.fontName = DesignSystem.Typography.bodyFont
        desc.fontSize = DesignSystem.Typography.captionSize
        desc.fontColor = DesignSystem.Colors.textSecondary
        desc.position = CGPoint(x: 0, y: -cardHeight/2 + 30)
        modeCardsContainer?.addChild(desc)
    }

    private func setupLifetimeStats() {
        let centerX = size.width / 2
        let yStart: CGFloat = 220

        // Section title
        let sectionTitle = SKLabelNode(text: "LIFETIME TOTALS")
        sectionTitle.fontName = DesignSystem.Typography.titleFont
        sectionTitle.fontSize = DesignSystem.Typography.bodySize
        sectionTitle.fontColor = .white
        sectionTitle.position = CGPoint(x: centerX, y: yStart)
        addChild(sectionTitle)

        // Lifetime stats card
        let cardWidth: CGFloat = min(350, size.width - 40)
        let cardHeight: CGFloat = 140

        let card = DesignSystem.createCard(width: cardWidth, height: cardHeight)
        card.position = CGPoint(x: centerX, y: yStart - 90)
        card.fillColor = UIColor(white: 1.0, alpha: 0.3)
        addChild(card)

        var yPos = yStart - 50

        // Total balloons popped
        addStatRow(
            icon: "[B]",
            label: "Balloons Popped",
            value: "\(dataManager.totalBalloonsPopped)",
            at: yPos
        )

        yPos -= 40

        // Best wave
        addStatRow(
            icon: "[W]",
            label: "Best Wave",
            value: "\(dataManager.bestWave)",
            at: yPos
        )

        yPos -= 40

        // Best accuracy
        let accuracy = Int(dataManager.bestAccuracy * 100)
        addStatRow(
            icon: "[A]",
            label: "Best Accuracy",
            value: "\(accuracy)%",
            at: yPos
        )
    }

    private func addStatRow(icon: String, label: String, value: String, at yPos: CGFloat) {
        let centerX = size.width / 2
        let cardWidth: CGFloat = min(350, size.width - 40)

        // Icon
        let iconLabel = SKLabelNode(text: icon)
        iconLabel.fontSize = 24
        iconLabel.position = CGPoint(x: centerX - cardWidth/2 + 40, y: yPos)
        iconLabel.verticalAlignmentMode = .center
        addChild(iconLabel)

        // Label
        let textLabel = SKLabelNode(text: label)
        textLabel.fontName = DesignSystem.Typography.bodyFont
        textLabel.fontSize = DesignSystem.Typography.bodySize
        textLabel.fontColor = .white
        textLabel.horizontalAlignmentMode = .left
        textLabel.verticalAlignmentMode = .center
        textLabel.position = CGPoint(x: centerX - cardWidth/2 + 70, y: yPos)
        addChild(textLabel)

        // Value
        let valueLabel = SKLabelNode(text: value)
        valueLabel.fontName = DesignSystem.Typography.numberFont
        valueLabel.fontSize = DesignSystem.Typography.bodySize
        valueLabel.fontColor = DesignSystem.Colors.accent
        valueLabel.horizontalAlignmentMode = .right
        valueLabel.verticalAlignmentMode = .center
        valueLabel.position = CGPoint(x: centerX + cardWidth/2 - 30, y: yPos)
        addChild(valueLabel)
    }

    private func setupBackButton() {
        let backButton = DesignSystem.createButton(
            title: "Back",
            width: 120,
            height: 50,
            style: .icon
        )
        backButton.position = CGPoint(x: 80, y: 60)
        backButton.name = "backButton"
        addChild(backButton)
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
        if name == "backButton" {
            let press = SKAction.scale(to: 0.95, duration: 0.1)
            let release = SKAction.scale(to: 1.0, duration: 0.1)
            node.run(SKAction.sequence([press, release]))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.goBack()
            }
        } else if name.hasPrefix("modeTab_") {
            if let indexStr = name.split(separator: "_").last,
               let index = Int(indexStr),
               index != selectedModeIndex {
                selectedModeIndex = index
                refreshTabs()
                updateModeStats()
            }
        }
    }

    private func refreshTabs() {
        // Remove old tabs
        children.forEach { child in
            if let name = child.name, name.hasPrefix("modeTab_") {
                child.removeFromParent()
            }
        }

        // Recreate tabs
        setupModeTabs(at: size.height - 180)
    }

    private func goBack() {
        let settingsScene = SettingsScene(size: self.size)
        settingsScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .right, duration: 0.3)
        view?.presentScene(settingsScene, transition: transition)
    }
}
