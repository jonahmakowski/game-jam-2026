class_name PlayerData
extends Resource

@export_group("Inventory")
@export var inventory: Array[Item]
@export_group("Player Stats")
@export var max_inventory_size: int = 5
@export var max_energy: int = 10
@export var enemy_damage: int = 2
