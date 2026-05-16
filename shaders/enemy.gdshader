shader_type canvas_item;

uniform vec4 player_color : source_color;
uniform vec4 hurt_color : source_color;
uniform float hurt_value : hint_range(0,1,.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR.b < 0.5){
		discard;
	}
	COLOR.r = 1.-COLOR.r;
	COLOR.g = 1.-COLOR.g*.2;
	//COLOR = player_color;
	
	vec4 prev = COLOR.rgba;
	COLOR = mix(prev, hurt_color, hurt_value);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
