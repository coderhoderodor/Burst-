//
//  DataManager.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import Foundation

class DataManager {
    static let shared = DataManager()

    private init() {}

    private let defaults = UserDefaults.standard

    // Keys
    private enum Keys {
        static let highScoreArcade = "highScoreArcade"
        static let highScoreTimeAttack = "highScoreTimeAttack"
        static let highScorePrecision = "highScorePrecision"
        static let highScoreSurvival = "highScoreSurvival"
        static let totalBalloonsPopped = "totalBalloonsPopped"
        static let bestWave = "bestWave"
        static let bestAccuracy = "bestAccuracy"
        static let totalPlaytime = "totalPlaytime"
        static let soundEnabled = "soundEnabled"
        static let musicEnabled = "musicEnabled"
        static let hapticsEnabled = "hapticsEnabled"
    }

    // High Scores
    func getHighScore(for mode: GameMode) -> Int {
        let key: String
        switch mode {
        case .arcade: key = Keys.highScoreArcade
        case .timeAttack: key = Keys.highScoreTimeAttack
        case .precision: key = Keys.highScorePrecision
        case .survival: key = Keys.highScoreSurvival
        }
        return defaults.integer(forKey: key)
    }

    func saveHighScore(_ score: Int, for mode: GameMode) {
        let key: String
        switch mode {
        case .arcade: key = Keys.highScoreArcade
        case .timeAttack: key = Keys.highScoreTimeAttack
        case .precision: key = Keys.highScorePrecision
        case .survival: key = Keys.highScoreSurvival
        }
        let currentHigh = defaults.integer(forKey: key)
        if score > currentHigh {
            defaults.set(score, forKey: key)
        }
    }

    // Statistics
    var totalBalloonsPopped: Int {
        get { defaults.integer(forKey: Keys.totalBalloonsPopped) }
        set { defaults.set(newValue, forKey: Keys.totalBalloonsPopped) }
    }

    var bestWave: Int {
        get { defaults.integer(forKey: Keys.bestWave) }
        set {
            let current = defaults.integer(forKey: Keys.bestWave)
            if newValue > current {
                defaults.set(newValue, forKey: Keys.bestWave)
            }
        }
    }

    var bestAccuracy: Double {
        get { defaults.double(forKey: Keys.bestAccuracy) }
        set {
            let current = defaults.double(forKey: Keys.bestAccuracy)
            if newValue > current {
                defaults.set(newValue, forKey: Keys.bestAccuracy)
            }
        }
    }

    var totalPlaytime: TimeInterval {
        get { defaults.double(forKey: Keys.totalPlaytime) }
        set { defaults.set(newValue, forKey: Keys.totalPlaytime) }
    }

    // Settings
    var soundEnabled: Bool {
        get { defaults.object(forKey: Keys.soundEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.soundEnabled) }
    }

    var musicEnabled: Bool {
        get { defaults.object(forKey: Keys.musicEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.musicEnabled) }
    }

    var hapticsEnabled: Bool {
        get { defaults.object(forKey: Keys.hapticsEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.hapticsEnabled) }
    }
}
