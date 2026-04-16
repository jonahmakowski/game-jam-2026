class_name PlayerScene
extends CharacterBody3D

const SPEED = 25.0
const ROPE_SPEED = 1000.0
const JUMP_VELOCITY = 15.0
const MAX_JUMPS = 2
const MOUSE_SENSATIVITY = 0.002
const CONTROLLER_SENSATIVITY = 0.1
const PITCH_LIMIT = 85.0
const GRAVITY_MULTIPLYER = 3

var mining := false
var jumps_left := MAX_JUMPS
var rope_scene: RopeScene
var other_rope_endpoint: Node3D
var pulling_in := false

@onready var pivot_node: Node3D = %"Pivot Node"
@onready var hud: HUD = %HUD
@onready var ray_cast_3d: RayCast3D = %RayCast3D
@onready var grappling_hook: GrapplingHookScene = %GrapplingHook


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
		velocity += get_gravity() * delta * GRAVITY_MULTIPLYER

	# Jumping
	if is_on_floor():
		jumps_left = MAX_JUMPS

	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Movement
	if not grappling_hook.active: # Only if the grappling hook isn't pulling you right now
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

	var new_position := (velocity * delta) + global_position

	if other_endpoint.global_position.distance_to(new_position) > rope_scene.rope_max_length:
		var sphere_pos = ((global_position - other_rope_endpoint.global_position).normalized() * rope_scene.rope_max_length) + other_rope_endpoint.global_position

		global_position = sphere_pos

		var movement_vector := -other_endpoint.global_position.direction_to(global_position) * ROPE_SPEED
		velocity.x = movement_vector.x
		velocity.z = movement_vector.z

		velocity.y = move_toward(velocity.y, 0, ROPE_SPEED * delta)

	move_and_slide()

	# Pulling in
	if pulling_in:
		rope_scene.rope_max_length = move_toward(rope_scene.rope_max_length, 0, ROPE_SPEED * delta)


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

	if event.is_action_pressed("pull_me_in"):
		pulling_in = true


func set_rope_scene(scene: RopeScene, other_endpoint: Node3D):
	rope_scene = scene
	other_rope_endpoint = other_endpoint


func mine():
	while mining:
		if ray_cast_3d.is_colliding():
			var looking_at = ray_cast_3d.get_collider()
			if looking_at is OreScene:
				(looking_at as OreScene).mine(1)

			await get_tree().create_timer(0.5).timeout


func update_inventory_grid():
	hud.update_inventory_grid()
