class_name InventorySizeUpgrade
extends Upgrade

@export var constant_upgrade: int = 0


func apply():
	super.apply()
	Globals.player_data.max_inventory_size += constant_upgrade
