extends OmniLight3D

@export var light_offset: int

@onready var player: PlayerScene = get_tree().get_first_node_in_group("player")


func _process(_delta: float) -> void:
	global_position.y = player.global_position.y + light_offset
