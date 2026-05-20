shader_type canvas_item;

uniform float circle_thickness: hint_range(0.0, 1.0);

void fragment() {
	float d = distance(vec2(0.5, 0.5), UV);
	COLOR.a = step(d, 0.5) - step(d, circle_thickness/2.);
}
