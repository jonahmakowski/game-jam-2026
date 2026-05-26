class_name Upgrade
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var prereq_upgrade: Upgrade
@export var price: Dictionary[Item, int]

var building: Building


func apply():
	## Remove cost
	for item in price:
		for i in range(price[item]):
			if item not in Globals.player_data.city_inventory:
				push_error("Player doesn't have items to buy this upgrade")

			var index = Globals.player_data.city_inventory.find(item)
			Globals.player_data.city_inventory.remove_at(index)

	## Remove building from the building's upgrades
	building.upgrades.remove_at(building.upgrades.find(self))

	EventBus.update_inventory.emit()
	EventBus.update_upgrades.emit()


func can_purchase() -> bool:
	var inventory_copy = Globals.player_data.city_inventory.duplicate()
	for item in price.keys():
		for count in range(price[item]):
			if not inventory_copy.has(item):
				return false

			inventory_copy.remove_at(inventory_copy.find(item))

	return true


func has_prereq() -> bool:
	if prereq_upgrade != null and prereq_upgrade not in Globals.player_data.applied_upgrades:
		return false
	return true


func purchase():
	assert(not can_purchase(), "Can't purchase this upgrade")

	for item in price.keys():
		for count in range(price[item]):
			Globals.player_data.city_inventory.remove_at(Globals.player_data.city_inventory.find(item))
