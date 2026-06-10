#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float sharpness; // 0.0 to 1.0
uniform float clarity;   // -1.0 to 1.0
uniform float dehaze;    // -1.0 to 1.0
uniform float vignette;  // -1.0 to 1.0
uniform float grain;     // 0.0 to 1.0
uniform vec2 resolution;
uniform sampler2D image;

out vec4 fragColor;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec2 normUv = uv / resolution;
    vec4 color = texture(image, uv);
    vec3 c = color.rgb;

    // Sharpness (simple unsharp mask approximation)
    if (sharpness > 0.0) {
        vec2 px = 1.0 / resolution;
        vec3 blur = (
            texture(image, uv + vec2(-px.x, 0)).rgb +
            texture(image, uv + vec2(px.x, 0)).rgb +
            texture(image, uv + vec2(0, -px.y)).rgb +
            texture(image, uv + vec2(0, px.y)).rgb
        ) / 4.0;
        c = mix(c, c + (c - blur), sharpness * 2.0);
    }

    // Clarity (midtone contrast)
    float lum = dot(c, vec3(0.299, 0.587, 0.114));
    float midtoneMask = 1.0 - abs(lum - 0.5) * 2.0;
    c = mix(c, c * (1.0 + clarity * 0.5 * midtoneMask), midtoneMask);

    // Dehaze (reduce atmospheric haze = increase contrast + saturation locally)
    c = mix(c, pow(c, vec3(1.0 - dehaze * 0.3)), abs(dehaze));

    // Vignette
    if (vignette != 0.0) {
        vec2 center = normUv - 0.5;
        float dist = length(center) * 1.4142;
        float vigFactor = 1.0 + vignette * 0.5 * smoothstep(0.3, 1.0, dist);
        c *= clamp(vigFactor, 0.0, 2.0);
    }

    // Grain
    if (grain > 0.0) {
        float noise = rand(uv + vec2(0.1, 0.2)) * 2.0 - 1.0;
        c += noise * grain * 0.08;
    }

    fragColor = vec4(clamp(c, 0.0, 1.0), color.a);
}
