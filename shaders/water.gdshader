shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR.a < 0.2){
		COLOR = vec4(1.,1.,1.,0.);
	} else if(COLOR.b < 0.7) {
		COLOR = vec4(COLOR.rgb, 1.0);
	} else {
		COLOR = vec4(COLOR.rgb, 0.7);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
