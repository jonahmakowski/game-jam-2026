extends Node2D


func _ready() -> void:
	Globals.player_data.city_inventory.append_array(Globals.player_data.inventory)
	Globals.player_data.inventory = []
