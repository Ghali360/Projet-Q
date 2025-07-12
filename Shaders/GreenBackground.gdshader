shader_type canvas_item;

// Paramètres du filtre de couleur
uniform vec4 filter_color : source_color = vec4(0.749, 0.016, 0.416, 1.0);
uniform float filter_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float filter_blend_mode : hint_range(0.0, 4.0) = 0.0; // 0:Normal, 1:Add, 2:Multiply, 3:Screen, 4:Overlay

// Paramètres de suppression du fond vert
uniform bool enable_chroma_key = true;
uniform vec3 chroma_key_color = vec3(0.0, 0.729, 0.0);
uniform float chroma_key_threshold : hint_range(0.0, 1.0) = 0.4;
uniform float green_suppression : hint_range(0.0, 1.0) = 0.7;

void fragment() {
    // Échantillon original de la texture vidéo
    vec4 textureVideo = texture(TEXTURE, UV);
    
    // Suppression du fond vert (chroma key)
    if (enable_chroma_key) {
        float diff = distance(textureVideo.rgb, chroma_key_color);
        if (diff < chroma_key_threshold) {
            textureVideo.a = 0.0;
        }
        
        // Suppression supplémentaire des tons verts
        if (textureVideo.g > green_suppression && 
            textureVideo.r <= (1.0 - green_suppression) && 
            textureVideo.b <= (1.0 - green_suppression)) {
            textureVideo.a = 0.0;
        }
    }
    
    // Application du filtre de couleur
    vec4 filteredColor = textureVideo;
    
    if (filter_opacity > 0.0) {
        vec3 filterRGB = filter_color.rgb;
        float blendAmount = filter_opacity * filter_color.a;
        
        // Modes de fusion
        if (filter_blend_mode < 0.5) {
            // Mode Normal (simple mix)
            filteredColor.rgb = mix(filteredColor.rgb, filterRGB, blendAmount);
        } 
        else if (filter_blend_mode < 1.5) {
            // Mode Addition
            filteredColor.rgb += filterRGB * blendAmount;
        } 
        else if (filter_blend_mode < 2.5) {
            // Mode Multiplication
            filteredColor.rgb *= mix(vec3(1.0), filterRGB, blendAmount);
        } 
        else if (filter_blend_mode < 3.5) {
            // Mode Screen: 1.0 - (1.0 - A) * (1.0 - B)
            filteredColor.rgb = 1.0 - (1.0 - filteredColor.rgb) * (1.0 - filterRGB * blendAmount);
        } 
        else {
            // Mode Overlay
            vec3 base = filteredColor.rgb;
            vec3 blend = filterRGB * blendAmount;
            filteredColor.rgb = mix(
                2.0 * base * blend,
                1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
                step(0.5, base)
            );
        }
    }
    
    // Conservation de la transparence nettoyée
    filteredColor.a = textureVideo.a;
    
    COLOR = filteredColor;
}