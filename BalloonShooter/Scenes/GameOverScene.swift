//
//  GameOverScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class GameOverScene: SKScene {

    var finalScore: Int = 0
    var waveReached: Int = 1
    var accuracy: Double = 0.0

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupStats()
        setupButtons()
    }

    private func setupBackground() {
        let background = SKShapeNode(rect: self.frame)
        background.fillColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        background.strokeColor = .clear
        background.zPosition = -10
        addChild(background)
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "Game Over")
        title.fontSize = 56
        title.fontName = "Arial-BoldMT"
        title.fontColor = .red
        title.position = CGPoint(x: size.width / 2, y: size.height - 150)
        addChild(title)

        // Add pulsing animation
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        title.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }

    private func setupStats() {
        let centerX = size.width / 2
        var yPos = size.height - 250

        // Final Score
        let scoreLabel = SKLabelNode(text: "Final Score")
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "Arial"
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(scoreLabel)

        yPos -= 40
        let scoreValue = SKLabelNode(text: "\(finalScore)")
        scoreValue.fontSize = 48
        scoreValue.fontName = "Arial-BoldMT"
        scoreValue.fontColor = .yellow
        scoreValue.position = CGPoint(x: centerX, y: yPos)
        addChild(scoreValue)

        // High Score
        let gameManager = GameManager.shared
        let highScore = DataManager.shared.getHighScore(for: gameManager.currentMode)

        yPos -= 60
        let highScoreLabel = SKLabelNode(text: "Best: \(highScore)")
        highScoreLabel.fontSize = 20
        highScoreLabel.fontName = "Arial"
        highScoreLabel.fontColor = finalScore >= highScore ? .green : .white
        highScoreLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(highScoreLabel)

        if finalScore >= highScore && finalScore > 0 {
            let newRecordLabel = SKLabelNode(text: "🎉 NEW RECORD! 🎉")
            newRecordLabel.fontSize = 28
            newRecordLabel.fontName = "Arial-BoldMT"
            newRecordLabel.fontColor = .yellow
            newRecordLabel.position = CGPoint(x: centerX, y: yPos - 40)
            addChild(newRecordLabel)
            yPos -= 40
        }

        // Wave Reached
        yPos -= 60
        let waveLabel = SKLabelNode(text: "Wave Reached: \(waveReached)")
        waveLabel.fontSize = 24
        waveLabel.fontName = "Arial"
        waveLabel.fontColor = .white
        waveLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(waveLabel)

        // Accuracy
        yPos -= 50
        let accuracyPercent = Int(accuracy * 100)
        let accuracyLabel = SKLabelNode(text: "Accuracy: \(accuracyPercent)%")
        accuracyLabel.fontSize = 24
        accuracyLabel.fontName = "Arial"
        accuracyLabel.fontColor = .white
        accuracyLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(accuracyLabel)

        // Accuracy rating
        let rating: String
        if accuracy >= 0.8 {
            rating = "🎯 Sharpshooter!"
        } else if accuracy >= 0.6 {
            rating = "👍 Good Aim"
        } else if accuracy >= 0.4 {
            rating = "📈 Keep Practicing"
        } else {
            rating = "🎈 Try Again"
        }

        yPos -= 35
        let ratingLabel = SKLabelNode(text: rating)
        ratingLabel.fontSize = 20
        ratingLabel.fontName = "Arial"
        ratingLabel.fontColor = .cyan
        ratingLabel.position = CGPoint(x: centerX, y: yPos)
        addChild(ratingLabel)
    }

    private func setupButtons() {
        // Retry button
        let retryButton = createButton(text: "Retry", at: CGPoint(x: size.width / 2, y: 200))
        retryButton.name = "retryButton"
        addChild(retryButton)

        // Main Menu button
        let menuButton = createButton(text: "Main Menu", at: CGPoint(x: size.width / 2, y: 130))
        menuButton.name = "menuButton"
        addChild(menuButton)

        // Share button
        let shareButton = createButton(text: "Share Score", at: CGPoint(x: size.width / 2, y: 60))
        shareButton.name = "shareButton"
        addChild(shareButton)
    }

    private func createButton(text: String, at position: CGPoint) -> SKNode {
        let container = SKNode()
        container.position = position

        let background = SKShapeNode(rect: CGRect(x: -100, y: -25, width: 200, height: 50), cornerRadius: 25)
        background.fillColor = .systemBlue
        background.strokeColor = .white
        background.lineWidth = 2
        container.addChild(background)

        let label = SKLabelNode(text: text)
        label.fontSize = 24
        label.fontName = "Arial-BoldMT"
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        container.addChild(label)

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
        switch name {
        case "retryButton":
            retry()
        case "menuButton":
            goToMainMenu()
        case "shareButton":
            shareScore()
        default:
            break
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
        // In a real implementation, this would trigger UIActivityViewController
        // For now, just show a message
        let message = SKLabelNode(text: "Score shared! 🎉")
        message.fontSize = 24
        message.fontColor = .green
        message.position = CGPoint(x: size.width / 2, y: size.height / 2)
        message.zPosition = 100
        addChild(message)

        let fadeOut = SKAction.fadeOut(withDuration: 2.0)
        let remove = SKAction.removeFromParent()
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), fadeOut, remove]))
    }
}
