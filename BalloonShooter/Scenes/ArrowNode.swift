//
//  ArrowNode.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class ArrowNode: SKShapeNode {
    var velocity: CGVector = .zero

    init(from position: CGPoint, angle: CGFloat, power: CGFloat) {
        super.init()

        // Create arrow shape
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: -5, y: 0))
        arrowPath.addLine(to: CGPoint(x: 20, y: 0))
        arrowPath.move(to: CGPoint(x: 20, y: 0))
        arrowPath.addLine(to: CGPoint(x: 15, y: -5))
        arrowPath.move(to: CGPoint(x: 20, y: 0))
        arrowPath.addLine(to: CGPoint(x: 15, y: 5))

        self.path = arrowPath.cgPath
        self.strokeColor = .brown
        self.lineWidth = 3
        self.position = position
        self.zRotation = angle

        // Calculate velocity based on angle and power
        let speed = power * 15.0
        let vx = cos(angle) * speed
        let vy = sin(angle) * speed
        self.velocity = CGVector(dx: vx, dy: vy)

        // Physics body
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.arrow
        self.physicsBody?.contactTestBitMask = PhysicsCategory.balloon
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.velocity = velocity

        // Add trail effect
        addTrailEffect()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTrailEffect() {
        let trail = SKEmitterNode()
        trail.particleTexture = SKTexture(imageNamed: "spark")
        trail.particleBirthRate = 50
        trail.particleLifetime = 0.3
        trail.particleSpeed = 0
        trail.particleScale = 0.2
        trail.particleAlpha = 0.5
        trail.particleAlphaSpeed = -1.5
        trail.particleColor = .brown
        trail.position = CGPoint(x: -10, y: 0)
        addChild(trail)
    }

    func update(deltaTime: TimeInterval) {
        // Update rotation to match velocity direction
        if let physicsBody = self.physicsBody {
            let angle = atan2(physicsBody.velocity.dy, physicsBody.velocity.dx)
            self.zRotation = angle
        }
    }
}
