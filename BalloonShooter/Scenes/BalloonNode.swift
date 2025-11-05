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
        self.strokeColor = type.color.withAlphaComponent(0.8)
        self.lineWidth = 2
        self.position = position

        // Add icon label
        let label = SKLabelNode(text: type.icon)
        label.fontSize = size * 0.5
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 0)
        addChild(label)

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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addFloatingAnimation() {
        let floatUp = SKAction.moveBy(x: 0, y: 10, duration: 1.5)
        floatUp.timingMode = .easeInEaseOut
        let floatDown = floatUp.reversed()
        let sequence = SKAction.sequence([floatUp, floatDown])
        run(SKAction.repeatForever(sequence))
    }

    func pop(completion: @escaping () -> Void) {
        // Pop animation
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let group = SKAction.group([scaleUp, fadeOut])
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([group, remove])

        run(sequence) {
            completion()
        }

        // Particle effect
        if let parent = self.parent {
            let particles = createPopParticles()
            particles.position = self.position
            parent.addChild(particles)

            let wait = SKAction.wait(forDuration: 1.0)
            let removeParticles = SKAction.removeFromParent()
            particles.run(SKAction.sequence([wait, removeParticles]))
        }
    }

    private func createPopParticles() -> SKEmitterNode {
        let particles = SKEmitterNode()
        particles.particleTexture = SKTexture(imageNamed: "spark")
        particles.particleBirthRate = 100
        particles.numParticlesToEmit = 20
        particles.particleLifetime = 0.5
        particles.particleSpeed = 100
        particles.particleSpeedRange = 50
        particles.emissionAngleRange = .pi * 2
        particles.particleScale = 0.3
        particles.particleScaleRange = 0.2
        particles.particleAlpha = 1.0
        particles.particleAlphaSpeed = -2.0
        particles.particleColor = self.fillColor
        return particles
    }
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let arrow: UInt32 = 0b1
    static let balloon: UInt32 = 0b10
    static let bomb: UInt32 = 0b100
    static let player: UInt32 = 0b1000
}
