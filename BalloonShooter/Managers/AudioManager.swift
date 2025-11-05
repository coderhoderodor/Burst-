//
//  AudioManager.swift
//  BalloonShooter
//
//  Created by Claude on 11/5/25.
//

import AVFoundation
import UIKit

class AudioManager {
    static let shared = AudioManager()

    private init() {}

    enum SoundEffect {
        case bowDraw
        case arrowShoot
        case balloonPop
        case bombFall
        case explosion
        case powerUp
        case combo
    }

    func playSound(_ sound: SoundEffect) {
        guard DataManager.shared.soundEnabled else { return }
        // In a real implementation, we would load and play actual sound files
        // For now, we'll use system sounds or generate them programmatically
    }

    func playHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard DataManager.shared.hapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
