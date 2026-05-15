shader_type canvas_item;

uniform vec4 bullet_color : source_color;

void vertex() {
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(UV.x > 0.45 && UV.x < 0.55 && UV.y > 0.45 && UV.y < 0.55){
		COLOR = bullet_color;
	} else {
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
