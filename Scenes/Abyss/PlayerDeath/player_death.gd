extends Control

var city_scene := load("res://Scenes/City/city_main.tscn")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Globals.player_data.inventory = []


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(city_scene)
