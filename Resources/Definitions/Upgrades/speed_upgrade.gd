class_name SpeedUpgrade
extends Upgrade

## Between 0-100
@export var percentage_upgrade: float = 0
@export var constant_upgrade: float = 0


func apply():
	super.apply()
	Globals.player_data.speed *= 1 + (percentage_upgrade / 100)
	Globals.player_data.speed += constant_upgrade
