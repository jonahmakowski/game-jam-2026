extends Control

@export var start_scene: PackedScene

var current_tween: Tween

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var credits_button: Button = %CreditsButton
@onready var buttons: Array[Button] = [%StartButton, %SettingsButton, %CreditsButton]
@onready var settings: Control = %Settings


func _ready():
	for button in buttons:
		var tween_function = func(): current_tween = tween_button(button)
		button.mouse_entered.connect(tween_function)

		var reset_function = func(): reset_button(button)
		button.mouse_exited.connect(reset_function)


func tween_button(button: Button) -> Tween:
	button.pivot_offset = button.size / 2
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.1)

	return tween


func reset_button(button: Button):
	if current_tween != null:
		current_tween.kill()
	button.self_modulate = Color(1, 1, 1, 1)
	button.scale = Vector2(1, 1)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)


func _on_settings_button_pressed() -> void:
	settings.show()
