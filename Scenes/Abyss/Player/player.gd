class_name PlayerScene
extends CharacterBody3D

var mining := false
var jumps_left := Constants.PLAYER_MAX_JUMPS
var rope_scene: RopeScene
var other_rope_endpoint: Node3D
var pulling_in := false
var current_energy = Globals.player_data.max_energy

@onready var pivot_node: Node3D = %"Pivot Node"
@onready var hud: HUD = %HUD
@onready var ray_cast_3d: RayCast3D = %RayCast3D
@onready var grappling_hook: GrapplingHookScene = %GrapplingHook
@onready var camera: Camera3D = %Camera3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.fov = Globals.loaded_settings.fov


func _process(_delta: float) -> void:
	# Looking via controller
	var look_direction := Input.get_vector("look_right", "look_left", "look_up", "look_down")
	rotate_y(look_direction.x * Constants.PLAYER_CONTROLLER_SENSATIVITY)
	pivot_node.rotate_x(-look_direction.y * Constants.PLAYER_CONTROLLER_SENSATIVITY)
	var current_pitch: float = pivot_node.rotation.x
	var min_pitch: float = deg_to_rad(-Constants.PLAYER_PITCH_LIMIT)
	var max_pitch: float = deg_to_rad(Constants.PLAYER_PITCH_LIMIT)
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
		velocity += get_gravity() * delta * Constants.PLAYER_GRAVITY_MULTIPLYER

	# Jumping
	if is_on_floor():
		jumps_left = Constants.PLAYER_MAX_JUMPS

	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = Constants.PLAYER_JUMP_VELOCITY
		jumps_left -= 1

	# Movement
	if not grappling_hook.active: # Only if the grappling hook isn't pulling you right now
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * Constants.PLAYER_SPEED
			velocity.z = direction.z * Constants.PLAYER_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, Constants.PLAYER_SPEED)
			velocity.z = move_toward(velocity.z, 0, Constants.PLAYER_SPEED)

	# Rope Stuff
	var other_endpoint := rope_scene.endpoint_a if rope_scene.endpoint_a != self else rope_scene.endpoint_b

	var new_position := (velocity * delta) + global_position

	if other_endpoint.global_position.distance_to(new_position) > rope_scene.rope_max_length:
		var sphere_pos = ((global_position - other_rope_endpoint.global_position).normalized() * rope_scene.rope_max_length) + other_rope_endpoint.global_position

		global_position = sphere_pos

		var movement_vector := -other_endpoint.global_position.direction_to(global_position) * Constants.PLAYER_ROPE_SPEED
		velocity.x = movement_vector.x
		velocity.z = movement_vector.z

		velocity.y = move_toward(velocity.y, 0, Constants.PLAYER_ROPE_SPEED * delta)

	move_and_slide()

	# Pulling in
	if pulling_in:
		rope_scene.rope_max_length = move_toward(rope_scene.rope_max_length, 0, Constants.PLAYER_ROPE_SPEED * delta)
		rope_scene.rope_length = rope_scene.rope_max_length
		if rope_scene.rope_max_length == 0:
			get_parent().end_day()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * Constants.PLAYER_MOUSE_SENSATIVITY)
		pivot_node.rotate_x(-event.relative.y * Constants.PLAYER_MOUSE_SENSATIVITY)
		var current_pitch: float = pivot_node.rotation.x
		var min_pitch: float = deg_to_rad(-Constants.PLAYER_PITCH_LIMIT)
		var max_pitch: float = deg_to_rad(Constants.PLAYER_PITCH_LIMIT)
		pivot_node.rotation.x = clamp(current_pitch, min_pitch, max_pitch)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mine_attack"):
		if ray_cast_3d.is_colliding():
			var looking_at = ray_cast_3d.get_collider()
			if looking_at is OreScene:
				mining = true
				mine()
			elif looking_at is MonsterScene:
				attack_monster(looking_at)
	elif event.is_action_released("mine_attack"):
		mining = false

	if event.is_action_pressed("pull_me_in"):
		pulling_in = true


func set_rope_scene(scene: RopeScene, other_endpoint: Node3D):
	rope_scene = scene
	other_rope_endpoint = other_endpoint


func attack_monster(monster: MonsterScene):
	monster.take_damage(Globals.player_data.enemy_damage)


func mine():
	while mining:
		if ray_cast_3d.is_colliding():
			var looking_at = ray_cast_3d.get_collider()
			if looking_at is OreScene:
				(looking_at as OreScene).mine(1)

			await get_tree().create_timer(0.5).timeout
