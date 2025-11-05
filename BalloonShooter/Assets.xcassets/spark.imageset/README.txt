PARTICLE TEXTURE PLACEHOLDER

The game requires a "spark.png" particle texture for visual effects (balloon pops, explosions, trails).

To complete the assets:
1. Create a 32x32 PNG image with a white circular gradient (bright center, fading to transparent edges)
2. Name it "spark.png"
3. Place it in this directory (BalloonShooter/Assets.xcassets/spark.imageset/)

Example specs:
- Size: 32x32 pixels
- Format: PNG with transparency
- Content: Radial gradient from opaque white center to transparent edges
- This creates a soft particle effect when used by the SKEmitterNode systems

You can create this in any image editor (Photoshop, Sketch, GIMP, etc.) or use online tools.

Alternatively, you can use any small, circular, semi-transparent texture for particle effects.
