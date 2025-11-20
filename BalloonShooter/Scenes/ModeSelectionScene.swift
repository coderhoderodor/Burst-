//
//  ModeSelectionScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/20/25.
//

import SpriteKit

class ModeSelectionScene: SKScene {

    var onModeSelected: ((GameMode) -> Void)?
    private var selectedMode: GameMode
    private let previousScene: SKScene

    init(size: CGSize, currentMode: GameMode, previousScene: SKScene) {
        self.selectedMode = currentMode
        self.previousScene = previousScene
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupBackground()
        setupModal()
    }

    private func setupBackground() {
        // Semi-transparent overlay
        let overlay = SKShapeNode(rect: self.frame)
        overlay.fillColor = UIColor(white: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.zPosition = 0
        overlay.name = "overlay"
        addChild(overlay)
    }

    private func setupModal() {
        let modalWidth: CGFloat = min(350, size.width - 40)
        let modalHeight: CGFloat = min(600, size.height - 100)

        let modal = SKNode()
        modal.position = CGPoint(x: size.width / 2, y: size.height / 2)
        modal.zPosition = 10

        // Modal background card
        let background = DesignSystem.createCard(width: modalWidth, height: modalHeight)
        background.fillColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 0.98)
        modal.addChild(background)

        // Title
        let title = SKLabelNode(text: "Choose Game Mode")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.subtitleSize
        title.fontColor = DesignSystem.Colors.textDark
        title.position = CGPoint(x: 0, y: modalHeight/2 - 50)
        modal.addChild(title)

        // Mode cards
        let modes: [GameMode] = [.arcade, .timeAttack, .precision, .survival]
        let cardHeight: CGFloat = 100
        let cardSpacing: CGFloat = 16
        let startY = modalHeight/2 - 110

        for (index, mode) in modes.enumerated() {
            let yPos = startY - CGFloat(index) * (cardHeight + cardSpacing)
            let modeCard = createModeCard(mode: mode, width: modalWidth - 40, height: cardHeight)
            modeCard.position = CGPoint(x: 0, y: yPos)
            modal.addChild(modeCard)
        }

        // Cancel button
        let cancelButton = DesignSystem.createButton(title: "Cancel", width: modalWidth - 40, height: 50, style: .secondary)
        cancelButton.position = CGPoint(x: 0, y: -modalHeight/2 + 40)
        cancelButton.name = "cancelButton"
        modal.addChild(cancelButton)

        addChild(modal)

        // Animate modal in
        modal.setScale(0.8)
        modal.alpha = 0
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
        scaleUp.timingMode = .easeOut
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        modal.run(SKAction.group([scaleUp, fadeIn]))
    }

    private func createModeCard(mode: GameMode, width: CGFloat, height: CGFloat) -> SKNode {
        let container = SKNode()
        container.name = "modeCard_\(mode.displayName)"

        let isSelected = mode == selectedMode

        // Card background
        let card = DesignSystem.createCard(width: width, height: height)
        card.fillColor = isSelected ?
            DesignSystem.Colors.buttonPrimary.withAlphaComponent(0.3) :
            UIColor(white: 1.0, alpha: 0.6)
        card.strokeColor = isSelected ?
            DesignSystem.Colors.buttonPrimary :
            DesignSystem.Colors.cloudWhite
        card.lineWidth = isSelected ? 3 : 2
        container.addChild(card)

        // Mode icon/emoji
        let icon = SKLabelNode(text: mode.icon)
        icon.fontSize = 36
        icon.position = CGPoint(x: -width/2 + 40, y: -8)
        icon.verticalAlignmentMode = .center
        container.addChild(icon)

        // Mode name
        let name = SKLabelNode(text: mode.displayName)
        name.fontName = DesignSystem.Typography.titleFont
        name.fontSize = 20
        name.fontColor = DesignSystem.Colors.textDark
        name.horizontalAlignmentMode = .left
        name.position = CGPoint(x: -width/2 + 75, y: 10)
        container.addChild(name)

        // Mode description
        let desc = SKLabelNode(text: mode.description)
        desc.fontName = DesignSystem.Typography.bodyFont
        desc.fontSize = 14
        desc.fontColor = DesignSystem.Colors.textDark.withAlphaComponent(0.7)
        desc.horizontalAlignmentMode = .left
        desc.position = CGPoint(x: -width/2 + 75, y: -10)
        container.addChild(desc)

        // High score
        let highScore = DataManager.shared.getHighScore(for: mode)
        let scoreLabel = SKLabelNode(text: "\(highScore)")
        scoreLabel.fontName = DesignSystem.Typography.numberFont
        scoreLabel.fontSize = 16
        scoreLabel.fontColor = DesignSystem.Colors.accent
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: width/2 - 20, y: -8)
        scoreLabel.verticalAlignmentMode = .center
        container.addChild(scoreLabel)

        return container
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
        if name == "cancelButton" || name == "overlay" {
            dismiss()
        } else if name.hasPrefix("modeCard_") {
            let modeName = name.replacingOccurrences(of: "modeCard_", with: "")
            if let mode = getMode(from: modeName) {
                selectMode(mode)
            }
        }
    }

    private func getMode(from displayName: String) -> GameMode? {
        switch displayName {
        case GameMode.arcade.displayName:
            return .arcade
        case GameMode.timeAttack.displayName:
            return .timeAttack
        case GameMode.precision.displayName:
            return .precision
        case GameMode.survival.displayName:
            return .survival
        default:
            return nil
        }
    }

    private func selectMode(_ mode: GameMode) {
        selectedMode = mode
        onModeSelected?(mode)
        dismiss()
    }

    private func dismiss() {
        let transition = SKTransition.fade(withDuration: 0.2)
        view?.presentScene(previousScene, transition: transition)
    }
}
