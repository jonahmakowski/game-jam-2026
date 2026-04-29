extends Node

# Inventory
var inventory: Array[Item]
# Player Stats
var max_inventory_size: int = 5
var enemy_damage: int = 2
var loaded_settings: Settings = Helper.load_settings()
