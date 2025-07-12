shader_type canvas_item;

// Paramètres de base
uniform float frequency : hint_range(0.1, 20.0) = 3.0;
uniform float intensity : hint_range(0.0, 1.0) = 0.8;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 0.9);
uniform bool smooth_blink = true;

// Contrôle de durée
uniform bool timed_flash = false;
uniform float max_duration : hint_range(0.0, 10.0) = 2.0;
uniform float start_time = 0.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    float time_elapsed = TIME - start_time;
    
    // Vérifie si l'effet doit être appliqué
    bool apply_flash = !timed_flash || (time_elapsed < max_duration);
    
    if (apply_flash) {
        // Calcul de l'effet de clignotement
        float blink_effect;
        
        if (smooth_blink) {
            blink_effect = abs(sin(TIME * frequency));
        } else {
            blink_effect = step(0.5, mod(TIME * frequency, 2.0));
        }
        
        vec3 result = mix(
            original.rgb,
            flash_color.rgb * flash_color.a,
            blink_effect * intensity
        );
        
        COLOR = vec4(result, original.a);
    } else {
        // Désactive l'effet après la durée maximale
        COLOR = original;
    }
}