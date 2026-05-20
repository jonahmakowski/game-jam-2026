class_name Weapon
extends Resource

@export var damage: float
## In seconds between firing
@export var firerate: float
@export var weapon_range: float
## Expects a "fire" animation
@export var sprite: SpriteFrames
@export var name: String
@export var upgrades: Array[WeaponUpgrade]
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

var weapon_scene: WeaponScene:
	set(val):
		weapon_scene = val
		_give_weapon_scene()


func _give_weapon_scene():
	for upgrade in upgrades:
		upgrade.weapon_scene = weapon_scene
		upgrade.weapon = self
