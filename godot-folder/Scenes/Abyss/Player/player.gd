extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSATIVITY = 0.002
const CONTROLLER_SENSATIVITY = 0.1
const PITCH_LIMIT = 85.0

@onready var pivot_node: Node3D = %"Pivot Node"


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

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSATIVITY)
		pivot_node.rotate_x(-event.relative.y * MOUSE_SENSATIVITY)
		var current_pitch: float = pivot_node.rotation.x
		var min_pitch: float = deg_to_rad(-PITCH_LIMIT)
		var max_pitch: float = deg_to_rad(PITCH_LIMIT)
		pivot_node.rotation.x = clamp(current_pitch, min_pitch, max_pitch)
