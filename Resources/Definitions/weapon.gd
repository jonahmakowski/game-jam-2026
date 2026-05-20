class_name Weapon
extends Building

@export var damage: float
## In seconds between firing
@export var firerate: float
@export_group("Projectile Settings")
@export_enum("Laser", "Projectile") var projectile_type: int
@export_subgroup("Laser", "laser")
@export var laser_shader: Shader = preload("uid://dqlu5rs2x8f8s")
@export var laser_color: Color
## How long in seconds it takes to go from 0.0 to 1.0
@export var laser_speed: float
@export_range(0.0, 1.0) var laser_width: float = 0.5
@export_subgroup("Projectile", "projectile")
@export var projectile_asset: Texture2D
@export var projectile_speed: int
