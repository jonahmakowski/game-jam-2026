@tool
extends Node3D

@export var shader: Shader
@export var city_scene: PackedScene

@onready var rope: RopeScene = %Rope


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rope.visible = Globals.loaded_settings.show_rope

	Helper.apply_shader($BlockyTerrain, shader)
	($BlockyTerrain.get_children().filter(func(node): return node is NavigationRegion3D)[0] as NavigationRegion3D).navigation_mesh.agent_max_slope = 90
	($BlockyTerrain.get_children().filter(func(node): return node is NavigationRegion3D)[0] as NavigationRegion3D).navigation_mesh.agent_max_climb = INF


func end_day():
	get_tree().change_scene_to_packed(city_scene)
