@tool
extends StaticBody3D

@export var ore_type: Ore

var current_health: int

@onready var model: Node3D = %Model
@onready var collision_shape: CollisionShape3D = %CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set model to the one from the ore_type var
	for child in model.get_children():
		child.queue_free()

	model.add_child(ore_type.model.instantiate())

	# Update collisions to the new model
	set_collisions()

	# Set current health to max health
	current_health = ore_type.health


func set_collisions():
	var aabb := Helper.get_aabb(model)
	var box := BoxShape3D.new()
	box.size = aabb.size
	collision_shape.shape = box
