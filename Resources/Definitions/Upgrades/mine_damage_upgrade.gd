class_name MineDamageUpgrade
extends Upgrade

## Between 0-100
@export var percentage_upgrade: float = 0
@export var constant_upgrade: int = 0


func apply():
	super.apply()
	Globals.player_data.mine_damage *= round(1 + (percentage_upgrade / 100))
	Globals.player_data.mine_damage += constant_upgrade
