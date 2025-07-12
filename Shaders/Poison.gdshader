shader_type canvas_item;

// Paramètres de contrôle principal
uniform float pulse_speed : hint_range(0.1, 5.0) = 1.0;
uniform float min_intensity : hint_range(0.0, 1.0) = 0.2;
uniform float max_intensity : hint_range(0.0, 1.0) = 0.8;
uniform vec4 poison_color : source_color = vec4(0.3, 0.9, 0.1, 0.7);

// Paramètres d'apparence
uniform float color_shift_speed : hint_range(0.0, 2.0) = 0.5;
uniform float edge_darkening : hint_range(0.0, 1.0) = 0.4;
uniform float distortion_intensity : hint_range(0.0, 0.1) = 0.02;
uniform float saturation : hint_range(0.0, 2.0) = 1.2;
uniform bool enable_wave_distortion = true;
uniform bool enable_edge_effect = true;

// Contrôle temporel
uniform bool timed_effect = false;
uniform float effect_duration : hint_range(1.0, 10.0) = 5.0;
uniform float start_time = 0.0;
uniform float effect_progress : hint_range(0.0, 1.0) = 1.0;

// Fonction de pulsation personnalisée
float poison_pulse(float time) {
    // Crée une pulsation asymétrique (montée lente, descente rapide)
    float wave = mod(time * pulse_speed, 1.0);
    return (wave < 0.7) ? 
        mix(min_intensity, max_intensity, wave / 0.7) :
        mix(max_intensity, min_intensity, (wave - 0.7) / 0.3);
}

// Fonction de bruit simple pour la distorsion
float simple_noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Gestion du temps
    float time_elapsed = TIME - start_time;
    float active_factor = 1.0;
    
    // Calcul du facteur d'activité si effet temporisé
    if (timed_effect) {
        active_factor = 1.0 - smoothstep(effect_duration - 1.0, effect_duration, time_elapsed);
        active_factor = clamp(active_factor, 0.0, 1.0);
    }
    
    // Distorsion d'onde optionnelle
    vec2 distorted_uv = UV;
    if (enable_wave_distortion) {
        float wave = sin(TIME * 3.0 + UV.y * 10.0) * distortion_intensity * active_factor;
        distorted_uv.x += wave;
    }
    
    // Échantillonnage de la texture originale
    vec4 original = texture(TEXTURE, distorted_uv);
    
    // Calcul de la pulsation actuelle
    float pulse = poison_pulse(TIME) * active_factor * effect_progress;
    
    // Variation de couleur subtile
    vec3 dynamic_color = poison_color.rgb;
    if (color_shift_speed > 0.0) {
        float hue_shift = sin(TIME * color_shift_speed) * 0.1 * active_factor;
        dynamic_color.g = clamp(poison_color.g + hue_shift, 0.4, 0.9);
    }
    
    // Application de la teinte poison
    vec3 poisoned = mix(
        original.rgb, 
        dynamic_color * poison_color.a, 
        pulse
    );
    
    // Augmentation de la saturation
    vec3 saturated = mix(
        vec3(dot(poisoned, vec3(0.299, 0.587, 0.114))),
        poisoned,
        saturation
    );
    
    // Effet de bordure sombre optionnel
    if (enable_edge_effect) {
        float edge_factor = 1.0 - smoothstep(0.0, 0.2, 
            min(min(UV.x, 1.0 - UV.x), min(UV.y, 1.0 - UV.y)));
        saturated *= mix(1.0, 1.0 - edge_darkening, edge_factor);
    }
    
    // Ajout de bruit subtil
    float noise = simple_noise(UV + TIME * 0.5) * 0.1;
    saturated = mix(saturated, saturated * vec3(0.8, 1.2, 0.7), noise * pulse);
    
    // Résultat final (toujours assigner COLOR)
    COLOR = vec4(saturated, original.a);
}