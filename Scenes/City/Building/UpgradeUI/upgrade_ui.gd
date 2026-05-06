extends HBoxContainer

@export var upgrade: Upgrade:
	set(new):
		upgrade = new

		if new != null and is_node_ready():
			update()

@onready var icon: TextureRect = %Icon
@onready var title: Label = %Title
@onready var description: Label = %Description


func _ready() -> void:
	update()


func update():
	icon.texture = upgrade.icon
	title.text = upgrade.name
	description.text = upgrade.description
