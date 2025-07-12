shader_type canvas_item;

// Paramètres inspirés d'une spirale "Uzumaki"
uniform float spiral_strength : hint_range(0.0, 3.0) = 1.2;
uniform float spiral_density : hint_range(5.0, 50.0) = 20.0;
uniform float spiral_speed : hint_range(0.0, 10.0) = 1.0;
uniform float spiral_center_shift : hint_range(-0.5, 0.5) = 0.0;

// Fonction de spirale inspirée d'une spirale Uzumaki de Junji Ito
vec2 uzumaki_spiral(vec2 uv, float time) {
    vec2 center = vec2(0.5 + spiral_center_shift, 0.5);
    vec2 offset = uv - center;
    float radius = length(offset);
    float angle = atan(offset.y, offset.x);

    // Appliquer un effet de spirale dramatique
    float spiral = spiral_strength * log(1.0 + radius * spiral_density) * sin(radius * spiral_density - time * spiral_speed);
    angle += spiral;

    vec2 twisted = vec2(cos(angle), sin(angle)) * radius;
    return twisted + center;
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

    // Coordonnées UV avec effet spirale inspiré d'Uzumaki
    vec2 distorted_uv = uzumaki_spiral(UV, TIME);
    vec4 finalColor = texture(TEXTURE, distorted_uv);
    finalColor.a = textureVideo.a;

    COLOR = finalColor;
}