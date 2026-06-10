#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float exposure;    // -3.0 to 3.0
uniform float highlights;  // -1.0 to 1.0
uniform float shadows;     // -1.0 to 1.0
uniform float whites;      // -1.0 to 1.0
uniform float blacks;      // -1.0 to 1.0
uniform sampler2D image;

out vec4 fragColor;

float luminance(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec4 color = texture(image, uv);
    vec3 c = color.rgb;

    // Exposure (multiply by 2^ev)
    c *= pow(2.0, exposure);

    float lum = luminance(c);

    // Highlights: affects bright areas (lum > 0.5)
    float highlightMask = smoothstep(0.5, 1.0, lum);
    c += highlights * highlightMask * 0.5;

    // Shadows: affects dark areas (lum < 0.5)
    float shadowMask = 1.0 - smoothstep(0.0, 0.5, lum);
    c += shadows * shadowMask * 0.5;

    // Whites: clips highlights
    c = mix(c, min(c, vec3(1.0 + whites * 0.5)), highlightMask);

    // Blacks: lifts or crushes shadows
    c = mix(c, max(c, vec3(blacks * 0.3)), shadowMask);

    fragColor = vec4(clamp(c, 0.0, 1.0), color.a);
}
