#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float h_ranges[8];
uniform float s_ranges[8];
uniform float l_ranges[8];
uniform sampler2D image;

out vec4 fragColor;

// ... HSL conversion functions ...
// ... Selective HSL logic ...

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec4 color = texture(image, uv);
    
    // Process color based on h_ranges, s_ranges, l_ranges
    
    fragColor = color;
}
