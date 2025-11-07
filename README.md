# Balloon Shooter

A mobile arcade game for iOS where players shoot arrows from a bow to pop balloons while avoiding bomb balloons. Features risk-reward decision making, multiple game modes, and progressive difficulty.

![Platform](https://img.shields.io/badge/platform-iOS%2014%2B-blue)
![Language](https://img.shields.io/badge/Swift-5.0-orange)
![Framework](https://img.shields.io/badge/SpriteKit-2D-green)

## Overview

**Balloon Shooter** is a casual arcade game that combines precision aiming with strategic decision-making. Players must carefully choose their targets, as some balloons drop bombs when hit. The game features multiple modes, balloon types, power-ups, and a progressive difficulty system that keeps gameplay challenging and engaging.

### Key Features

- **Intuitive Controls**: Touch and drag to aim, release to shoot
- **Risk-Reward Gameplay**: Decide which balloons are safe to pop
- **Multiple Game Modes**: Arcade, Time Attack, Precision, and Survival
- **Diverse Balloon Types**: Regular, Bomb, Shield, Golden, Multi, Mystery, and Speed balloons
- **Power-Ups**: Slow Motion, Multi-Arrow, Auto-Shield, and Explosive Arrow
- **Progressive Difficulty**: Waves get harder with more balloons and bombs
- **Combo System**: Chain hits for score multipliers
- **Visual Polish**: Smooth animations, programmatic particle effects, and haptic feedback
- **Custom Graphics**: Programmatically generated visual indicators for each balloon type
- **Data Persistence**: High scores, statistics, and settings saved locally

## Game Modes

### Arcade Mode (Default)
- Endless waves with progressive difficulty
- Start with 3 lives, regenerate 1 life every 3 waves
- Focus on high scores and wave completion

### Time Attack
- 60 seconds on the clock
- Pop as many balloons as possible
- No bomb balloons (pure scoring mode)

### Precision Mode
- Limited to 20 arrows per game
- Strategic resource management required
- One bomb hit = game over

### Survival Mode
- Start with only 1 life
- See how long you can last
- Increasing bomb balloon ratio

## Balloon Types

| Balloon | Color | Points | Description |
|---------|-------|--------|-------------|
| Regular | Red | 10 | Standard balloon with shine effect, safe to pop |
| Bomb | Dark Gray | 0 | Skull symbol, drops a bomb when hit! |
| Shield | Blue | 20 | Shield icon, grants protection from one bomb |
| Golden | Yellow | 50 | Rotating star, high value, moves erratically |
| Multi | Purple | 15 | Three circles, splits into 3 smaller balloons |
| Mystery | Orange | Variable | Question mark, 50/50 chance of bonus or bomb |
| Speed | Green | 25 | Lightning bolt, moves quickly across screen |

## Power-Ups

- **Slow Motion**: Activated when pulling bow fully back (2 seconds)
- **Multi-Arrow**: Shoot 3 arrows in a spread pattern (10 seconds)
- **Auto-Shield**: Automatically blocks the next bomb hit (one-time use)
- **Explosive Arrow**: Pops all balloons in a radius (5 seconds)

## Project Structure

```
BalloonShooter/
├── BalloonShooter.xcodeproj/    # Xcode project file
└── BalloonShooter/
    ├── AppDelegate.swift         # Application entry point
    ├── SceneDelegate.swift       # Scene lifecycle management
    ├── GameViewController.swift  # Main view controller
    ├── Info.plist               # App configuration
    ├── Assets.xcassets/         # Image assets and app icons
    ├── Base.lproj/              # Storyboards
    │   └── LaunchScreen.storyboard
    ├── Scenes/                  # SpriteKit scenes and nodes
    │   ├── MenuScene.swift      # Main menu
    │   ├── GameScene.swift      # Core gameplay
    │   ├── GameOverScene.swift  # Game over screen
    │   ├── SettingsScene.swift  # Settings menu
    │   ├── HowToPlayScene.swift # Instructions
    │   ├── BalloonNode.swift    # Balloon entity
    │   ├── ArrowNode.swift      # Arrow entity
    │   └── BombNode.swift       # Bomb entity
    ├── Models/                  # Data models and enums
    │   ├── GameMode.swift       # Game mode definitions
    │   ├── BalloonType.swift    # Balloon type configurations
    │   └── PowerUpType.swift    # Power-up definitions
    └── Managers/                # Game systems
        ├── GameManager.swift    # Core game state management
        ├── DataManager.swift    # Persistence and settings
        └── AudioManager.swift   # Sound effects and haptics
```

## Technical Requirements

- **Platform**: iOS 14.0+
- **Language**: Swift 5.0
- **Framework**: SpriteKit (2D game rendering)
- **Orientation**: Portrait only
- **Devices**: iPhone and iPad support
- **Performance**: 60 FPS target

## Build Instructions

### Prerequisites

- macOS with Xcode 13.0 or later
- iOS 14.0+ deployment target
- Apple Developer account (for device deployment)

### Building the Project

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/BalloonShooter.git
   cd BalloonShooter
   ```

2. **Open in Xcode**
   ```bash
   open BalloonShooter.xcodeproj
   ```

3. **Select a target device or simulator**
   - Choose your device from the device selector in Xcode
   - For simulator: Select any iPhone or iPad simulator

4. **Build and run**
   - Press `Cmd + R` or click the Play button
   - The app will compile and launch on your selected device/simulator

### Configuration

- **Bundle Identifier**: Change `com.example.BalloonShooter` in project settings to your own
- **Development Team**: Set your Apple Developer team in Signing & Capabilities
- **App Icons**: Add custom app icons to `Assets.xcassets/AppIcon.appiconset/`

## Gameplay Mechanics

### Controls

1. **Aim**: Touch and drag anywhere on screen to pull back the bow
2. **Power**: Pull back further for more power and distance
3. **Shoot**: Release to fire the arrow
4. **Trajectory**: A dotted line shows the predicted arrow path (while aiming)

### Scoring System

- **Base Points**: Each balloon type has its own point value
- **Combo Multiplier**: Chain hits without missing to increase multiplier
- **Wave Bonus**: Complete waves for bonus points (Wave # × 50)
- **Accuracy Bonus**: Higher accuracy yields better ratings

### Difficulty Scaling

As waves progress:
- More balloons spawn simultaneously (up to 6)
- Bomb balloon ratio increases (30% → 50%)
- Balloons may move faster and be smaller
- Special balloon types appear more frequently

## Development Phases

The game was implemented in 5 phases following the PRD:

1. **Phase 1 (MVP)**: Core shooting mechanics, single balloon, basic scoring
2. **Phase 2**: Bomb balloons, health system, risk-reward gameplay
3. **Phase 3**: Wave system, difficulty progression, combo scoring
4. **Phase 4**: Balloon variety (7 types), strategic depth
5. **Phase 5**: Power-ups, visual/audio polish, multiple game modes

## Future Enhancements

Potential features for future versions:

- [ ] Boss balloons with special patterns
- [ ] Environmental hazards (wind, obstacles)
- [ ] Different bow types with unique properties
- [ ] Seasonal events and themed balloons
- [ ] Multiplayer async competition
- [ ] Daily challenges and missions
- [ ] Achievement system
- [ ] Game Center leaderboards integration
- [ ] Customization (bow skins, arrow effects)
- [ ] Sound effects and background music
- [ ] iCloud sync for progress

## Visual Assets

All visual elements are **programmatically generated** - no external image assets required:

- **Balloon Graphics**: Each balloon type has custom-drawn symbols (skull for bombs, shield icon, stars, lightning bolts, etc.)
- **Particle Effects**: Programmatically generated radial gradient textures for particle systems
- **UI Elements**: All buttons, icons, and interface elements drawn using SKShapeNode
- **Animations**: Smooth transitions, floating effects, and rotations all done in code

This approach provides several benefits:
- No asset management required
- Scalable graphics at any resolution
- Easy to customize colors and styles
- Smaller app bundle size

## Known Limitations

- **Audio**: Sound effects are not implemented (AudioManager is a stub)
- **Game Center**: Leaderboard integration not yet implemented
- **Social Sharing**: Share functionality shows a placeholder message

## Performance Notes

- Target frame rate: 60 FPS
- Optimized for iPhone X and later
- Tested on iOS 14.0+
- Physics simulation uses SpriteKit's built-in engine
- Particle systems are optimized with limited particle counts

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## Credits

- **Design**: Based on the Balloon Shooter PRD
- **Development**: Implemented with SpriteKit and Swift
- **Inspiration**: Angry Birds (trajectory aiming), Fruit Ninja (arcade action)

## License

This project is available for educational and personal use. Please check with the repository owner for commercial use permissions.

---

## Quick Start Guide

### First Time Playing

1. Launch the app
2. Select a game mode (Arcade recommended for beginners)
3. Touch and drag to aim the bow
4. Release to shoot arrows at balloons
5. Pop regular balloons (red with shine) for points
6. Avoid hitting bomb balloons (gray with skull) or they'll drop bombs
7. Collect shield balloons (blue with shield icon) for protection
8. Chain hits for combo multipliers
9. Complete waves to progress in difficulty

### Tips for Success

- **Look before you shoot**: Identify bomb balloons before firing
- **Build combos**: Consecutive hits increase your score multiplier
- **Use slow motion**: Pull back fully for precision shots
- **Collect shields**: They save you from one bomb hit
- **Aim for golden balloons**: Worth 5x normal points
- **Master the arc**: Arrows follow realistic physics

### High Score Strategies

1. Prioritize golden and speed balloons for maximum points
2. Maintain combo chains by never missing
3. Complete waves quickly for time bonuses
4. Use power-ups strategically in tough situations
5. Save shields for emergency situations
6. Practice trajectory prediction for better accuracy

---

**Version**: 1.0
**Last Updated**: November 5, 2025
**Platform**: iOS 14+

Enjoy playing Balloon Shooter! 🎈🏹
