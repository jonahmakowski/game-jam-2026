class_name CityRepairSpeedUpgrade
extends Upgrade

@export var constant_upgrade: int = 0


func apply():
	super.apply()
	Globals.player_data.city_repair_speed += constant_upgrade
