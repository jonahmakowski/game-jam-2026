extends Control

var settings := PlayerData.loaded_settings

@onready var fov_setting: SpinBox = %FOVSetting
@onready var show_enemy_health_mode_setting: OptionButton = %ShowEnemyHealthModeSetting


func _ready() -> void:
	arrange_settings()


func arrange_settings():
	fov_setting.value = settings.fov
	show_enemy_health_mode_setting.selected = { "On Agro": 0, "Always": 1, "Never": 2 }[settings.show_enemy_health_mode]


func save_settings():
	var new_settings = Settings.new()
	new_settings.fov = fov_setting.value
	new_settings.show_enemy_health_mode = ["On Agro", "Always", "Never"][show_enemy_health_mode_setting.get_selected_id()]

	Helper.save_settings(new_settings)
	PlayerData.loaded_settings = new_settings
	settings = new_settings


func _on_cancel_button_pressed() -> void:
	hide()
	arrange_settings()


func _on_apply_button_pressed() -> void:
	save_settings()
	hide()
