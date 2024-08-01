shader_type canvas_item;

uniform bool selected;
uniform sampler2D screen : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 c = textureLod(screen, SCREEN_UV, 0.0);

	if (c.rgb == vec3(0.0) && selected) {
		c.rgb = vec3(1.0);
	}

	COLOR *= c;
}
