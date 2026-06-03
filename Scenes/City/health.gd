extends PanelContainer

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel


func _ready() -> void:
	EventBus.update_hud.connect(_update)
	_update()


func _update():
	health_bar.max_value = Globals.player_data.city_max_health
	health_bar.value = Globals.player_data.city_health
	health_label.text = "%d / %d" % [Globals.player_data.city_health, Globals.player_data.city_max_health]
