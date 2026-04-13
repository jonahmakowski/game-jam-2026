class_name PlayerScene
extends CharacterBody3D

const SPEED = 5.0
const ROPE_SPEED = 100.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSATIVITY = 0.002
const CONTROLLER_SENSATIVITY = 0.1
const PITCH_LIMIT = 85.0

var mining := false
var rope_scene: RopeScene

@onready var pivot_node: Node3D = %"Pivot Node"
@onready var hud: HUD = %HUD
@onready var ray_cast_3d: RayCast3D = %RayCast3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta: float) -> void:
	# Looking via controller
	var look_direction := Input.get_vector("look_right", "look_left", "look_up", "look_down")
	rotate_y(look_direction.x * CONTROLLER_SENSATIVITY)
	pivot_node.rotate_x(-look_direction.y * CONTROLLER_SENSATIVITY)
	var current_pitch: float = pivot_node.rotation.x
	var min_pitch: float = deg_to_rad(-PITCH_LIMIT)
	var max_pitch: float = deg_to_rad(PITCH_LIMIT)
	pivot_node.rotation.x = clamp(current_pitch, min_pitch, max_pitch)

	# Allow mouse to be uncaptured
	if Input.is_action_just_pressed("uncapture_mouse") and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Allow mouse to be recaptured
	if Input.is_action_just_pressed("capture_mouse") and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Rope Stuff
	var other_endpoint := rope_scene.endpoint_a if rope_scene.endpoint_a != self else rope_scene.endpoint_b

	var new_position := velocity + global_position

	if other_endpoint.global_position.distance_to(new_position) > rope_scene.rope_max_length:
		var distance_func := other_endpoint.global_position.distance_to
		var max_length := rope_scene.rope_max_length

		if distance_func.call(global_position + Vector3(velocity.x, 0, 0)) > max_length:
			velocity.x = 0
		if distance_func.call(global_position + Vector3(0, velocity.y, 0)) > max_length:
			velocity.y = 0
		if distance_func.call(global_position + Vector3(0, 0, velocity.z)) > max_length:
			velocity.z = 0

		if distance_func.call(global_position + velocity) > max_length:
			velocity = -other_endpoint.global_position.direction_to(global_position) * ROPE_SPEED

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSATIVITY)
		pivot_node.rotate_x(-event.relative.y * MOUSE_SENSATIVITY)
		var current_pitch: float = pivot_node.rotation.x
		var min_pitch: float = deg_to_rad(-PITCH_LIMIT)
		var max_pitch: float = deg_to_rad(PITCH_LIMIT)
		pivot_node.rotation.x = clamp(current_pitch, min_pitch, max_pitch)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mine_attack"):
		if ray_cast_3d.is_colliding():
			mining = true
			mine()
	elif event.is_action_released("mine_attack"):
		mining = false


func set_rope_scene(scene: RopeScene):
	rope_scene = scene


func mine():
	while mining:
		if ray_cast_3d.is_colliding():
			var looking_at = ray_cast_3d.get_collider()
			if looking_at is OreScene:
				(looking_at as OreScene).mine(1)

			await get_tree().create_timer(0.5).timeout


func update_inventory_grid():
	hud.update_inventory_grid()
