class_name PlayerData
extends Resource

@export_group("Inventory")
@export var inventory: Array[Item]
@export var city_inventory: Array[Item] = []
@export_group("Player Stats")
@export var max_inventory_size: int = 5
@export var max_energy: int = 60
@export var enemy_damage: int = 2
@export var speed: float = 25.0
@export var jump_velocity: float = 15.0
@export var max_jumps: int = 2
@export var mine_speed: float = 0.5
@export_group("Player Upgrades")
@export var applied_upgrades: Array[Upgrade]


func add_to_inventory_if_possible(item: Item):
	if len(inventory) < max_inventory_size:
		inventory.append(item)
