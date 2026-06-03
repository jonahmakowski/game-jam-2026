extends Node2D

const BACKGROUND = preload("uid://bxlyaf1cl36xr")

@onready var camera_2d: Camera2D = %Camera2D
@onready var background_size := BACKGROUND.get_size()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Globals.player_data.city_inventory.append_array(Globals.player_data.inventory)
	Globals.player_data.inventory = []
	EventBus.update_inventory.emit()
	Globals.player_data.city_health = min(Globals.player_data.city_max_health, Globals.player_data.city_health + Globals.player_data.city_repair_speed)


func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	camera_2d.position += input_dir * Constants.CAMERA_MOVE_SPEED

	var clamp_x = background_size.x
	var clamp_y = background_size.y

	camera_2d.position.x = clamp(camera_2d.position.x, -clamp_x, clamp_x)
	camera_2d.position.y = clamp(camera_2d.position.y, -clamp_y, clamp_y)
