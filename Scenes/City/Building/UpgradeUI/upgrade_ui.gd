extends HBoxContainer

@export var upgrade: Upgrade
@export var cost_marker_scene: PackedScene

@onready var icon: TextureRect = %Icon
@onready var title: Label = %Title
@onready var cost_container: HBoxContainer = %CostContainer
@onready var description: Label = %Description
@onready var purchase_button: Button = %PurchaseButton


func _ready() -> void:
	EventBus.update_inventory.connect(update)


func update():
	icon.texture = upgrade.icon
	title.text = upgrade.name

	for child in cost_container.get_children():
		child.queue_free()

	for type in upgrade.price:
		var cost = cost_marker_scene.instantiate()
		cost_container.add_child(cost)
		cost.set_text(str(upgrade.price[type]))
		cost.set_texture(type.sprite)
		cost.set_tooltip("%s x %d" % [type.name, upgrade.price[type]])

	description.text = upgrade.description

	purchase_button.disabled = not upgrade.can_purchase()


func _on_purchase_button_pressed() -> void:
	upgrade.apply()
