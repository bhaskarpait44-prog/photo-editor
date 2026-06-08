#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float brightness;
uniform float contrast;
uniform sampler2D image;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec4 color = texture(image, uv);
    
    // Apply brightness
    color.rgb += brightness;
    
    // Apply contrast
    color.rgb = (color.rgb - 0.5) * max(contrast + 1.0, 0.0) + 0.5;
    
    fragColor = color;
}
