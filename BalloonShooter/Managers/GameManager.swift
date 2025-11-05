//
//  GameManager.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import Foundation

class GameManager {
    static let shared = GameManager()

    private init() {}

    // Current game state
    var currentMode: GameMode = .arcade
    var score: Int = 0
    var lives: Int = 3
    var currentWave: Int = 1
    var balloonsPopped: Int = 0
    var arrowsRemaining: Int?
    var combo: Int = 0
    var hasShield: Bool = false
    var activePowerUps: [PowerUpType: TimeInterval] = [:]

    // Wave configuration
    var balloonsPerWave: Int {
        return min(10 + currentWave, 20)
    }

    var maxSimultaneousBalloons: Int {
        return min(2 + (currentWave / 3), 6)
    }

    var bombBalloonRatio: Double {
        return min(0.30 + Double(currentWave - 1) * 0.02, 0.50)
    }

    // Reset game state
    func startNewGame(mode: GameMode) {
        currentMode = mode
        score = 0
        lives = mode.startingLives
        currentWave = 1
        balloonsPopped = 0
        arrowsRemaining = mode.startingArrows
        combo = 0
        hasShield = false
        activePowerUps.removeAll()
    }

    // Scoring
    func addScore(_ points: Int) {
        let multiplier = max(1, combo / 3)
        score += points * multiplier
    }

    func incrementCombo() {
        combo += 1
    }

    func resetCombo() {
        combo = 0
    }

    // Lives
    func loseLife() -> Bool {
        if hasShield {
            hasShield = false
            return false // Didn't actually lose life
        }
        lives -= 1
        return lives <= 0
    }

    func addLife() {
        lives += 1
    }

    // Waves
    func completeWave() {
        currentWave += 1
        let waveBonus = currentWave * 50
        addScore(waveBonus)

        // Regenerate life every 3 waves in arcade mode
        if currentMode == .arcade && currentWave % 3 == 0 {
            addLife()
        }
    }

    // Arrows (for precision mode)
    func useArrow() -> Bool {
        guard let arrows = arrowsRemaining else { return true }
        if arrows > 0 {
            arrowsRemaining = arrows - 1
            return true
        }
        return false
    }

    // Power-ups
    func activatePowerUp(_ type: PowerUpType) {
        if type == .autoShield {
            hasShield = true
        } else {
            activePowerUps[type] = type.duration
        }
    }

    func hasPowerUp(_ type: PowerUpType) -> Bool {
        return activePowerUps[type] != nil
    }

    func updatePowerUps(delta: TimeInterval) {
        var expiredPowerUps: [PowerUpType] = []
        for (type, timeRemaining) in activePowerUps {
            let newTime = timeRemaining - delta
            if newTime <= 0 {
                expiredPowerUps.append(type)
            } else {
                activePowerUps[type] = newTime
            }
        }
        expiredPowerUps.forEach { activePowerUps.removeValue(forKey: $0) }
    }
}
