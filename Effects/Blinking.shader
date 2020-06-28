shader_type canvas_item;

uniform bool active = true;

void fragment(){
	vec4 main_colour = texture(TEXTURE, UV);
	vec4 to_white = main_colour;
	if (active) { to_white = vec4(1, 1, 1, main_colour.a); }
	COLOR = to_white;
}