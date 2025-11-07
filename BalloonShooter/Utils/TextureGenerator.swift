//
//  TextureGenerator.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

class TextureGenerator {
    static func generateSparkTexture(size: CGSize = CGSize(width: 32, height: 32)) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { context in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2

            // Create radial gradient
            let colors = [
                UIColor.white.cgColor,
                UIColor.white.withAlphaComponent(0.8).cgColor,
                UIColor.white.withAlphaComponent(0.4).cgColor,
                UIColor.clear.cgColor
            ]

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let locations: [CGFloat] = [0.0, 0.3, 0.6, 1.0]

            if let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: locations
            ) {
                context.cgContext.drawRadialGradient(
                    gradient,
                    startCenter: center,
                    startRadius: 0,
                    endCenter: center,
                    endRadius: radius,
                    options: []
                )
            }
        }

        return SKTexture(image: image)
    }

    static func generateCircleTexture(size: CGSize = CGSize(width: 16, height: 16), color: UIColor = .white) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            color.setFill()
            context.cgContext.fillEllipse(in: rect)
        }

        return SKTexture(image: image)
    }

    // Cache textures for performance
    private static var sparkTextureCache: SKTexture?

    static var sparkTexture: SKTexture {
        if let cached = sparkTextureCache {
            return cached
        }
        let texture = generateSparkTexture()
        sparkTextureCache = texture
        return texture
    }
}
