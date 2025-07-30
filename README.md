# LÖVE 2D Ball Physics Demo

A simple physics simulation built with [LÖVE 2D](https://love2d.org/) featuring a bouncing ball with particle effects and a dynamic animated background shader.

## Features

- **Physics**: Ball physics with gravity, velocity damping, and collision detection
- **Controls**: Click to apply random velocity boosts to the ball
- **Particle System**: Dynamic particle effects on collisions that scale with impact speed
- **Animated Background**: Custom GLSL shader creating a subtle wave pattern background
- **Ground Friction**: Realistic rolling friction when the ball is on the ground
- **Cross Damping**: Velocity reduction in perpendicular directions during collisions

### Collision System
- Boundary collision detection for all four walls
- Velocity damping on impact (85% retention with additional subtraction)
- Cross-damping affects perpendicular velocity during collisions

### Ground Mechanics
- Gravity automatically disables when the ball settles on the ground
- Rolling friction applied to horizontal movement when grounded
- Minimum velocity threshold prevents micro-bouncing

### Particle Effects
- Particle intensity scales with collision speed
- Red particles that fade out over time
- Dynamic particle count based on impact force

### Files Structure
```
├── main.lua                    # Main game logic and physics
├── conf.lua                    # Love2D configuration
├── shader/
│   └── background_shader.glsl  # Animated background shader
├── assets/
│   └── particle.png           # Particle texture
└── README.md                  # This file
```

## Installation & Running

1. **Install LÖVE 2D** from [love2d.org](https://love2d.org/)
2. **Clone this repository**:
   ```bash
   git clone https://github.com/michaelblayney/love2d-ball-physics-demo.git
   cd love2d-ball-physics-demo
   ```
3. **Run the demo**:
   - **Windows**: Drag the folder onto `love.exe` or run `love .` in the project directory
   - **macOS**: Drag the folder onto the LÖVE application
   - **Linux**: Run `love .` in the project directory

## Controls

| Action | Control |
|--------|---------|
| Apply velocity boost | Left mouse click |
| Exit | Alt+F4 (Windows) or Cmd+Q (macOS) |

## Shader Details

The background shader creates a dynamic animated effect using:
- Time-based wave patterns
- Color interpolation between dark and light blue
- Subtle pulsing animation
- Resolution-independent scaling

## License

This project is open source. Feel free to use and modify as needed.