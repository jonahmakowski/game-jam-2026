class_name Upgrade
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var prereq_upgrade: Upgrade
@export var price: Dictionary[Item, int]


func apply():
	print("Item %s doesn't have an overwritten apply function" % [name])
	assert(false, "This function should be overwritten")


func can_purchase() -> bool:
	var inventory_copy = Globals.player_data.city_inventory.duplicate()
	for item in price.keys():
		for count in range(price[item]):
			if not inventory_copy.has(item):
				return false

			inventory_copy.remove_at(inventory_copy.find(item))

	return true


func has_prereq() -> bool:
	if len(prereq_upgrade) > 0 and prereq_upgrade not in Globals.player_data.applied_upgrades:
		return false
	return true
