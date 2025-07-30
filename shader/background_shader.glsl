#ifdef GL_ES
precision mediump float;
#endif

extern vec2 resolution;
extern float time;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // Normalize coordinates
    vec2 uv = screen_coords / resolution;
    
    // Create a dynamic gradient based on time
    float t = time * 0.2; // Slow down the animation
    
    // Create a subtle wave pattern
    float wave = sin(uv.x * 10.0 + t) * 0.5 + 0.5;
    wave *= sin(uv.y * 8.0 + t * 1.2) * 0.5 + 0.5;
    
    // Create base colors
    vec3 color1 = vec3(0.1, 0.2, 0.3); // Dark blue
    vec3 color2 = vec3(0.2, 0.3, 0.4); // Lighter blue
    
    // Mix colors based on wave pattern
    vec3 finalColor = mix(color1, color2, wave);
    
    // Add subtle pulsing
    float pulse = sin(t) * 0.1 + 0.9;
    finalColor *= pulse;
    
    return vec4(finalColor, 1.0);
}