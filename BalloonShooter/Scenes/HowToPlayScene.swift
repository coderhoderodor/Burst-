//
//  HowToPlayScene.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//  Redesigned on 11/20/25 - Paginated Tutorial
//

import SpriteKit

class HowToPlayScene: SKScene {

    private var currentPage = 0
    private let totalPages = 4
    private var contentContainer: SKNode?
    private var pageIndicators: [SKShapeNode] = []

    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupContentContainer()
        setupNavigation()
        setupPageIndicators()
        showPage(0)
    }

    private func setupBackground() {
        let gradient = DesignSystem.createGradientBackground(size: self.size)
        gradient.zPosition = -10
        addChild(gradient)
    }

    private func setupTitle() {
        let title = SKLabelNode(text: "How to Play")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.titleSize
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(title)

        // Add text stroke
        let stroke = SKLabelNode(text: "How to Play")
        stroke.fontName = DesignSystem.Typography.titleFont
        stroke.fontSize = DesignSystem.Typography.titleSize
        stroke.fontColor = DesignSystem.Colors.textStroke
        stroke.position = CGPoint(x: 0, y: -3)
        stroke.zPosition = -1
        title.addChild(stroke)
    }

    private func setupContentContainer() {
        contentContainer = SKNode()
        contentContainer?.position = CGPoint(x: size.width / 2, y: size.height / 2 + 20)
        if let container = contentContainer {
            addChild(container)
        }
    }

    private func setupNavigation() {
        let centerY = size.height / 2

        // Previous button
        let prevButton = DesignSystem.createIconButton(icon: "PREV", size: 50)
        prevButton.position = CGPoint(x: 50, y: centerY)
        prevButton.name = "prevButton"
        addChild(prevButton)

        // Next button
        let nextButton = DesignSystem.createIconButton(icon: "NEXT", size: 50)
        nextButton.position = CGPoint(x: size.width - 50, y: centerY)
        nextButton.name = "nextButton"
        addChild(nextButton)

        // Back button
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

    private func setupPageIndicators() {
        let centerX = size.width / 2
        let yPos: CGFloat = 140
        let dotSize: CGFloat = 12
        let spacing: CGFloat = 20
        let totalWidth = CGFloat(totalPages - 1) * spacing

        for i in 0..<totalPages {
            let xPos = centerX - totalWidth/2 + CGFloat(i) * spacing
            let dot = SKShapeNode(circleOfRadius: dotSize/2)
            dot.fillColor = i == 0 ? .white : UIColor(white: 1.0, alpha: 0.3)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: xPos, y: yPos)
            pageIndicators.append(dot)
            addChild(dot)
        }
    }

    private func showPage(_ page: Int) {
        currentPage = page
        contentContainer?.removeAllChildren()

        // Update page indicators
        for (index, indicator) in pageIndicators.enumerated() {
            indicator.fillColor = index == page ? .white : UIColor(white: 1.0, alpha: 0.3)
        }

        // Create content for the current page
        switch page {
        case 0:
            showObjectivePage()
        case 1:
            showControlsPage()
        case 2:
            showBalloonTypesPage()
        case 3:
            showTipsPage()
        default:
            break
        }
    }

    private func showObjectivePage() {
        let cardWidth: CGFloat = min(350, size.width - 40)

        // Page title
        let title = SKLabelNode(text: "Objective")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.subtitleSize
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 120)
        contentContainer?.addChild(title)

        // Description text
        let lines = [
            "Pop balloons to score points",
            "while avoiding bomb balloons!",
            "",
            "Bomb balloons drop bombs",
            "when hit, costing you lives.",
            "",
            "Complete waves for",
            "bonus points and rewards!"
        ]

        var yPos: CGFloat = 60
        for line in lines {
            let label = SKLabelNode(text: line)
            label.fontName = line.isEmpty ? DesignSystem.Typography.bodyFont : DesignSystem.Typography.bodyFont
            label.fontSize = DesignSystem.Typography.bodySize
            label.fontColor = line.contains("Bomb") || line.contains("Complete") ?
                DesignSystem.Colors.accent : .white
            label.position = CGPoint(x: 0, y: yPos)
            contentContainer?.addChild(label)
            yPos -= line.isEmpty ? 10 : 30
        }
    }

    private func showControlsPage() {
        // Page title
        let title = SKLabelNode(text: "Controls")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.subtitleSize
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 120)
        contentContainer?.addChild(title)

        // Step-by-step instructions
        let steps = [
            ("1", "Touch and drag anywhere", "to aim your bow"),
            ("2", "Pull back to increase", "arrow power"),
            ("3", "Release to shoot", "the arrow"),
            ("4", "Pull fully for", "SLOW MOTION!")
        ]

        var yPos: CGFloat = 50
        for (icon, line1, line2) in steps {
            let iconLabel = SKLabelNode(text: icon)
            iconLabel.fontSize = 32
            iconLabel.position = CGPoint(x: -120, y: yPos)
            iconLabel.verticalAlignmentMode = .center
            contentContainer?.addChild(iconLabel)

            let text1 = SKLabelNode(text: line1)
            text1.fontName = DesignSystem.Typography.titleFont
            text1.fontSize = DesignSystem.Typography.bodySize
            text1.fontColor = .white
            text1.horizontalAlignmentMode = .left
            text1.position = CGPoint(x: -80, y: yPos + 10)
            contentContainer?.addChild(text1)

            let text2 = SKLabelNode(text: line2)
            text2.fontName = DesignSystem.Typography.bodyFont
            text2.fontSize = DesignSystem.Typography.captionSize
            text2.fontColor = DesignSystem.Colors.textSecondary
            text2.horizontalAlignmentMode = .left
            text2.position = CGPoint(x: -80, y: yPos - 10)
            contentContainer?.addChild(text2)

            yPos -= 70
        }
    }

    private func showBalloonTypesPage() {
        // Page title
        let title = SKLabelNode(text: "Balloon Types")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.subtitleSize
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 140)
        contentContainer?.addChild(title)

        // Balloon types with visual indicators
        let balloons: [(color: UIColor, name: String, points: String, note: String)] = [
            (DesignSystem.Colors.regular, "Regular", "10 pts", "Basic balloon"),
            (DesignSystem.Colors.bomb, "Bomb", "0 pts", "Drops bomb!"),
            (DesignSystem.Colors.shield, "Shield", "20 pts", "Protects from 1 bomb"),
            (DesignSystem.Colors.golden, "Golden", "50 pts", "Fast & valuable"),
            (DesignSystem.Colors.multi, "Multi", "15 pts", "Splits into 3"),
            (DesignSystem.Colors.mystery, "Mystery", "???", "Good or bad!"),
            (DesignSystem.Colors.speed, "Speed", "25 pts", "Very fast")
        ]

        var yPos: CGFloat = 80
        for balloon in balloons {
            // Balloon circle
            let circle = SKShapeNode(circleOfRadius: 15)
            circle.fillColor = balloon.color
            circle.strokeColor = .white
            circle.lineWidth = 2
            circle.position = CGPoint(x: -130, y: yPos)
            contentContainer?.addChild(circle)

            // Name
            let nameLabel = SKLabelNode(text: balloon.name)
            nameLabel.fontName = DesignSystem.Typography.titleFont
            nameLabel.fontSize = 16
            nameLabel.fontColor = .white
            nameLabel.horizontalAlignmentMode = .left
            nameLabel.verticalAlignmentMode = .center
            nameLabel.position = CGPoint(x: -100, y: yPos + 5)
            contentContainer?.addChild(nameLabel)

            // Points
            let pointsLabel = SKLabelNode(text: balloon.points)
            pointsLabel.fontName = DesignSystem.Typography.numberFont
            pointsLabel.fontSize = 14
            pointsLabel.fontColor = DesignSystem.Colors.accent
            pointsLabel.horizontalAlignmentMode = .left
            pointsLabel.verticalAlignmentMode = .center
            pointsLabel.position = CGPoint(x: -100, y: yPos - 12)
            contentContainer?.addChild(pointsLabel)

            // Note
            let noteLabel = SKLabelNode(text: balloon.note)
            noteLabel.fontName = DesignSystem.Typography.bodyFont
            noteLabel.fontSize = 12
            noteLabel.fontColor = balloon.note.contains("bomb") ?
                DesignSystem.Colors.warning : DesignSystem.Colors.textSecondary
            noteLabel.horizontalAlignmentMode = .left
            noteLabel.verticalAlignmentMode = .center
            noteLabel.position = CGPoint(x: 10, y: yPos)
            contentContainer?.addChild(noteLabel)

            yPos -= 40
        }
    }

    private func showTipsPage() {
        // Page title
        let title = SKLabelNode(text: "Pro Tips")
        title.fontName = DesignSystem.Typography.titleFont
        title.fontSize = DesignSystem.Typography.subtitleSize
        title.fontColor = .white
        title.position = CGPoint(x: 0, y: 120)
        contentContainer?.addChild(title)

        let tips = [
            "Build combos for bonus points",
            "   Hit balloons consecutively",
            "",
            "Prioritize bomb balloons",
            "   Take them out early or avoid!",
            "",
            "Complete waves for bonuses",
            "   Extra points + life regeneration",
            "",
            "Use slow motion wisely",
            "   Pull fully for precise shots",
            "",
            "Shield balloons = safety",
            "   They protect from one bomb"
        ]

        var yPos: CGFloat = 60
        for tip in tips {
            let label = SKLabelNode(text: tip)
            label.fontName = tip.hasPrefix("   ") ?
                DesignSystem.Typography.bodyFont :
                DesignSystem.Typography.titleFont
            label.fontSize = tip.hasPrefix("   ") ? 14 : 16
            label.fontColor = tip.hasPrefix("   ") ?
                DesignSystem.Colors.textSecondary : .white
            label.horizontalAlignmentMode = .left
            label.position = CGPoint(x: -140, y: yPos)
            contentContainer?.addChild(label)
            yPos -= tip.isEmpty ? 8 : 24
        }
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
        let press = SKAction.scale(to: 0.9, duration: 0.1)
        let release = SKAction.scale(to: 1.0, duration: 0.1)

        switch name {
        case "prevButton":
            if currentPage > 0 {
                node.run(SKAction.sequence([press, release]))
                showPage(currentPage - 1)
            }
        case "nextButton":
            if currentPage < totalPages - 1 {
                node.run(SKAction.sequence([press, release]))
                showPage(currentPage + 1)
            }
        case "backButton":
            node.run(SKAction.sequence([press, release]))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.goBack()
            }
        default:
            break
        }
    }

    private func goBack() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill

        let transition = SKTransition.push(with: .right, duration: 0.3)
        view?.presentScene(menuScene, transition: transition)
    }
}
