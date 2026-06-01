class_name MaxJumpsUpgrade
extends Upgrade

@export var constant_upgrade: int = 0


func apply():
	super.apply()
	Globals.player_data.max_jumps += constant_upgrade
