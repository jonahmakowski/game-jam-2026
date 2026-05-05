class_name Upgrade
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var price: Dictionary[Item, int]


func apply():
	assert(false, "This function should be overwritten")
