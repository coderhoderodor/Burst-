//
//  BalloonNode.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class BalloonNode: SKShapeNode {
    let balloonType: BalloonType
    var velocity: CGVector = .zero

    init(type: BalloonType, at position: CGPoint) {
        self.balloonType = type
        super.init()

        // Create balloon shape
        let size = type.size
        let path = UIBezierPath(ovalIn: CGRect(x: -size/2, y: -size/2, width: size, height: size))
        self.path = path.cgPath
        self.fillColor = type.color
        // White outline for better contrast
        self.strokeColor = type == .bomb ? DesignSystem.Colors.bombWarning : .white
        self.lineWidth = type == .bomb ? 3 : 2
        self.position = position

        // Add shadow effect (darker circle behind)
        let shadowSize = size + 4
        let shadowPath = UIBezierPath(ovalIn: CGRect(x: -shadowSize/2, y: -shadowSize/2 - 2, width: shadowSize, height: shadowSize))
        let shadow = SKShapeNode(path: shadowPath.cgPath)
        shadow.fillColor = UIColor(white: 0, alpha: 0.2)
        shadow.strokeColor = .clear
        shadow.zPosition = -1
        addChild(shadow)

        // Add visual indicator based on type
        addVisualIndicator(for: type, size: size)

        // Physics body for collision detection
        self.physicsBody = SKPhysicsBody(circleOfRadius: size/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.balloon
        self.physicsBody?.contactTestBitMask = PhysicsCategory.arrow
        self.physicsBody?.collisionBitMask = 0

        // Add floating animation
        addFloatingAnimation()

        // Add horizontal movement for speed balloons
        if type == .speed {
            let moveDistance: CGFloat = 100
            let duration: TimeInterval = 1.5
            let moveAction = SKAction.sequence([
                SKAction.moveBy(x: moveDistance, y: 0, duration: duration),
                SKAction.moveBy(x: -moveDistance * 2, y: 0, duration: duration * 2),
                SKAction.moveBy(x: moveDistance, y: 0, duration: duration)
            ])
            run(SKAction.repeatForever(moveAction))
        }

        // Warning pulsing for bomb balloons
        if type == .bomb {
            let pulse = SKAction.sequence([
                SKAction.run { [weak self] in
                    self?.strokeColor = DesignSystem.Colors.bombWarning
                },
                SKAction.wait(forDuration: 0.5),
                SKAction.run { [weak self] in
                    self?.strokeColor = .white
                },
                SKAction.wait(forDuration: 0.5)
            ])
            run(SKAction.repeatForever(pulse), withKey: "bombWarning")
        }

        // Spawn animation
        setScale(0.1)
        let popIn = DesignSystem.Effects.popInAnimation()
        run(popIn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addVisualIndicator(for type: BalloonType, size: CGFloat) {
        let scale = size / 50.0 // Base size is 50

        switch type {
        case .regular:
            // Add shine effect
            let shine = SKShapeNode(circleOfRadius: size * 0.15)
            shine.fillColor = .white
            shine.strokeColor = .clear
            shine.alpha = 0.6
            shine.position = CGPoint(x: -size * 0.2, y: size * 0.2)
            addChild(shine)

        case .bomb:
            // Add skull symbol (simplified)
            let skull = createSkullSymbol(scale: scale)
            skull.position = CGPoint(x: 0, y: 0)
            addChild(skull)

        case .shield:
            // Add shield symbol
            let shield = createShieldSymbol(scale: scale)
            shield.position = CGPoint(x: 0, y: 0)
            addChild(shield)

        case .golden:
            // Add star/sparkle effect
            let star = createStarSymbol(scale: scale)
            star.position = CGPoint(x: 0, y: 0)
            addChild(star)

            // Add rotation animation for golden
            let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 2.0)
            star.run(SKAction.repeatForever(rotate))

        case .multi:
            // Add three small circles
            for i in 0..<3 {
                let angle = CGFloat(i) * (.pi * 2 / 3)
                let radius = size * 0.25
                let x = cos(angle) * radius
                let y = sin(angle) * radius

                let circle = SKShapeNode(circleOfRadius: size * 0.12)
                circle.fillColor = type.secondaryColor
                circle.strokeColor = .white
                circle.lineWidth = 1
                circle.position = CGPoint(x: x, y: y)
                addChild(circle)
            }

        case .mystery:
            // Add question mark
            let questionMark = createQuestionMarkSymbol(scale: scale)
            questionMark.position = CGPoint(x: 0, y: 0)
            addChild(questionMark)

        case .speed:
            // Add lightning bolt
            let lightning = createLightningSymbol(scale: scale)
            lightning.position = CGPoint(x: 0, y: 0)
            addChild(lightning)
        }
    }

    private func createSkullSymbol(scale: CGFloat) -> SKNode {
        let container = SKNode()

        // Skull outline (simplified circle)
        let head = SKShapeNode(circleOfRadius: 12 * scale)
        head.fillColor = .white
        head.strokeColor = .black
        head.lineWidth = 1
        container.addChild(head)

        // Eyes
        let leftEye = SKShapeNode(circleOfRadius: 3 * scale)
        leftEye.fillColor = .black
        leftEye.strokeColor = .clear
        leftEye.position = CGPoint(x: -5 * scale, y: 3 * scale)
        container.addChild(leftEye)

        let rightEye = SKShapeNode(circleOfRadius: 3 * scale)
        rightEye.fillColor = .black
        rightEye.strokeColor = .clear
        rightEye.position = CGPoint(x: 5 * scale, y: 3 * scale)
        container.addChild(rightEye)

        // X mouth
        let mouthPath = UIBezierPath()
        mouthPath.move(to: CGPoint(x: -4 * scale, y: -5 * scale))
        mouthPath.addLine(to: CGPoint(x: 4 * scale, y: -5 * scale))
        let mouth = SKShapeNode(path: mouthPath.cgPath)
        mouth.strokeColor = .black
        mouth.lineWidth = 2 * scale
        container.addChild(mouth)

        return container
    }

    private func createShieldSymbol(scale: CGFloat) -> SKNode {
        let shieldPath = UIBezierPath()
        shieldPath.move(to: CGPoint(x: 0, y: 15 * scale))
        shieldPath.addLine(to: CGPoint(x: -10 * scale, y: 10 * scale))
        shieldPath.addLine(to: CGPoint(x: -10 * scale, y: -5 * scale))
        shieldPath.addLine(to: CGPoint(x: 0, y: -15 * scale))
        shieldPath.addLine(to: CGPoint(x: 10 * scale, y: -5 * scale))
        shieldPath.addLine(to: CGPoint(x: 10 * scale, y: 10 * scale))
        shieldPath.close()

        let shield = SKShapeNode(path: shieldPath.cgPath)
        shield.fillColor = .white
        shield.strokeColor = .black
        shield.lineWidth = 2 * scale

        return shield
    }

    private func createStarSymbol(scale: CGFloat) -> SKNode {
        let starPath = UIBezierPath()
        let points = 5
        let outerRadius: CGFloat = 12 * scale
        let innerRadius: CGFloat = 5 * scale

        for i in 0..<points * 2 {
            let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = cos(angle) * radius
            let y = sin(angle) * radius

            if i == 0 {
                starPath.move(to: CGPoint(x: x, y: y))
            } else {
                starPath.addLine(to: CGPoint(x: x, y: y))
            }
        }
        starPath.close()

        let star = SKShapeNode(path: starPath.cgPath)
        star.fillColor = .white
        star.strokeColor = .orange
        star.lineWidth = 2 * scale

        return star
    }

    private func createQuestionMarkSymbol(scale: CGFloat) -> SKNode {
        let container = SKNode()

        // Question mark using label (simplified)
        let label = SKLabelNode(text: "?")
        label.fontSize = 24 * scale
        label.fontName = "Arial-BoldMT"
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        container.addChild(label)

        return container
    }

    private func createLightningSymbol(scale: CGFloat) -> SKNode {
        let lightningPath = UIBezierPath()
        lightningPath.move(to: CGPoint(x: 0, y: 15 * scale))
        lightningPath.addLine(to: CGPoint(x: -5 * scale, y: 2 * scale))
        lightningPath.addLine(to: CGPoint(x: 2 * scale, y: 2 * scale))
        lightningPath.addLine(to: CGPoint(x: -3 * scale, y: -15 * scale))
        lightningPath.addLine(to: CGPoint(x: 5 * scale, y: -5 * scale))
        lightningPath.addLine(to: CGPoint(x: -2 * scale, y: -5 * scale))
        lightningPath.close()

        let lightning = SKShapeNode(path: lightningPath.cgPath)
        lightning.fillColor = .yellow
        lightning.strokeColor = .white
        lightning.lineWidth = 2 * scale

        return lightning
    }

    private func addFloatingAnimation() {
        let floatUp = SKAction.moveBy(x: 0, y: 10, duration: 1.5)
        floatUp.timingMode = .easeInEaseOut
        let floatDown = floatUp.reversed()
        let sequence = SKAction.sequence([floatUp, floatDown])
        run(SKAction.repeatForever(sequence))
    }

    func pop(completion: @escaping () -> Void) {
        // Flash white for 1 frame for impact
        let originalColor = self.fillColor
        self.fillColor = .white

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.016) {
            self.fillColor = originalColor
        }

        // Pop animation with overshoot
        let scaleUp = SKAction.scale(to: 1.4, duration: 0.15)
        scaleUp.timingMode = .easeOut
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let group = SKAction.group([scaleUp, fadeOut])
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([group, remove])

        run(sequence) {
            completion()
        }

        // Enhanced particle effect using design system
        if let parent = self.parent {
            let particles = DesignSystem.Particles.createPopParticles(color: self.fillColor)
            particles.position = self.position
            parent.addChild(particles)

            let wait = SKAction.wait(forDuration: 1.0)
            let removeParticles = SKAction.removeFromParent()
            particles.run(SKAction.sequence([wait, removeParticles]))
        }
    }
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let arrow: UInt32 = 0b1
    static let balloon: UInt32 = 0b10
    static let bomb: UInt32 = 0b100
    static let player: UInt32 = 0b1000
}
