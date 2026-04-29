extends Timer

@onready var hud: HUD = %HUD
@onready var player: PlayerScene = get_parent()


func _ready() -> void:
	wait_time = Constants.ENERGY_USE_SPEED
	hud.set_energy(Globals.player_data.max_energy, player.current_energy)
	start()


func _on_timeout():
	player.current_energy -= 1
	hud.set_energy(Globals.player_data.max_energy, player.current_energy)
