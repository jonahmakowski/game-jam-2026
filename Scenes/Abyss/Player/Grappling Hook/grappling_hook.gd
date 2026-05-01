class_name GrapplingHookScene
extends Node3D

const MAX_LENGTH = 500000.0
const SPEED = 100

var active = false

@onready var ray_cast_3d: RayCast3D = %RayCast3D
@onready var rope: RopeScene = %Rope
@onready var marker: Marker3D = %Marker3D
@onready var player: PlayerScene = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("grappling_hook"):
		activate()

	if active:
		rope.rope_length = global_position.distance_to(marker.global_position)
		player.velocity = global_position.direction_to(marker.global_position) * SPEED
		if rope.rope_length < 3:
			player.velocity = Vector3.ZERO
			active = false
			rope.visible = false
			player.jumps_left = Constants.PLAYER_MAX_JUMPS


func activate():
	if not active:
		ray_cast_3d.target_position = Vector3(0, 0, -MAX_LENGTH)
		ray_cast_3d.force_raycast_update()

		if not ray_cast_3d.is_colliding():
			return

		marker.position = ray_cast_3d.get_collision_point()

		# Check if the grappling hook's end position is out of the range of the main rope
		var other_endpoint := player.rope_scene.endpoint_a if player.rope_scene.endpoint_a != player else player.rope_scene.endpoint_b

		if marker.position.distance_to(other_endpoint.global_position) > player.rope_scene.rope_max_length:
			return

		rope.visible = true
		rope.rope_length = global_position.distance_to(marker.global_position)
		rope.endpoint_a = self
		rope.endpoint_b = marker

		active = true
