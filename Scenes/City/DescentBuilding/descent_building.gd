extends Node2D

var abyss_scene: PackedScene = preload("res://Scenes/Abyss/abyss_main.tscn")

@onready var ui_layer: CanvasLayer = $UILayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("interact_building"):
		ui_layer.show()


func _on_cancel_button_pressed() -> void:
	ui_layer.hide()


func _on_confirm_button_pressed() -> void:
	get_tree().change_scene_to_packed(abyss_scene)
