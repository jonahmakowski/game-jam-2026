extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Globals.player_data.city_inventory.append_array(Globals.player_data.inventory)
	Globals.player_data.inventory = []
	EventBus.update_inventory.emit()
	Globals.player_data.city_health = min(Globals.player_data.city_max_health, Globals.player_data.city_health + Globals.player_data.city_repair_speed)
