extends CanvasLayer

@export var inventory_scene: PackedScene

@onready var hider: PanelContainer = %Hider
@onready var stats_parent: VBoxContainer = %StatsParent
@onready var inventory_parent: VBoxContainer = %InventoryParent


func _ready() -> void:
	EventBus.update_inventory.connect(_update_inventory)
	EventBus.hide_building_ui.connect(hider.hide)
	_update_inventory()
	_update_stats()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_inventory"):
		if !hider.visible:
			EventBus.hide_building_ui.emit()
		hider.visible = !hider.visible
		get_viewport().set_input_as_handled()


func _update_inventory():
	var inventory_data = Helper.get_inventory_counts(false)

	for child in inventory_parent.get_children():
		child.queue_free()

	for item in inventory_data.keys():
		var instance = inventory_scene.instantiate()
		inventory_parent.add_child(instance)
		instance.set_data(item.sprite, "%s x%d" % [item.name, inventory_data[item]])


func _update_stats():
	var start_showing = false
	var player_data_script: Script = Globals.player_data.get_script()
	for property in player_data_script.get_script_property_list():
		var property_name: String = property.name
		if property_name == "Player Stats":
			start_showing = true

		elif start_showing:
			var property_value = Globals.player_data.get(property_name)

			if property_value == null:
				continue

			var label_instance = Label.new()
			label_instance.text = "%s: %s" % [property_name.replace("_", " ").capitalize(), str(property_value)]
			stats_parent.add_child(label_instance)


func _on_close_button_pressed() -> void:
	hider.hide()
