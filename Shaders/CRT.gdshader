shader_type canvas_item;

uniform float scanline_strength : hint_range(0.0, 1.0) = 0.3;
uniform float distortion_strength : hint_range(0.0, 1.0) = 0.05;
uniform float chroma_shift_strength : hint_range(0.0, 1.0) = 0.02;
uniform float saturation_boost : hint_range(1.0, 3.0) = 1.5;
uniform vec2 screen_resolution = vec2(320.0, 240.0);

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5);

    // Courbure CRT basée sur distance au centre
    vec2 offset = uv - center;
    float dist = length(offset);
    offset *= 1.0 + distortion_strength * dist * dist;
    uv = center + offset;

    // Aberration chromatique selon direction vers centre
    vec2 dir = normalize(offset);
    vec2 shift = dir * chroma_shift_strength / screen_resolution;
    float r = texture(TEXTURE, uv + shift).r;
    float g = texture(TEXTURE, uv).g;
    float b = texture(TEXTURE, uv - shift).b;
    vec3 color = vec3(r, g, b);

    // Boost saturation
    vec3 gray = vec3(dot(color, vec3(0.299, 0.587, 0.114)));
    color = gray + (color - gray) * saturation_boost;

    // Scanlines animées (fréquence réduite, moins de bandes)
    float scroll = TIME * 0.1;
    float frequency = screen_resolution.y * 3.14159 / 3.0; // divisé par 3 pour moins de bandes
    float scanline = (sin((uv.y + scroll) * frequency) + 1.0) * 0.5;
    float strength = mix(1.0, scanline, scanline_strength);
    color *= strength;

    // Bruit statique (intensité faible et animé)
    float noise = (rand(uv * screen_resolution + TIME * 10.0) - 0.5) * 0.05;
    color += noise;

    COLOR = vec4(color, texture(TEXTURE, uv).a);
}
