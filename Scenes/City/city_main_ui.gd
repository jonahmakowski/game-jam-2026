extends CanvasLayer

@export var inventory_scene: PackedScene

@onready var stats_parent: VBoxContainer = %StatsParent
@onready var inventory_parent: VBoxContainer = %InventoryParent


func _ready() -> void:
	EventBus.update_inventory.connect(_update_inventory)
	_update_inventory()


func _update_inventory():
	var inventory_data = Helper.get_inventory_counts(false)

	for child in inventory_parent.get_children():
		child.queue_free()

	for item in inventory_data.keys():
		var instance = inventory_scene.instantiate()
		inventory_parent.add_child(instance)
		instance.set_data(item.sprite, "%s x%d" % [item.name, inventory_data[item]])
