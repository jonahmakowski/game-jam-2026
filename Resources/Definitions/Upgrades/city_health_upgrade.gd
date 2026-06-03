class_name CityHealthUpgrade
extends Upgrade

@export var constant_upgrade: int = 0


func apply():
	super.apply()
	Globals.player_data.city_max_health += constant_upgrade
