class_name WeaponUpgrade
extends Upgrade

@export var damage_percentage_increase: float = 0.0
@export var damage_constant_increase: float = 0.0
@export var firerate_percentage: float = 0.0

var weapon_scene: WeaponScene
var weapon: Weapon


func apply():
	for item in price:
		for i in range(price[item]):
			if item not in Globals.player_data.city_inventory:
				push_error("Player doesn't have items to buy this upgrade")

			var index = Globals.player_data.city_inventory.find(item)
			Globals.player_data.city_inventory.remove_at(index)

	## Remove building from the building's upgrades
	weapon.upgrades.remove_at(weapon.upgrades.find(self))

	EventBus.update_inventory.emit()
	EventBus.update_upgrades.emit()

	weapon.damage *= 1 + damage_percentage_increase
	weapon.damage += damage_constant_increase
	weapon.firerate -= weapon.firerate * (firerate_percentage / 100)
