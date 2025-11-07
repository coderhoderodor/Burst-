//
//  PowerUpType.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import Foundation

enum PowerUpType {
    case slowMotion
    case multiArrow
    case autoShield
    case explosiveArrow

    var duration: TimeInterval {
        switch self {
        case .slowMotion: return 2.0
        case .multiArrow: return 10.0
        case .autoShield: return 0 // One-time use
        case .explosiveArrow: return 5.0
        }
    }

    var displayName: String {
        switch self {
        case .slowMotion: return "Slow Motion"
        case .multiArrow: return "Multi Arrow"
        case .autoShield: return "Auto Shield"
        case .explosiveArrow: return "Explosive Arrow"
        }
    }
}
