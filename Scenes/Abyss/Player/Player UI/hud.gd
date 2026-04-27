class_name HUD
extends Control

@export var inventory_item: PackedScene

@onready var energy_label: Label = %EnergyLabel
@onready var energy_bar: TextureProgressBar = %EnergyBar
@onready var inventory_bar: TextureProgressBar = %InventoryBar
@onready var inventory_label: Label = %InventoryLabel
@onready var inventory_viewer: PanelContainer = %InventoryViewer
@onready var inventory_box: VBoxContainer = %InventoryBox


func _ready():
	update_inventory_grid()
	EventBus.update_inventory.connect(update_inventory_grid)


func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_inventory"):
		inventory_viewer.visible = !inventory_viewer.visible


func set_inventory(full: int, current: int):
	inventory_bar.value = current
	inventory_bar.max_value = full
	inventory_label.text = "%s / %d" % [current, full]


func set_energy(full: int, current: float):
	energy_bar.value = current
	energy_bar.max_value = full
	energy_label.text = "%s / %d" % [Helper.format_float(current), full]


func update_inventory_grid():
	set_inventory(PlayerData.max_inventory_size, len(PlayerData.inventory))

	var inventory_data = Helper.get_inventory_counts()

	for child in inventory_box.get_children():
		child.queue_free()

	if len(inventory_data) > 0:
		for key in inventory_data.keys():
			key = key as Item
			var instance = inventory_item.instantiate()
			inventory_box.add_child(instance)
			instance.set_data(key.sprite, "%s x %d" % [key.name, inventory_data[key]])
	else:
		var instance = inventory_item.instantiate()
		inventory_box.add_child(instance)
		instance.set_data(null, "Inventory is empty")
