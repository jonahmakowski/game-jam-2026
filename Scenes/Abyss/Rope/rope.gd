@tool
class_name RopeScene
extends Node3D

@export var rope_slack: float = 1.53
@export var rope_max_length: float = 5.0
@export var segments: int = 20
@export var rope_radius: float = 0.02
@export var endpoint_a: Node3D
@export var endpoint_b: Node3D
@export var endpoint_a_offset := Vector3(0, 0, 0)
@export var endpoint_b_offset := Vector3(0, 0, 0)

var rope_length: float
var immediate_mesh: ImmediateMesh

@onready var mesh_instance: MeshInstance3D = %MeshInstance3D


func _ready():
	immediate_mesh = ImmediateMesh.new()
	mesh_instance.mesh = immediate_mesh

	if not Engine.is_editor_hint():
		if endpoint_a != null and endpoint_a.has_method("set_rope_scene"):
			endpoint_a.set_rope_scene(self, endpoint_b)
		if endpoint_b != null and endpoint_b.has_method("set_rope_scene"):
			endpoint_b.set_rope_scene(self, endpoint_a)


func _process(_delta):
	if endpoint_a == null or endpoint_b == null:
		return
	rope_length = min(endpoint_a.global_position.distance_to(endpoint_b.global_position) * rope_slack, rope_max_length)
	draw_rope()


func get_span_distance() -> float:
	return endpoint_a.global_position.distance_to(endpoint_b.global_position)


func draw_rope():
	immediate_mesh.clear_surfaces()

	var points = get_catenary_points()
	var sides = 6

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(points.size() - 1):
		var a = points[i]
		var b = points[i + 1]

		var forward = (b - a).normalized()

		var up = Vector3.UP
		if abs(forward.dot(up)) > 0.9:
			up = Vector3.RIGHT
		var right = forward.cross(up).normalized()
		var actual_up = right.cross(forward).normalized()

		for s in range(sides):
			var angle_a = (float(s) / sides) * TAU
			var angle_b = (float(s + 1) / sides) * TAU

			var offset_a = (cos(angle_a) * right + sin(angle_a) * actual_up) * rope_radius
			var offset_b = (cos(angle_b) * right + sin(angle_b) * actual_up) * rope_radius

			var normal_a = (cos(angle_a) * right + sin(angle_a) * actual_up).normalized()
			var normal_b = (cos(angle_b) * right + sin(angle_b) * actual_up).normalized()

			immediate_mesh.surface_set_normal(normal_a)
			immediate_mesh.surface_add_vertex(a + offset_a)
			immediate_mesh.surface_set_normal(normal_a)
			immediate_mesh.surface_add_vertex(b + offset_a)
			immediate_mesh.surface_set_normal(normal_b)
			immediate_mesh.surface_add_vertex(a + offset_b)

			immediate_mesh.surface_set_normal(normal_a)
			immediate_mesh.surface_add_vertex(b + offset_a)
			immediate_mesh.surface_set_normal(normal_b)
			immediate_mesh.surface_add_vertex(b + offset_b)
			immediate_mesh.surface_set_normal(normal_b)
			immediate_mesh.surface_add_vertex(a + offset_b)

	immediate_mesh.surface_end()


func get_catenary_points() -> Array:
	var start = endpoint_a.global_position + endpoint_a_offset
	var end = endpoint_b.global_position + endpoint_b_offset
	var points = []

	var slack = max(rope_length - start.distance_to(end), 0.0)

	var sag = slack * 2.0

	for i in range(segments + 1):
		var t = float(i) / float(segments)

		var x = lerp(start.x, end.x, t)
		var z = lerp(start.z, end.z, t)

		var y = lerp(start.y, end.y, t) - sag * t * (1.0 - t)

		points.append(Vector3(x, y, z))

	return points
