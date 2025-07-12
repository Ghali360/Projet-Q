shader_type canvas_item;


void fragment() {

vec4 textureVideo = texture(TEXTURE, UV);

vec3 target_color = vec3(0.9961, 0.0, 0.4235);

float diff = distance(textureVideo.rgb, target_color);
if (diff < 0.4) {
    textureVideo.a = 0.0;
}
    vec4 finalColor = texture(TEXTURE, UV);
    finalColor.a = textureVideo.a; // Conserver la transparence nettoyée

    // Appliquer l'effet de scanline
finalColor.rgb *= vec3(1.0, 0.6, 0.5);
COLOR = finalColor;
}