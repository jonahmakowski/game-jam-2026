@tool
class_name OreScene
extends StaticBody3D

@export var ore_type: Ore:
	set(val):
		if val != ore_type:
			ore_type = val
			update_data()

var current_health: int

@onready var model: Node3D = %Model
@onready var collision_shape: CollisionShape3D = %CollisionShape3D


func _ready() -> void:
	update_data()


func update_data():
	if not is_node_ready():
		return

	# Set model to the one from the ore_type var
	for child in model.get_children():
		child.queue_free()

	if ore_type != null:
		model.add_child(ore_type.model.instantiate())

		# Update collisions to the new model
		set_collisions()

		# Set current health to max health
		current_health = ore_type.health

	Helper.apply_shader(model, ore_type.rock_shader)


func set_collisions():
	var aabb := Helper.get_aabb(model)
	var box := BoxShape3D.new()
	box.size = aabb.size
	collision_shape.shape = box


func mine(damage: int):
	current_health -= damage
	scale *= 1.1
	if current_health <= 0:
		PlayerData.inventory.append(ore_type.to_drop)
		EventBus.update_inventory.emit()
		queue_free()

	await get_tree().create_timer(0.1).timeout
	scale = Vector3(1, 1, 1)
