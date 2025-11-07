//
//  BalloonType.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import SpriteKit

enum BalloonType {
    case regular
    case bomb
    case shield
    case golden
    case multi
    case mystery
    case speed

    var points: Int {
        switch self {
        case .regular: return 10
        case .bomb: return 0
        case .shield: return 20
        case .golden: return 50
        case .multi: return 15
        case .mystery: return 0 // Variable
        case .speed: return 25
        }
    }

    var color: UIColor {
        switch self {
        case .regular: return .systemRed
        case .bomb: return .darkGray
        case .shield: return .systemBlue
        case .golden: return .systemYellow
        case .multi: return .systemPurple
        case .mystery: return .systemOrange
        case .speed: return .systemGreen
        }
    }

    var size: CGFloat {
        switch self {
        case .multi: return 60
        case .golden: return 45
        default: return 50
        }
    }

    var spawnWeight: Double {
        switch self {
        case .regular: return 0.70
        case .bomb: return 0.30
        case .shield: return 0.10
        case .golden: return 0.05
        case .multi: return 0.08
        case .mystery: return 0.07
        case .speed: return 0.12
        }
    }

    var displayName: String {
        switch self {
        case .regular: return "Regular"
        case .bomb: return "Bomb"
        case .shield: return "Shield"
        case .golden: return "Golden"
        case .multi: return "Multi"
        case .mystery: return "Mystery"
        case .speed: return "Speed"
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .regular: return .systemPink
        case .bomb: return .black
        case .shield: return .cyan
        case .golden: return .orange
        case .multi: return .magenta
        case .mystery: return .brown
        case .speed: return .systemTeal
        }
    }
}
