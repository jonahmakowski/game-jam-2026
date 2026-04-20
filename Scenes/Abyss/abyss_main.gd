@tool
extends Node3D

@export var shader: Shader


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Helper.apply_shader($BlockyTerrain, shader)
	($BlockyTerrain.get_children().filter(func(node): return node is NavigationRegion3D)[0] as NavigationRegion3D).navigation_mesh.agent_max_slope = 90
	($BlockyTerrain.get_children().filter(func(node): return node is NavigationRegion3D)[0] as NavigationRegion3D).navigation_mesh.agent_max_climb = INF


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
