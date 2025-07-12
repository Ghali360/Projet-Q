shader_type canvas_item;

// Fonction scanline CRT
float scanline(vec2 uv) {
    return 0.9 + 0.1 * sin(uv.y * 800.0);
}

// Fonction de distorsion CRT — uniquement vertical
vec2 crt_distort(vec2 uv, float time) {
    vec2 centered = uv - vec2(0.5);
    float dist = dot(centered, centered);

    // Effet de bande qui défile verticalement
    float scroll_speed = 0.1; // vitesse du défilement
    uv.y = mod(uv.y + time * scroll_speed, 1.0); // reboucle verticalement

    return uv + centered * dist * 0.1;
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

    // Coordonnées UV avec distorsion verticale uniquement
    vec2 distorted_uv = crt_distort(UV, TIME);
    vec4 finalColor = texture(TEXTURE, distorted_uv);
    finalColor.a = textureVideo.a;

    // Scanlines
    float brightness = scanline(UV);
    finalColor.rgb *= brightness;

    // Teinte style CRT
    finalColor.rgb *= vec3(1.0, 0.6, 0.5);

    COLOR = finalColor;
}
