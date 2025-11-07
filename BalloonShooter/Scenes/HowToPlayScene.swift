//
//  HowToPlayScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class HowToPlayScene: SKScene {

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupInstructions()
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
        let title = SKLabelNode(text: "How to Play")
        title.fontSize = 48
        title.fontName = "Arial-BoldMT"
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(title)
    }

    private func setupInstructions() {
        let instructions = [
            "OBJECTIVE",
            "Pop balloons to score points while",
            "avoiding bomb balloons!",
            "",
            "CONTROLS",
            "1. Touch and drag to aim your bow",
            "2. Pull back to increase power",
            "3. Release to shoot",
            "",
            "BALLOON TYPES",
            "• Regular: 10 points (red)",
            "• Bomb: Drops a bomb when hit! (dark)",
            "• Shield: Protects from one bomb (blue)",
            "• Golden: 50 points, moves fast (yellow)",
            "• Multi: Splits into 3 balloons (purple)",
            "• Mystery: Could be good or bad! (orange)",
            "• Speed: 25 points, moves quickly (green)",
            "",
            "TIPS",
            "• Build combos for bonus points",
            "• Watch out for bomb balloons",
            "• Complete waves for bonuses",
            "• Pull back fully for slow motion",
        ]

        var yPos = size.height - 180
        let lineHeight: CGFloat = 30

        for instruction in instructions {
            let label = SKLabelNode(text: instruction)

            if instruction.isEmpty {
                yPos -= lineHeight / 2
                continue
            }

            // Check if it's a section title (all caps with no punctuation at end)
            let isSectionTitle = instruction.uppercased() == instruction &&
                                 !instruction.contains("•") &&
                                 !instruction.contains(":") &&
                                 instruction.count < 20

            if isSectionTitle {
                label.fontSize = 28
                label.fontName = "Arial-BoldMT"
                label.fontColor = .yellow
                yPos -= lineHeight / 2
            } else {
                label.fontSize = 18
                label.fontName = "Arial"
                label.fontColor = .white
            }

            label.position = CGPoint(x: size.width / 2, y: yPos)
            addChild(label)

            yPos -= lineHeight
        }
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
            if node.name == "backButton" {
                goBack()
                return
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
