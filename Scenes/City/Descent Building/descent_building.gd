extends Node2D

var abyss_scene: PackedScene = preload("res://Scenes/Abyss/abyss_main.tscn")
var monsters_active := true

@onready var ui_layer: CanvasLayer = %UILayer
@onready var popup: Window = %Popup


func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("monster") == null:
		monsters_active = false


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact_building"):
		if !monsters_active:
			ui_layer.show()
		else:
			popup.show()


func _on_cancel_button_pressed() -> void:
	ui_layer.hide()


func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_packed(abyss_scene)
