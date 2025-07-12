shader_type canvas_item;

// Fonction scanline CRT
float scanline(vec2 uv) {
    return 0.9 + 0.1 * sin(uv.y * 800.0);
}

// Fonction de distorsion CRT animée
vec2 crt_distort(vec2 uv, float time) {
    vec2 centered = uv - vec2(0.5);
    float dist = dot(centered, centered);
    float wave = sin(time * 2.0 + uv.y * 20.0) * 0.01;
    return uv + centered * dist * 0.1 + vec2(wave, 0.0);
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

    // Coordonnées UV avec distorsion animée
    vec2 distorted_uv = crt_distort(UV, TIME);
    vec4 finalColor = texture(TEXTURE, distorted_uv);
    finalColor.a = textureVideo.a;

    // Scanlines
    float brightness = scanline(UV);
    finalColor.rgb *= brightness;

    // Teinte style CRT
    finalColor.rgb *= vec3(1.0, 0.2, 0.5);

    COLOR = finalColor;
}