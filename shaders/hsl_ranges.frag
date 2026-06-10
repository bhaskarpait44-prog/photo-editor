#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float h_ranges[8];
uniform float s_ranges[8];
uniform float l_ranges[8];
uniform sampler2D image;

out vec4 fragColor;

const float HUE_CENTERS[8] = float[8](0.0, 0.083, 0.167, 0.333, 0.5, 0.667, 0.75, 0.917);

vec3 rgb2hsl(vec3 c) {
    float maxC = max(max(c.r, c.g), c.b);
    float minC = min(min(c.r, c.g), c.b);
    float l = (maxC + minC) / 2.0;
    if (maxC == minC) return vec3(0.0, 0.0, l);
    float d = maxC - minC;
    float s = l > 0.5 ? d / (2.0 - maxC - minC) : d / (maxC + minC);
    float h;
    if (maxC == c.r) h = (c.g - c.b) / d + (c.g < c.b ? 6.0 : 0.0);
    else if (maxC == c.g) h = (c.b - c.r) / d + 2.0;
    else h = (c.r - c.g) / d + 4.0;
    return vec3(h / 6.0, s, l);
}

float hue2rgb(float p, float q, float t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if (t < 0.5) return q;
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec3 hsl2rgb(vec3 c) {
    if (c.y == 0.0) return vec3(c.z);
    float q = c.z < 0.5 ? c.z * (1.0 + c.y) : c.z + c.y - c.z * c.y;
    float p = 2.0 * c.z - q;
    return vec3(hue2rgb(p, q, c.x + 1.0/3.0), hue2rgb(p, q, c.x), hue2rgb(p, q, c.x - 1.0/3.0));
}

void main() {
    vec2 uv = FlutterFragCoord().xy;
    vec4 color = texture(image, uv);
    vec3 hsl = rgb2hsl(color.rgb);

    float totalH = 0.0, totalS = 0.0, totalL = 0.0;
    for (int i = 0; i < 8; i++) {
        float dist = abs(hsl.x - HUE_CENTERS[i]);
        dist = min(dist, 1.0 - dist);
        float weight = max(0.0, 1.0 - dist / 0.09);
        totalH += h_ranges[i] * weight;
        totalS += s_ranges[i] * weight;
        totalL += l_ranges[i] * weight;
    }

    hsl.x = fract(hsl.x + totalH * 0.5);
    hsl.y = clamp(hsl.y + totalS, 0.0, 1.0);
    hsl.z = clamp(hsl.z + totalL * 0.5, 0.0, 1.0);

    fragColor = vec4(hsl2rgb(hsl), color.a);
}
