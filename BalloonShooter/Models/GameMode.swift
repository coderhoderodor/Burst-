//
//  GameMode.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import Foundation

enum GameMode {
    case arcade
    case timeAttack
    case precision
    case survival

    var displayName: String {
        switch self {
        case .arcade: return "Arcade Mode"
        case .timeAttack: return "Time Attack"
        case .precision: return "Precision Mode"
        case .survival: return "Survival Mode"
        }
    }

    var description: String {
        switch self {
        case .arcade:
            return "Endless waves with progressive difficulty"
        case .timeAttack:
            return "Pop as many balloons as possible in 60 seconds"
        case .precision:
            return "Limited arrows - make every shot count"
        case .survival:
            return "One life - how long can you last?"
        }
    }

    var startingLives: Int {
        switch self {
        case .arcade: return 3
        case .timeAttack: return 999 // Effectively unlimited
        case .precision: return 1
        case .survival: return 1
        }
    }

    var startingArrows: Int? {
        switch self {
        case .precision: return 20
        default: return nil // Unlimited
        }
    }

    var timeLimit: TimeInterval? {
        switch self {
        case .timeAttack: return 60
        default: return nil
        }
    }

    var icon: String {
        switch self {
        case .arcade:
            return "A"
        case .timeAttack:
            return "T"
        case .precision:
            return "P"
        case .survival:
            return "S"
        }
    }
}
