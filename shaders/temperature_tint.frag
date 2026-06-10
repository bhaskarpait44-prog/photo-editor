#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float temperature; // -1.0 to 1.0
uniform float tint;        // -1.0 to 1.0
uniform sampler2D image;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec4 color = texture(image, uv);
    vec3 c = color.rgb;

    // Temperature: warm = more red/yellow, cool = more blue
    c.r += temperature * 0.15;
    c.b -= temperature * 0.15;

    // Tint: green-magenta axis
    c.g += tint * 0.1;
    c.r -= tint * 0.05;
    c.b -= tint * 0.05;

    fragColor = vec4(clamp(c, 0.0, 1.0), color.a);
}
