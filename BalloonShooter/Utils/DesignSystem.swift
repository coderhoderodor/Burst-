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

        // Modern UI Colors - Simplistic & Clean
        static let skyBlue = UIColor(red: 0.53, green: 0.81, blue: 0.98, alpha: 1.0)    // #87CEEB
        static let skyBlueDark = UIColor(red: 0.41, green: 0.70, blue: 0.89, alpha: 1.0) // #68B3E3
        static let cloudWhite = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)    // White with slight transparency
        static let softShadow = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)   // Subtle shadow

        // Button Colors - Vibrant but friendly
        static let buttonPrimary = UIColor(red: 0.3, green: 0.69, blue: 0.31, alpha: 1.0)    // #4CAF50 Green
        static let buttonPrimaryHover = UIColor(red: 0.26, green: 0.59, blue: 0.26, alpha: 1.0) // #429742 Darker
        static let buttonSecondary = UIColor(red: 0.25, green: 0.46, blue: 0.85, alpha: 1.0)   // #3F75D9 Blue
        static let buttonAccent = UIColor(red: 1.0, green: 0.60, blue: 0.0, alpha: 1.0)       // #FF9900 Orange

        // Background Colors
        static let backgroundGradientTop = UIColor(red: 0.53, green: 0.81, blue: 0.98, alpha: 1.0)
        static let backgroundGradientBottom = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        static let hudBackground = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3) // More subtle
        static let cardBackground = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25) // Glass effect

        // Text Colors
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        static let textDark = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        static let textStroke = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        // State Colors
        static let warning = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        static let success = UIColor(red: 0.3, green: 0.85, blue: 0.4, alpha: 1.0)
        static let accent = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Gold
    }

    // MARK: - Typography
    struct Typography {
        static let titleFont = "Arial-BoldMT"
        static let bodyFont = "Arial"
        static let buttonFont = "Arial-BoldMT"
        static let numberFont = "Arial-BoldMT"

        static let heroSize: CGFloat = 56        // Main title
        static let titleSize: CGFloat = 44       // Scene titles
        static let subtitleSize: CGFloat = 24    // Subtitles
        static let bodySize: CGFloat = 18        // Body text
        static let captionSize: CGFloat = 14     // Small text
        static let numberSize: CGFloat = 36      // Score numbers
        static let buttonLargeSize: CGFloat = 32 // Primary buttons
        static let buttonSize: CGFloat = 24      // Secondary buttons
    }

    // MARK: - Spacing
    struct Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let huge: CGFloat = 48

        static let margin: CGFloat = 20
        static let elementSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 32
        static let buttonPadding: CGFloat = 16
        static let cardPadding: CGFloat = 20
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

    enum ButtonStyle {
        case primary
        case secondary
        case accent
        case icon
    }

    static func createButton(title: String, width: CGFloat = 200, height: CGFloat = 60, style: ButtonStyle = .primary) -> SKNode {
        let container = SKNode()
        let cornerRadius = height / 2

        // Shadow effect (subtle)
        let shadow = SKShapeNode(rect: CGRect(x: -width/2, y: -(height/2) - 2, width: width, height: height), cornerRadius: cornerRadius)
        shadow.fillColor = Colors.softShadow
        shadow.strokeColor = .clear
        shadow.zPosition = -1
        container.addChild(shadow)

        // Button background
        let background = SKShapeNode(rect: CGRect(x: -width/2, y: -height/2, width: width, height: height), cornerRadius: cornerRadius)

        switch style {
        case .primary:
            background.fillColor = Colors.buttonPrimary
            background.strokeColor = .clear
        case .secondary:
            background.fillColor = Colors.buttonSecondary
            background.strokeColor = .clear
        case .accent:
            background.fillColor = Colors.buttonAccent
            background.strokeColor = .clear
        case .icon:
            background.fillColor = Colors.cardBackground
            background.strokeColor = Colors.cloudWhite
            background.lineWidth = 2
        }

        background.zPosition = 0
        container.addChild(background)

        // Button text
        let label = SKLabelNode(text: title)
        label.fontName = Typography.buttonFont
        label.fontSize = style == .primary ? Typography.buttonLargeSize : Typography.buttonSize
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.zPosition = 1
        container.addChild(label)

        return container
    }

    static func createCard(width: CGFloat, height: CGFloat) -> SKShapeNode {
        let card = SKShapeNode(rect: CGRect(x: -width/2, y: -height/2, width: width, height: height), cornerRadius: 20)
        card.fillColor = Colors.cardBackground
        card.strokeColor = Colors.cloudWhite
        card.lineWidth = 2
        return card
    }

    static func createIconButton(icon: String, size: CGFloat = 50) -> SKNode {
        let container = SKNode()

        let background = SKShapeNode(circleOfRadius: size/2)
        background.fillColor = Colors.cardBackground
        background.strokeColor = Colors.cloudWhite
        background.lineWidth = 2
        container.addChild(background)

        let label = SKLabelNode(text: icon)
        label.fontSize = size * 0.5
        label.verticalAlignmentMode = .center
        container.addChild(label)

        return container
    }

    static func createHUDPanel(size: CGSize) -> SKShapeNode {
        let panel = SKShapeNode(rect: CGRect(origin: .zero, size: size), cornerRadius: 10)
        panel.fillColor = Colors.hudBackground
        panel.strokeColor = UIColor(white: 1, alpha: 0.2)
        panel.lineWidth = 1
        return panel
    }

    static func createGradientBackground(size: CGSize) -> SKNode {
        let container = SKNode()

        // Simple two-color gradient simulation using overlapping shapes
        let background = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        background.fillColor = Colors.backgroundGradientBottom
        background.strokeColor = .clear
        container.addChild(background)

        let topGradient = SKShapeNode(rect: CGRect(x: 0, y: size.height * 0.3, width: size.width, height: size.height * 0.7))
        topGradient.fillColor = Colors.backgroundGradientTop
        topGradient.strokeColor = .clear
        container.addChild(topGradient)

        return container
    }
}
