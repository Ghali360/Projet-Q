shader_type canvas_item;

// Paramètres pour les bandes CRT
uniform float band_speed : hint_range(0.0, 10.0) = 2.0;
uniform float band_frequency : hint_range(100.0, 1000.0) = 600.0;
uniform float band_intensity : hint_range(0.0, 1.0) = 0.1;

// Fonction de distorsion CRT sans onde (wave)
vec2 crt_distort(vec2 uv, float time) {
    vec2 centered = uv - vec2(0.5);
    float dist = dot(centered, centered);
    return uv + centered * dist * 0.1;
}

// Effet de bandes CRT qui défilent vers le bas
float crt_band(vec2 uv, float time) {
    float scroll = mod(time * band_speed, 1.0);
    return 1.0 - band_intensity * sin((uv.y - scroll) * band_frequency);
}

void fragment() {
    // Couleur originale
    vec4 textureVideo = texture(TEXTURE, UV);

    // Suppression de la couleur rose
    vec3 target_color = vec3(0.9961, 0.0, 0.4235);
    float diff = distance(textureVideo.rgb, target_color);
    if (diff < 0.4) {
        textureVideo.a = 0.0;
    }

    // Coordonnées UV avec distorsion sans onde
    vec2 distorted_uv = crt_distort(UV, TIME);
    vec4 finalColor = texture(TEXTURE, distorted_uv);
    finalColor.a = textureVideo.a;

    // Teinte style CRT
    finalColor.rgb *= vec3(1.0, 0.6, 0.5);

    // Application des bandes CRT qui défilent
    float band = crt_band(UV, TIME);
    finalColor.rgb *= band;

    COLOR = finalColor;
}
