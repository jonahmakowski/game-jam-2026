class_name Monster
extends Resource

@export var to_drop: Item
@export var model: PackedScene
@export var sprite: Texture2D
@export var health: int
@export var damage: float
@export var speed: float
@export var agro_range: float
@export_enum("flying", "walking") var monster_type = "flying"
## Higher rarity == less common
@export var rarity: int = 1
