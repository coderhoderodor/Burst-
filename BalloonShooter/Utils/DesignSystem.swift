//
//  DesignSystem.swift
//  BalloonShooter
//
//  Created by Claude on 11/7/25.
//

import SpriteKit

/// Centralized design system for consistent UI/UX
struct DesignSystem {

    // MARK: - Colors
    struct Colors {
        // Balloon Colors (High Contrast)
        static let regular = UIColor(red: 1.0, green: 0.27, blue: 0.27, alpha: 1.0)      // #FF4444
        static let bomb = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)       // #2D2D2D
        static let bombWarning = UIColor(red: 1.0, green: 0.85, blue: 0.0, alpha: 1.0)  // #FFD900
        static let shield = UIColor(red: 0.0, green: 0.67, blue: 1.0, alpha: 1.0)       // #00AAFF
        static let golden = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)       // #FFD700
        static let multi = UIColor(red: 0.61, green: 0.35, blue: 0.71, alpha: 1.0)      // #9B59B6
        static let mystery = UIColor(red: 1.0, green: 0.55, blue: 0.0, alpha: 1.0)      // #FF8C00
        static let speed = UIColor(red: 0.0, green: 1.0, blue: 0.53, alpha: 1.0)        // #00FF88

        // UI Colors
        static let hudBackground = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        static let buttonPrimary = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        static let buttonSecondary = UIColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 1.0)
        static let textPrimary = UIColor.white
        static let textStroke = UIColor.black
        static let warning = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        static let success = UIColor(red: 0.3, green: 1.0, blue: 0.3, alpha: 1.0)
    }

    // MARK: - Typography
    struct Typography {
        static let titleFont = "Arial-BoldMT"
        static let bodyFont = "Arial"
        static let buttonFont = "Arial-BoldMT"

        static let titleSize: CGFloat = 48
        static let subtitleSize: CGFloat = 24
        static let bodySize: CGFloat = 18
        static let numberSize: CGFloat = 32
        static let buttonSize: CGFloat = 28
    }

    // MARK: - Spacing
    struct Spacing {
        static let margin: CGFloat = 20
        static let elementSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 24
        static let buttonPadding: CGFloat = 16
    }

    // MARK: - Animation
    struct Animation {
        static let fast: TimeInterval = 0.15
        static let normal: TimeInterval = 0.3
        static let slow: TimeInterval = 0.5

        static let timingFunction = SKActionTimingMode.easeOut
    }

    // MARK: - Effects
    struct Effects {
        static func createShadow(for node: SKNode, radius: CGFloat = 4) {
            // Note: SpriteKit doesn't have built-in shadows, but we can simulate with duplicate nodes
        }

        static func createStrokedLabel(text: String, fontSize: CGFloat, fontColor: UIColor = Colors.textPrimary) -> SKNode {
            let container = SKNode()

            // Stroke (background)
            let stroke = SKLabelNode(text: text)
            stroke.fontName = Typography.titleFont
            stroke.fontSize = fontSize
            stroke.fontColor = Colors.textStroke
            stroke.verticalAlignmentMode = .center

            // Create stroke effect with multiple offset labels
            for x in [-2.0, -2.0, 2.0, 2.0, -2.0, 0.0, 2.0, 0.0] as [CGFloat] {
                for y in [-2.0, 2.0, -2.0, 2.0, 0.0, -2.0, 0.0, 2.0] as [CGFloat] {
                    let strokeLayer = SKLabelNode(text: text)
                    strokeLayer.fontName = Typography.titleFont
                    strokeLayer.fontSize = fontSize
                    strokeLayer.fontColor = Colors.textStroke
                    strokeLayer.position = CGPoint(x: x, y: y)
                    strokeLayer.verticalAlignmentMode = .center
                    strokeLayer.zPosition = -1
                    container.addChild(strokeLayer)
                }
            }

            // Main text
            let mainText = SKLabelNode(text: text)
            mainText.fontName = Typography.titleFont
            mainText.fontSize = fontSize
            mainText.fontColor = fontColor
            mainText.verticalAlignmentMode = .center
            mainText.zPosition = 1
            container.addChild(mainText)

            return container
        }

        static func pulseAnimation(scale: CGFloat = 1.1, duration: TimeInterval = 0.5) -> SKAction {
            let scaleUp = SKAction.scale(to: scale, duration: duration / 2)
            scaleUp.timingMode = .easeInEaseOut
            let scaleDown = scaleUp.reversed()
            return SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        }

        static func popInAnimation() -> SKAction {
            let scale = SKAction.scale(to: 1.0, duration: Animation.normal)
            scale.timingMode = .easeOut
            return scale
        }

        static func buttonPressAnimation() -> SKAction {
            let press = SKAction.scale(to: 0.9, duration: Animation.fast)
            let release = SKAction.scale(to: 1.0, duration: Animation.fast)
            return SKAction.sequence([press, release])
        }
    }

    // MARK: - Particle Presets
    struct Particles {
        static func createPopParticles(color: UIColor) -> SKEmitterNode {
            let particles = SKEmitterNode()
            particles.particleTexture = TextureGenerator.sparkTexture
            particles.particleBirthRate = 150
            particles.numParticlesToEmit = 30
            particles.particleLifetime = 0.6
            particles.particleSpeed = 120
            particles.particleSpeedRange = 60
            particles.emissionAngleRange = .pi * 2
            particles.particleScale = 0.35
            particles.particleScaleRange = 0.25
            particles.particleScaleSpeed = -0.3
            particles.particleAlpha = 1.0
            particles.particleAlphaSpeed = -1.8
            particles.particleColor = color
            particles.particleColorBlendFactor = 1.0
            return particles
        }

        static func createExplosionParticles() -> SKEmitterNode {
            let particles = SKEmitterNode()
            particles.particleTexture = TextureGenerator.sparkTexture
            particles.particleBirthRate = 300
            particles.numParticlesToEmit = 80
            particles.particleLifetime = 1.0
            particles.particleSpeed = 200
            particles.particleSpeedRange = 80
            particles.emissionAngleRange = .pi * 2
            particles.particleScale = 0.5
            particles.particleScaleRange = 0.4
            particles.particleScaleSpeed = -0.4
            particles.particleAlpha = 1.0
            particles.particleAlphaSpeed = -1.2
            particles.particleColor = .orange
            particles.particleColorBlendFactor = 1.0
            particles.particleColorSequence = nil
            return particles
        }
    }

    // MARK: - UI Components
    static func createButton(title: String, width: CGFloat = 200, isPrimary: Bool = true) -> SKNode {
        let container = SKNode()

        // Button background
        let background = SKShapeNode(rect: CGRect(x: -width/2, y: -25, width: width, height: 50), cornerRadius: 25)
        background.fillColor = isPrimary ? Colors.buttonPrimary : Colors.buttonSecondary
        background.strokeColor = .white
        background.lineWidth = 3
        background.zPosition = 0
        container.addChild(background)

        // Shadow effect (darker copy offset down)
        let shadow = SKShapeNode(rect: CGRect(x: -width/2, y: -27, width: width, height: 50), cornerRadius: 25)
        shadow.fillColor = UIColor(white: 0, alpha: 0.3)
        shadow.strokeColor = .clear
        shadow.zPosition = -1
        container.addChild(shadow)

        // Button text
        let label = SKLabelNode(text: title)
        label.fontName = Typography.buttonFont
        label.fontSize = Typography.buttonSize
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.zPosition = 1
        container.addChild(label)

        return container
    }

    static func createHUDPanel(size: CGSize) -> SKShapeNode {
        let panel = SKShapeNode(rect: CGRect(origin: .zero, size: size), cornerRadius: 10)
        panel.fillColor = Colors.hudBackground
        panel.strokeColor = UIColor(white: 1, alpha: 0.3)
        panel.lineWidth = 2
        return panel
    }
}
