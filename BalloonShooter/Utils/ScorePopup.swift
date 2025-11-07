//
//  ScorePopup.swift
//  BalloonShooter
//
//  Created by Claude on 11/7/25.
//

import SpriteKit

class ScorePopup {

    static func show(points: Int, at position: CGPoint, in scene: SKScene, isCombo: Bool = false) {
        let container = SKNode()
        container.position = position
        container.zPosition = 200

        // Create score text with stroke
        let scoreText = "+\(points)"
        let label = DesignSystem.Effects.createStrokedLabel(
            text: scoreText,
            fontSize: isCombo ? 40 : 32,
            fontColor: isCombo ? DesignSystem.Colors.success : DesignSystem.Colors.golden
        )

        container.addChild(label)

        // Add to scene
        scene.addChild(container)

        // Animation sequence
        let moveUp = SKAction.moveBy(x: 0, y: 80, duration: 1.0)
        moveUp.timingMode = .easeOut

        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)

        let initialAnimation = SKAction.sequence([scaleUp, scaleDown])
        let mainAnimation = SKAction.group([moveUp, SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            fadeOut
        ])])

        let remove = SKAction.removeFromParent()

        container.run(SKAction.sequence([initialAnimation, mainAnimation, remove]))

        // Add sparkle effect for big scores
        if points >= 50 {
            addSparkles(to: container)
        }
    }

    private static func addSparkles(to node: SKNode) {
        for _ in 0..<3 {
            let sparkle = SKShapeNode(circleOfRadius: 3)
            sparkle.fillColor = .yellow
            sparkle.strokeColor = .white
            sparkle.position = CGPoint(
                x: CGFloat.random(in: -20...20),
                y: CGFloat.random(in: -10...10)
            )

            node.addChild(sparkle)

            let moveRandom = SKAction.moveBy(
                x: CGFloat.random(in: -30...30),
                y: CGFloat.random(in: 20...60),
                duration: 0.8
            )
            let fadeOut = SKAction.fadeOut(withDuration: 0.6)
            let remove = SKAction.removeFromParent()

            sparkle.run(SKAction.sequence([
                SKAction.group([moveRandom, fadeOut]),
                remove
            ]))
        }
    }

    static func showComboText(combo: Int, at position: CGPoint, in scene: SKScene) {
        let container = SKNode()
        container.position = position
        container.zPosition = 200

        let comboText = "COMBO x\(combo)!"
        let label = DesignSystem.Effects.createStrokedLabel(
            text: comboText,
            fontSize: 36,
            fontColor: DesignSystem.Colors.success
        )

        container.addChild(label)
        scene.addChild(container)

        // Pulsing animation
        let pulse = DesignSystem.Effects.pulseAnimation(scale: 1.2, duration: 0.4)
        let fadeOut = SKAction.sequence([
            SKAction.wait(forDuration: 0.8),
            SKAction.fadeOut(withDuration: 0.3)
        ])
        let remove = SKAction.removeFromParent()

        container.run(SKAction.sequence([
            SKAction.group([pulse, fadeOut]),
            remove
        ]))
    }

    static func showBonusText(_ text: String, at position: CGPoint, in scene: SKScene, color: UIColor = .yellow) {
        let container = SKNode()
        container.position = position
        container.zPosition = 200

        let label = DesignSystem.Effects.createStrokedLabel(
            text: text,
            fontSize: 30,
            fontColor: color
        )

        container.addChild(label)
        scene.addChild(container)

        let moveUp = SKAction.moveBy(x: 0, y: 60, duration: 1.2)
        moveUp.timingMode = .easeOut
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let remove = SKAction.removeFromParent()

        container.run(SKAction.sequence([
            SKAction.group([moveUp, fadeOut]),
            remove
        ]))
    }
}
