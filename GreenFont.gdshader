shader_type canvas_item;
render_mode blend_mix, unshaded;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float green_threshold = 0.4;
    float min_green = 0.4;

    if (tex_color.g > min_green && (tex_color.g - max(tex_color.r, tex_color.b)) > green_threshold) {
        tex_color.a = 0.0; // transparent
    }

    COLOR = tex_color;
}
