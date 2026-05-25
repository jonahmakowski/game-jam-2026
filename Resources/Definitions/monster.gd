class_name Monster
extends Resource

@export var to_drop: Item
@export var model: PackedScene
## Monsters are expected to have a "walk" animation
@export var sprite: SpriteFrames
@export var sprite_size: Vector2i
@export var health: int
@export var damage: float
@export var damage_cooldown: float
@export var speed_3d: float
@export var speed_2d: float
@export var agro_range: float
@export_enum("flying", "walking") var monster_type = "flying"
## Higher rarity == less common
@export var rarity: int = 1
