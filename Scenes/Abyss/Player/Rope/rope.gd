class_name RopeScene
extends Node3D

const PIN_BIAS := 2.0

@export var segment_count := 20
@export var segment_height := 0.1
@export var segment_radius := 0.02
@export var segment_scene: PackedScene

@onready var rope_start: AnimatableBody3D = %RopeStart
@onready var rope_end: AnimatableBody3D = %RopeEnd


func _ready():
	generate_rope()


func set_rope_start(p: Vector3):
	rope_start.global_position = p


func set_rope_end(p: Vector3):
	rope_end.global_position = p


func generate_rope():
	var previous_node = rope_start

	rope_start.position = Vector3(0, 0, 0)
	rope_end.position = Vector3(0, segment_count * segment_height, 0)

	for i in range(segment_count):
		var pin = PinJoint3D.new()
		pin.position.y = i * segment_height
		pin.set_param(PinJoint3D.PARAM_BIAS, PIN_BIAS)

		var new_segment = segment_scene.instantiate()
		add_child(new_segment)
		new_segment.position.y = i * segment_height + segment_height / 2
		new_segment.set_data(segment_radius, segment_height)

		add_child(pin)
		pin.node_a = pin.get_path_to(previous_node)
		pin.node_b = pin.get_path_to(new_segment)

		previous_node = new_segment

	var pin = PinJoint3D.new()
	pin.set_param(PinJoint3D.PARAM_BIAS, PIN_BIAS)
	pin.position.y = segment_count * segment_height

	add_child(pin)
	pin.node_a = pin.get_path_to(previous_node)
	pin.node_b = pin.get_path_to(rope_end)


func check_rope():
	var total_rope_length = segment_count * segment_height
	var anchor_distance = rope_start.global_position.distance_to(rope_end.global_position)
	var slack = total_rope_length - anchor_distance

	return slack
