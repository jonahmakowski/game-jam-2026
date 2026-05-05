class_name BuildingScene
extends Node2D

@export var building_type: Building
@export var upgrade_ui_scene: PackedScene

var mouse_in_area = false

@onready var sprite: Sprite2D = %Sprite2D
@onready var ui_layer: CanvasLayer = %UILayer
@onready var area_2d: Area2D = %Area2D
@onready var title_label: Label = %TitleLabel
@onready var close_button: TextureButton = %CloseButton
@onready var upgrade_parent: VBoxContainer = %UpgradeParent


func _ready() -> void:
	sprite.texture = building_type.sprite
	title_label.text = building_type.name
	ui_layer.hide()
	EventBus.hide_building_ui.connect(ui_layer.hide)


func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_building") and mouse_in_area:
		ui_layer.show()
		get_viewport().set_input_as_handled()


func setup_upgrades():
	for child in upgrade_parent.get_children():
		child.queue_free()

	for upgrade in building_type.upgrades:
		var instance = upgrade_ui_scene.instantiate()
		instance.upgrade = upgrade
		upgrade_parent.add_child(instance)


func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false


func _on_close_button_pressed() -> void:
	ui_layer.hide()
