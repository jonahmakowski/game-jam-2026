class_name WeaponUpgrade
extends Upgrade

@export var damage_percentage_increase: float = 0.0
@export var damage_constant_increase: float = 0.0
@export var firerate_percentage_increase: float = 0.0

var weapon_scene: WeaponScene
var weapon: Weapon


func apply():
	weapon.damage *= 1 + damage_percentage_increase
	weapon.damage += damage_constant_increase
	weapon.firerate = weapon.firerate / (1 + firerate_percentage_increase)
