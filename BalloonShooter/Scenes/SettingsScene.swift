//
//  SettingsScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class SettingsScene: SKScene {

    private var dataManager = DataManager.shared

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupSettings()
        setupBackButton()
    }

    private func setupBackground() {
        let background = SKShapeNode(rect: self.frame)
        background.fillColor = UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)
        background.strokeColor = .clear
        background.zPosition = -10
        addChild(background)
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "Settings")
        title.fontSize = 48
        title.fontName = "Arial-BoldMT"
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(title)
    }

    private func setupSettings() {
        var yPos = size.height - 200

        // Sound Effects
        yPos -= 80
        addToggleSetting(title: "Sound Effects", key: "sound", value: dataManager.soundEnabled, at: yPos)

        // Music
        yPos -= 80
        addToggleSetting(title: "Music", key: "music", value: dataManager.musicEnabled, at: yPos)

        // Haptics
        yPos -= 80
        addToggleSetting(title: "Haptic Feedback", key: "haptics", value: dataManager.hapticsEnabled, at: yPos)

        // Statistics section
        yPos -= 120
        let statsTitle = SKLabelNode(text: "Statistics")
        statsTitle.fontSize = 32
        statsTitle.fontName = "Arial-BoldMT"
        statsTitle.fontColor = .yellow
        statsTitle.position = CGPoint(x: size.width / 2, y: yPos)
        addChild(statsTitle)

        yPos -= 50
        let totalPopped = SKLabelNode(text: "Total Balloons Popped: \(dataManager.totalBalloonsPopped)")
        totalPopped.fontSize = 18
        totalPopped.fontColor = .white
        totalPopped.position = CGPoint(x: size.width / 2, y: yPos)
        addChild(totalPopped)

        yPos -= 35
        let bestWave = SKLabelNode(text: "Best Wave: \(dataManager.bestWave)")
        bestWave.fontSize = 18
        bestWave.fontColor = .white
        bestWave.position = CGPoint(x: size.width / 2, y: yPos)
        addChild(bestWave)

        yPos -= 35
        let accuracy = Int(dataManager.bestAccuracy * 100)
        let bestAccuracy = SKLabelNode(text: "Best Accuracy: \(accuracy)%")
        bestAccuracy.fontSize = 18
        bestAccuracy.fontColor = .white
        bestAccuracy.position = CGPoint(x: size.width / 2, y: yPos)
        addChild(bestAccuracy)
    }

    private func addToggleSetting(title: String, key: String, value: Bool, at yPos: CGFloat) {
        let container = SKNode()
        container.position = CGPoint(x: size.width / 2, y: yPos)
        container.name = "toggle_\(key)"

        let label = SKLabelNode(text: title)
        label.fontSize = 24
        label.fontName = "Arial"
        label.fontColor = .white
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: -120, y: -8)
        container.addChild(label)

        let toggle = createToggle(enabled: value)
        toggle.position = CGPoint(x: 100, y: 0)
        toggle.name = "toggleSwitch"
        container.addChild(toggle)

        addChild(container)
    }

    private func createToggle(enabled: Bool) -> SKNode {
        let container = SKNode()

        let background = SKShapeNode(rect: CGRect(x: -30, y: -15, width: 60, height: 30), cornerRadius: 15)
        background.fillColor = enabled ? .green : .gray
        background.strokeColor = .white
        background.lineWidth = 2
        background.name = "toggleBackground"
        container.addChild(background)

        let knob = SKShapeNode(circleOfRadius: 12)
        knob.fillColor = .white
        knob.strokeColor = .clear
        knob.position = CGPoint(x: enabled ? 15 : -15, y: 0)
        knob.name = "toggleKnob"
        container.addChild(knob)

        return container
    }

    private func setupBackButton() {
        let backButton = SKLabelNode(text: "← Back")
        backButton.fontSize = 28
        backButton.fontName = "Arial-BoldMT"
        backButton.fontColor = .white
        backButton.position = CGPoint(x: 80, y: 50)
        backButton.name = "backButton"
        addChild(backButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)

        for node in touchedNodes {
            if let name = node.name {
                if name == "backButton" {
                    goBack()
                } else if name.hasPrefix("toggle_") {
                    let key = name.replacingOccurrences(of: "toggle_", with: "")
                    toggleSetting(key: key, node: node)
                }
            } else if let parent = node.parent, let parentName = parent.name {
                if parentName.hasPrefix("toggle_") {
                    let key = parentName.replacingOccurrences(of: "toggle_", with: "")
                    toggleSetting(key: key, node: parent)
                }
            }
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
        if let toggleSwitch = node.childNode(withName: "toggleSwitch") {
            if let background = toggleSwitch.childNode(withName: "toggleBackground") as? SKShapeNode {
                background.fillColor = enabled ? .green : .gray
            }
            if let knob = toggleSwitch.childNode(withName: "toggleKnob") {
                let moveAction = SKAction.moveTo(x: enabled ? 15 : -15, duration: 0.2)
                knob.run(moveAction)
            }
        }
    }

    private func goBack() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .right, duration: 0.3)
        view?.presentScene(menuScene, transition: transition)
    }
}
