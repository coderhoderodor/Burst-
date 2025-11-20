//
//  SettingsScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//  Redesigned on 11/20/25 - Modern Simplistic UI
//

import SpriteKit

class SettingsScene: SKScene {

    private var dataManager = DataManager.shared

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupSettings()
        setupStatsButton()
        setupBackButton()
    }

    private func setupBackground() {
        // Consistent gradient background
        let gradient = DesignSystem.createGradientBackground(size: self.size)
        gradient.zPosition = -10
        addChild(gradient)
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "Settings")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.titleSize
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(title)

        // Add text stroke
        let stroke = SKLabelNode(text: "Settings")
        stroke.fontName = DesignSystem.Typography.titleFont
        stroke.fontSize = DesignSystem.Typography.titleSize
        stroke.fontColor = DesignSystem.Colors.textStroke
        stroke.position = CGPoint(x: 0, y: -3)
        stroke.zPosition = -1
        title.addChild(stroke)
    }

    private func setupSettings() {
        let centerX = size.width / 2
        var yPos = size.height - 200

        // Settings card container
        let cardWidth: CGFloat = min(350, size.width - 40)
        let cardHeight: CGFloat = 260

        let card = DesignSystem.createCard(width: cardWidth, height: cardHeight)
        card.position = CGPoint(x: centerX, y: yPos - cardHeight/2)
        card.fillColor = UIColor(white: 1.0, alpha: 0.3)
        addChild(card)

        yPos -= 40

        // Sound Effects toggle
        addToggleSetting(
            title: "Sound Effects",
            key: "sound",
            value: dataManager.soundEnabled,
            at: yPos,
            width: cardWidth
        )

        yPos -= 80

        // Music toggle
        addToggleSetting(
            title: "Music",
            key: "music",
            value: dataManager.musicEnabled,
            at: yPos,
            width: cardWidth
        )

        yPos -= 80

        // Haptics toggle
        addToggleSetting(
            title: "Haptic Feedback",
            key: "haptics",
            value: dataManager.hapticsEnabled,
            at: yPos,
            width: cardWidth
        )
    }

    private func addToggleSetting(title: String, key: String, value: Bool, at yPos: CGFloat, width: CGFloat) {
        let container = SKNode()
        container.position = CGPoint(x: size.width / 2, y: yPos)
        container.name = "toggle_\(key)"

        // Label
        let label = SKLabelNode(text: title)
        label.fontName = DesignSystem.Typography.titleFont
        label.fontSize = DesignSystem.Typography.bodySize
        label.fontColor = .white
        label.horizontalAlignmentMode = .left
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: -width/2 + 30, y: 0)
        container.addChild(label)

        // Toggle switch
        let toggle = createModernToggle(enabled: value)
        toggle.position = CGPoint(x: width/2 - 60, y: 0)
        toggle.name = "toggleSwitch"
        container.addChild(toggle)

        addChild(container)
    }

    private func createModernToggle(enabled: Bool) -> SKNode {
        let container = SKNode()

        // Track (background)
        let trackWidth: CGFloat = 70
        let trackHeight: CGFloat = 36
        let track = SKShapeNode(rect: CGRect(x: -trackWidth/2, y: -trackHeight/2, width: trackWidth, height: trackHeight), cornerRadius: trackHeight/2)
        track.fillColor = enabled ? DesignSystem.Colors.success : UIColor.gray.withAlphaComponent(0.5)
        track.strokeColor = .white
        track.lineWidth = 2
        track.name = "toggleTrack"
        container.addChild(track)

        // Knob
        let knobRadius: CGFloat = 14
        let knob = SKShapeNode(circleOfRadius: knobRadius)
        knob.fillColor = .white
        knob.strokeColor = .clear
        knob.position = CGPoint(x: enabled ? trackWidth/2 - 20 : -trackWidth/2 + 20, y: 0)
        knob.name = "toggleKnob"

        // Add subtle glow effect
        knob.glowWidth = 1

        container.addChild(knob)

        return container
    }

    private func setupStatsButton() {
        // Link to dedicated stats scene
        let statsButton = DesignSystem.createButton(
            title: "View Statistics",
            width: min(300, size.width - 80),
            height: 60,
            style: .secondary
        )
        statsButton.position = CGPoint(x: size.width / 2, y: 200)
        statsButton.name = "statsButton"
        addChild(statsButton)
    }

    private func setupBackButton() {
        // Modern back button
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
        // Button press animation
        let press = SKAction.scale(to: 0.95, duration: 0.1)
        let release = SKAction.scale(to: 1.0, duration: 0.1)

        if name == "backButton" {
            node.run(SKAction.sequence([press, release]))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.goBack()
            }
        } else if name == "statsButton" {
            node.run(SKAction.sequence([press, release]))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showStats()
            }
        } else if name.hasPrefix("toggle_") {
            let key = name.replacingOccurrences(of: "toggle_", with: "")
            toggleSetting(key: key, node: node)
        }
    }

    private func toggleSetting(key: String, node: SKNode) {
        switch key {
        case "sound":
            dataManager.soundEnabled.toggle()
            updateToggleVisual(node: node, enabled: dataManager.soundEnabled)
        case "music":
            dataManager.musicEnabled.toggle()
            updateToggleVisual(node: node, enabled: dataManager.musicEnabled)
        case "haptics":
            dataManager.hapticsEnabled.toggle()
            updateToggleVisual(node: node, enabled: dataManager.hapticsEnabled)
        default:
            break
        }
    }

    private func updateToggleVisual(node: SKNode, enabled: Bool) {
        guard let toggleSwitch = node.childNode(withName: "toggleSwitch") else { return }

        // Update track color
        if let track = toggleSwitch.childNode(withName: "toggleTrack") as? SKShapeNode {
            let colorChange = SKAction.run {
                track.fillColor = enabled ? DesignSystem.Colors.success : UIColor.gray.withAlphaComponent(0.5)
            }
            track.run(colorChange)
        }

        // Animate knob position
        if let knob = toggleSwitch.childNode(withName: "toggleKnob") {
            let newX = enabled ? 15.0 : -15.0
            let moveAction = SKAction.moveTo(x: newX, duration: 0.2)
            moveAction.timingMode = .easeInEaseOut
            knob.run(moveAction)
        }
    }

    private func showStats() {
        let statsScene = StatsScene(size: self.size)
        statsScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .left, duration: 0.3)
        view?.presentScene(statsScene, transition: transition)
    }

    private func goBack() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .right, duration: 0.3)
        view?.presentScene(menuScene, transition: transition)
    }
}
