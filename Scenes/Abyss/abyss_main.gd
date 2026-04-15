@tool
extends Node3D

@export var shader: Shader


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Helper.apply_shader($BlockyTerrain, shader)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
