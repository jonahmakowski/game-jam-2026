class_name PlayerData
extends Resource

@export_group("Inventory")
@export var inventory: Array[Item]
@export var city_inventory: Array[Item]
@export_group("Player Stats")
@export var max_inventory_size: int = 5
@export var max_energy: int = 10
@export var enemy_damage: int = 2
@export var speed = 25.0
@export var jump_velocity = 15.0
@export var max_jumps = 2
