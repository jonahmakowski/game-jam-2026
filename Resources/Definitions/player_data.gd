class_name PlayerData
extends Resource

@export_group("Inventory")
@export var inventory: Array[Item] = []
@export var city_inventory: Array[Item] = []
@export_group("City Data")
@export var city_health: int = 20
@export_group("Player Stats")
@export var max_inventory_size: int = 5
@export var max_energy: int = 60
@export var city_max_health: int = 20
@export var city_repair_speed: int = 5
@export var enemy_damage: int = 2
@export var speed: float = 25.0
@export var jump_velocity: float = 15.0
@export var max_jumps: int = 2
@export var mine_speed: float = 0.5
@export var mine_damage: int = 1
@export var grapling_hook_range: int = 100
@export var current_wave: int = 0
@export_group("Enemy Stats")
@export var enemy_speed_mult: float = 0.9
@export var enemy_health_mult: float = 0.9
@export var enemy_damage_mult: float = 0.9


func add_to_inventory_if_possible(item: Item):
	if len(inventory) < max_inventory_size:
		inventory.append(item)
