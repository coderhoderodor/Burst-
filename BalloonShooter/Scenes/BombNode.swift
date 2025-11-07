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

        // Add fuse
        let fusePath = UIBezierPath()
        fusePath.move(to: CGPoint(x: 0, y: 15))
        fusePath.addLine(to: CGPoint(x: -5, y: 25))
        let fuse = SKShapeNode(path: fusePath.cgPath)
        fuse.strokeColor = .brown
        fuse.lineWidth = 3
        addChild(fuse)

        // Add spark at end of fuse
        let spark = SKShapeNode(circleOfRadius: 3)
        spark.fillColor = .orange
        spark.strokeColor = .yellow
        spark.lineWidth = 1
        spark.position = CGPoint(x: -5, y: 25)
        addChild(spark)

        // Pulsing spark animation
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.3, duration: 0.3),
            SKAction.scale(to: 1.0, duration: 0.3)
        ])
        spark.run(SKAction.repeatForever(pulse))

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
        smoke.particleTexture = TextureGenerator.sparkTexture
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

        // Enhanced explosion particles
        if let parent = self.parent {
            let explosion = DesignSystem.Particles.createExplosionParticles()
            explosion.position = self.position
            parent.addChild(explosion)

            let wait = SKAction.wait(forDuration: 1.2)
            let removeExplosion = SKAction.removeFromParent()
            explosion.run(SKAction.sequence([wait, removeExplosion]))
        }
    }
}
