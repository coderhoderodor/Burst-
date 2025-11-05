//
//  BombNode.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class BombNode: SKShapeNode {

    init(at position: CGPoint) {
        super.init()

        // Create bomb shape
        let bombPath = UIBezierPath(ovalIn: CGRect(x: -15, y: -15, width: 30, height: 30))
        self.path = bombPath.cgPath
        self.fillColor = .black
        self.strokeColor = .darkGray
        self.lineWidth = 2
        self.position = position

        // Add icon
        let label = SKLabelNode(text: "💣")
        label.fontSize = 25
        label.verticalAlignmentMode = .center
        addChild(label)

        // Physics body
        self.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.bomb
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = 0

        // Add rotation animation
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 1.0)
        run(SKAction.repeatForever(rotate))

        // Add smoke trail
        addSmokeTrail()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSmokeTrail() {
        let smoke = SKEmitterNode()
        smoke.particleTexture = SKTexture(imageNamed: "spark")
        smoke.particleBirthRate = 20
        smoke.particleLifetime = 1.0
        smoke.particleSpeed = 20
        smoke.particleSpeedRange = 10
        smoke.emissionAngle = .pi / 2
        smoke.emissionAngleRange = .pi / 4
        smoke.particleScale = 0.3
        smoke.particleScaleSpeed = 0.2
        smoke.particleAlpha = 0.5
        smoke.particleAlphaSpeed = -0.5
        smoke.particleColor = .gray
        addChild(smoke)
    }

    func explode(completion: @escaping () -> Void) {
        // Explosion animation
        let scaleUp = SKAction.scale(to: 2.0, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleUp, fadeOut])
        let remove = SKAction.removeFromParent()

        run(SKAction.sequence([group, remove])) {
            completion()
        }

        // Explosion particles
        if let parent = self.parent {
            let explosion = createExplosionParticles()
            explosion.position = self.position
            parent.addChild(explosion)

            let wait = SKAction.wait(forDuration: 1.0)
            let removeExplosion = SKAction.removeFromParent()
            explosion.run(SKAction.sequence([wait, removeExplosion]))
        }
    }

    private func createExplosionParticles() -> SKEmitterNode {
        let particles = SKEmitterNode()
        particles.particleTexture = SKTexture(imageNamed: "spark")
        particles.particleBirthRate = 200
        particles.numParticlesToEmit = 50
        particles.particleLifetime = 0.8
        particles.particleSpeed = 150
        particles.particleSpeedRange = 50
        particles.emissionAngleRange = .pi * 2
        particles.particleScale = 0.4
        particles.particleScaleRange = 0.3
        particles.particleAlpha = 1.0
        particles.particleAlphaSpeed = -1.5
        particles.particleColor = .orange
        particles.particleColorBlendFactor = 1.0
        return particles
    }
}
