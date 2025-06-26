shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 1;

void fragment() {
	vec4 Shining = texture(TEXTURE, UV);
	float color_average = (Shining.r + Shining.g + Shining.b)/3.0; // utiliser les décimales obligatoirement ici
	//Shining.rgb = mix(Shining.rgb, vec3(color_average,color_average,color_average).rgb, Shining.a); // Azog en noir et blanc
	Shining.rgb = mix(Shining.rgb, flash_color.rgb, flash_modifier); // Azog rouge
	vec4 output = Shining;
	//rend les pixels sélectionnés transparents
	//if (Shining.r > 0.6 && Shining.g > 0.6 && Shining.b > 0.6)
	//{
	//output = vec4(0,0,0,0);
	//}
	COLOR = output;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
