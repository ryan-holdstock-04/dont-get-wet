shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest, repeat_disable;
uniform vec2 size = vec2(12.,12.);
uniform int segments = 250;
uniform vec4 col : source_color;
uniform float daylight : hint_range(0.,1.,.1);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(col.rgb,daylight);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
