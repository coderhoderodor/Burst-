//
//  GameOverScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//  Redesigned on 11/20/25 - Modern UI with Score Breakdown
//

import SpriteKit

class GameOverScene: SKScene {

    var finalScore: Int = 0
    var waveReached: Int = 1
    var accuracy: Double = 0.0

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupScoreBreakdown()
        setupStats()
        setupButtons()
    }

    private func setupBackground() {
        let gradient = DesignSystem.createGradientBackground(size: self.size)
        gradient.zPosition = -10
        addChild(gradient)
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "Game Over")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.heroSize
        title.fontColor = DesignSystem.Colors.warning
        title.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(title)

        // Add text stroke
        let stroke = SKLabelNode(text: "Game Over")
        stroke.fontName = DesignSystem.Typography.titleFont
        stroke.fontSize = DesignSystem.Typography.heroSize
        stroke.fontColor = DesignSystem.Colors.textStroke
        stroke.position = CGPoint(x: 0, y: -3)
        stroke.zPosition = -1
        title.addChild(stroke)

        // Add pulsing animation
        let scaleUp = SKAction.scale(to: 1.05, duration: 0.6)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = scaleUp.reversed()
        title.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }

    private func setupScoreBreakdown() {
        let centerX = size.width / 2
        let cardWidth: CGFloat = min(350, size.width - 40)
        let cardHeight: CGFloat = 280

        // Score card
        let card = DesignSystem.createCard(width: cardWidth, height: cardHeight)
        card.position = CGPoint(x: centerX, y: size.height - 260)
        card.fillColor = UIColor(white: 1.0, alpha: 0.3)
        addChild(card)

        var yPos = size.height - 200

        // Final Score (large)
        let finalScoreLabel = SKLabelNode(text: "Final Score")
        finalScoreLabel.fontName = DesignSystem.Typography.bodyFont
        finalScoreLabel.fontSize = DesignSystem.Typography.bodySize
        finalScoreLabel.fontColor = .white
        finalScoreLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(finalScoreLabel)

        yPos -= 40
        let scoreValue = SKLabelNode(text: "\(finalScore)")
        scoreValue.fontName = DesignSystem.Typography.numberFont
        scoreValue.fontSize = DesignSystem.Typography.heroSize
        scoreValue.fontColor = DesignSystem.Colors.accent
        scoreValue.position = CGPoint(x: centerX, y: yPos)
        addChild(scoreValue)

        // High score comparison
        let gameManager = GameManager.shared
        let highScore = DataManager.shared.getHighScore(for: gameManager.currentMode)

        yPos -= 50
        if finalScore >= highScore && finalScore > 0 {
            let newRecordLabel = SKLabelNode(text: "NEW RECORD!")
            newRecordLabel.fontName = DesignSystem.Typography.titleFont
            newRecordLabel.fontSize = DesignSystem.Typography.subtitleSize
            newRecordLabel.fontColor = DesignSystem.Colors.accent
            newRecordLabel.position = CGPoint(x: centerX, y: yPos)
            addChild(newRecordLabel)

            // Pulse animation for new record
            let pulse = DesignSystem.Effects.pulseAnimation(scale: 1.1, duration: 0.5)
            newRecordLabel.run(pulse)
        } else {
            let highScoreLabel = SKLabelNode(text: "Best: \(highScore)")
            highScoreLabel.fontName = DesignSystem.Typography.bodyFont
            highScoreLabel.fontSize = DesignSystem.Typography.bodySize
            highScoreLabel.fontColor = DesignSystem.Colors.textSecondary
            highScoreLabel.position = CGPoint(x: centerX, y: yPos)
            addChild(highScoreLabel)
        }

        // Score Breakdown
        yPos -= 50
        let breakdownTitle = SKLabelNode(text: "Score Breakdown")
        breakdownTitle.fontName = DesignSystem.Typography.titleFont
        breakdownTitle.fontSize = DesignSystem.Typography.bodySize
        breakdownTitle.fontColor = .white
        breakdownTitle.position = CGPoint(x: centerX, y: yPos)
        addChild(breakdownTitle)

        yPos -= 30
        addBreakdownRow(
            label: "Balloons",
            value: gameManager.baseScore,
            at: yPos,
            centerX: centerX,
            cardWidth: cardWidth
        )

        yPos -= 25
        addBreakdownRow(
            label: "Combo Bonuses",
            value: gameManager.comboScore,
            at: yPos,
            centerX: centerX,
            cardWidth: cardWidth
        )

        yPos -= 25
        addBreakdownRow(
            label: "Wave Bonuses",
            value: gameManager.waveScore,
            at: yPos,
            centerX: centerX,
            cardWidth: cardWidth
        )

        // Divider line
        yPos -= 20
        let divider = SKShapeNode(rect: CGRect(x: centerX - cardWidth/2 + 40, y: yPos - 5, width: cardWidth - 80, height: 2))
        divider.fillColor = .white
        divider.strokeColor = .clear
        divider.alpha = 0.5
        addChild(divider)

        yPos -= 20
        addBreakdownRow(
            label: "Total",
            value: finalScore,
            at: yPos,
            centerX: centerX,
            cardWidth: cardWidth,
            isTotal: true
        )
    }

    private func addBreakdownRow(label: String, value: Int, at yPos: CGFloat, centerX: CGFloat, cardWidth: CGFloat, isTotal: Bool = false) {
        let labelNode = SKLabelNode(text: label)
        labelNode.fontName = isTotal ? DesignSystem.Typography.titleFont : DesignSystem.Typography.bodyFont
        labelNode.fontSize = isTotal ? DesignSystem.Typography.bodySize : DesignSystem.Typography.captionSize + 2
        labelNode.fontColor = .white
        labelNode.horizontalAlignmentMode = .left
        labelNode.verticalAlignmentMode = .center
        labelNode.position = CGPoint(x: centerX - cardWidth/2 + 40, y: yPos)
        addChild(labelNode)

        let valueNode = SKLabelNode(text: "\(value)")
        valueNode.fontName = DesignSystem.Typography.numberFont
        valueNode.fontSize = isTotal ? DesignSystem.Typography.bodySize : DesignSystem.Typography.captionSize + 2
        valueNode.fontColor = isTotal ? DesignSystem.Colors.accent : DesignSystem.Colors.textSecondary
        valueNode.horizontalAlignmentMode = .right
        valueNode.verticalAlignmentMode = .center
        valueNode.position = CGPoint(x: centerX + cardWidth/2 - 40, y: yPos)
        addChild(valueNode)
    }

    private func setupStats() {
        let centerX = size.width / 2
        let cardWidth: CGFloat = min(350, size.width - 40)
        let yStart: CGFloat = 310

        // Stats card
        let card = DesignSystem.createCard(width: cardWidth, height: 100)
        card.position = CGPoint(x: centerX, y: yStart - 50)
        card.fillColor = UIColor(white: 1.0, alpha: 0.25)
        addChild(card)

        var yPos = yStart

        // Wave Reached
        let waveLabel = SKLabelNode(text: "Wave \(waveReached)")
        waveLabel.fontName = DesignSystem.Typography.numberFont
        waveLabel.fontSize = DesignSystem.Typography.bodySize
        waveLabel.fontColor = .white
        waveLabel.position = CGPoint(x: centerX - 80, y: yPos)
        addChild(waveLabel)

        // Accuracy
        let accuracyPercent = Int(accuracy * 100)
        let accuracyLabel = SKLabelNode(text: "\(accuracyPercent)% Accuracy")
        accuracyLabel.fontName = DesignSystem.Typography.numberFont
        accuracyLabel.fontSize = DesignSystem.Typography.bodySize
        accuracyLabel.fontColor = .white
        accuracyLabel.position = CGPoint(x: centerX + 80, y: yPos)
        addChild(accuracyLabel)

        yPos -= 30

        // Accuracy rating
        let rating: String
        let ratingColor: UIColor
        if accuracy >= 0.8 {
            rating = "Sharpshooter!"
            ratingColor = DesignSystem.Colors.success
        } else if accuracy >= 0.6 {
            rating = "Good Aim"
            ratingColor = DesignSystem.Colors.accent
        } else if accuracy >= 0.4 {
            rating = "Keep Practicing"
            ratingColor = DesignSystem.Colors.textSecondary
        } else {
            rating = "Try Again"
            ratingColor = DesignSystem.Colors.textSecondary
        }

        let ratingLabel = SKLabelNode(text: rating)
        ratingLabel.fontName = DesignSystem.Typography.bodyFont
        ratingLabel.fontSize = DesignSystem.Typography.bodySize
        ratingLabel.fontColor = ratingColor
        ratingLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(ratingLabel)
    }

    private func setupButtons() {
        let centerX = size.width / 2

        // Retry button
        let retryButton = DesignSystem.createButton(
            title: "Play Again",
            width: min(280, size.width - 80),
            height: 60,
            style: .primary
        )
        retryButton.position = CGPoint(x: centerX, y: 180)
        retryButton.name = "retryButton"
        addChild(retryButton)

        // Main Menu button
        let menuButton = DesignSystem.createButton(
            title: "Main Menu",
            width: min(280, size.width - 80),
            height: 60,
            style: .secondary
        )
        menuButton.position = CGPoint(x: centerX, y: 110)
        menuButton.name = "menuButton"
        addChild(menuButton)

        // Share button
        let shareButton = DesignSystem.createButton(
            title: "Share",
            width: min(280, size.width - 80),
            height: 50,
            style: .icon
        )
        shareButton.position = CGPoint(x: centerX, y: 50)
        shareButton.name = "shareButton"
        addChild(shareButton)
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
        let press = SKAction.scale(to: 0.95, duration: 0.1)
        let release = SKAction.scale(to: 1.0, duration: 0.1)
        node.run(SKAction.sequence([press, release]))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            switch name {
            case "retryButton":
                self.retry()
            case "menuButton":
                self.goToMainMenu()
            case "shareButton":
                self.shareScore()
            default:
                break
            }
        }
    }

    private func retry() {
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(gameScene, transition: transition)
    }

    private func goToMainMenu() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill

        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(menuScene, transition: transition)
    }

    private func shareScore() {
        // Show feedback message (actual sharing would require UIActivityViewController)
        let message = SKLabelNode(text: "Score: \(finalScore) | Wave: \(waveReached)")
        message.fontName = DesignSystem.Typography.bodyFont
        message.fontSize = DesignSystem.Typography.bodySize
        message.fontColor = DesignSystem.Colors.success
        message.position = CGPoint(x: size.width / 2, y: size.height / 2)
        message.zPosition = 100
        addChild(message)

        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 1.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        message.alpha = 0
        message.run(SKAction.sequence([fadeIn, wait, fadeOut, remove]))
    }
}
