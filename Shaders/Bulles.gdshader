shader_type canvas_item;

// Paramètres des bulles
uniform float bubble_size : hint_range(0.01, 0.2) = 0.05;
uniform float bubble_intensity : hint_range(0.0, 1.0) = 0.03;
uniform int bubble_count = 10;
uniform float bubble_speed : hint_range(0.1, 5.0) = 1.0;

// Générateur pseudo-aléatoire simple
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
    vec4 textureVideo = texture(TEXTURE, uv);

    // Suppression de la couleur rose
    vec3 target_color = vec3(0.9961, 0.0, 0.4235);
    float diff = distance(textureVideo.rgb, target_color);
    if (diff < 0.4) {
        textureVideo.a = 0.0;
    }

    vec2 distortion = vec2(0.0);

    // Calculer la déformation due aux bulles qui montent et explosent
    for (int i = 0; i < bubble_count; i++) {
        float fi = float(i);
        float seed_x = rand(vec2(fi, 0.1));
        float seed_y = rand(vec2(fi, 0.2));

        float y = mod(seed_y + TIME * bubble_speed, 1.0); // défilement vers le haut
        vec2 center = vec2(seed_x, 1.0 - y); // inverse pour défiler vers le haut

        float dist = distance(uv, center);

        float life = fract(TIME * bubble_speed + fi);
        float bubble_radius = bubble_size * (1.0 + life * 2.0);
        float bubble = smoothstep(bubble_radius, 0.0, dist);

        vec2 dir = normalize(uv - center);
        distortion += dir * bubble * bubble_intensity * (1.0 - life);
    }

    vec2 distorted_uv = uv + distortion;
    vec4 finalColor = texture(TEXTURE, distorted_uv);
    finalColor.a = textureVideo.a;

    COLOR = finalColor;
}
