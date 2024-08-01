shader_type canvas_item;

uniform vec4 skin_darken : source_color;
uniform vec4 eyes : source_color;

void fragment() {
	if (COLOR == vec4(vec3(0), 1)) {
		COLOR = skin_darken;
	} else if (COLOR == vec4(0, 0, 1, 1)) {
		COLOR = eyes;
	}
}