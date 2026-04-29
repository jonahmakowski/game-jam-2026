class_name Ore
extends Resource

@export var name: String
@export var to_drop: Item
@export var rock_part: ArrayMesh
@export var ore_part: ArrayMesh
@export var health: int
@export var rock_shader: Shader
@export var mineral_shader: Shader
## As rarity increases, it becomes more common
@export var rarity: int = 1
