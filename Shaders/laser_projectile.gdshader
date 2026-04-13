shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.5;
uniform float direction: hint_range(0.0, 1.0, 1.0) = 1;
uniform float width: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	COLOR.rgb = vec3(1);
	
	float bottom_fade = 1. - smoothstep(0.5, (1. - width) / 2., UV.y);
	float top_fade = 1. - smoothstep(0.5, (1. - width) / 2., 1. - UV.y);
	
	COLOR.a = top_fade * bottom_fade * step(abs(direction - UV.x), progress);
}
