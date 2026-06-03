class_name EnemyDamageUpgrade
extends Upgrade

@export var constant_upgrade: int = 0


func apply():
	super.apply()
	Globals.player_data.enemy_damage += constant_upgrade
