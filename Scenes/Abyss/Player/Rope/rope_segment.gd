extends RigidBody3D

@onready var mesh: MeshInstance3D = %Mesh
@onready var collision: CollisionShape3D = %Collision
@onready var circle_mesh: MeshInstance3D = %CircleMesh


func set_data(radius: float, height: float):
	var collision_shape = CylinderShape3D.new()
	collision_shape.height = height
	collision_shape.radius = radius
	collision.shape = collision_shape

	var mesh_shape = CylinderMesh.new()
	mesh_shape.height = height
	mesh_shape.bottom_radius = radius
	mesh_shape.top_radius = radius
	mesh.mesh = mesh_shape

	circle_mesh.mesh.radius = 2 * radius
	circle_mesh.mesh.height = 2 * radius * 2
	circle_mesh.position.y = height / 2 + 2 * radius
