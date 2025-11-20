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

        // Create arrow shape (1.8x longer)
        let arrowPath = UIBezierPath()
        
        // Shaft
        arrowPath.move(to: CGPoint(x: -36, y: 0))
        arrowPath.addLine(to: CGPoint(x: 36, y: 0))
        
        // Head
        arrowPath.move(to: CGPoint(x: 36, y: 0))
        arrowPath.addLine(to: CGPoint(x: 27, y: -5))
        arrowPath.addLine(to: CGPoint(x: 45, y: 0))
        arrowPath.addLine(to: CGPoint(x: 27, y: 5))
        arrowPath.close()
        
        // Fletching (Feathers)
        arrowPath.move(to: CGPoint(x: -36, y: 0))
        arrowPath.addLine(to: CGPoint(x: -45, y: -5))
        arrowPath.move(to: CGPoint(x: -36, y: 0))
        arrowPath.addLine(to: CGPoint(x: -45, y: 5))
        
        arrowPath.move(to: CGPoint(x: -27, y: 0))
        arrowPath.addLine(to: CGPoint(x: -36, y: -5))
        arrowPath.move(to: CGPoint(x: -27, y: 0))
        arrowPath.addLine(to: CGPoint(x: -36, y: 5))

        self.path = arrowPath.cgPath
        self.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0) // Wood color
        self.lineWidth = 2
        self.fillColor = .gray // For the head
        self.position = position
        self.zRotation = angle

        // Calculate velocity based on angle and power
        // Increased multiplier to 3000.0 for very fast flight
        let speed = power * 3000.0
        let vx = cos(angle) * speed
        let vy = sin(angle) * speed
        self.velocity = CGVector(dx: vx, dy: vy)

        // Physics body (also scaled)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 45, height: 5))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.mass = 0.01 // Very light
        self.physicsBody?.friction = 0.2
        self.physicsBody?.linearDamping = 0.0 // No drag
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
        trail.particleTexture = TextureGenerator.sparkTexture
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
