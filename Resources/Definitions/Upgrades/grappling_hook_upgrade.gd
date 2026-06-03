class_name GrapplingHookUpgrade
extends Upgrade

## Between 0-100
@export var percentage_upgrade: float = 0
@export var constant_upgrade: int = 0


func apply():
	super.apply()
	@warning_ignore("narrowing_conversion")
	Globals.player_data.grapling_hook_range *= 1 + (percentage_upgrade / 100)
	Globals.player_data.grapling_hook_range += constant_upgrade
