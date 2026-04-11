shader_type canvas_item;

instance uniform float progress: hint_range(0.0, 1.0) = 1.;

void fragment() {
	COLOR.a = step(UV.x, progress);
}
