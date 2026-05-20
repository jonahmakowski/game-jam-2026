class_name WeaponScene
extends Node2D

@export var weapon: Weapon
@export var laser_scene: PackedScene

@onready var range_circle: Sprite2D = %RangeCircle
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var fire_timer: Timer = %FireTimer
@onready var projectile_folder: CanvasGroup = %ProjectileFolder


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not fire_timer.is_stopped():
		return

	var target = find_best_target()

	if target == null:
		return

	var confirmed := target as MonsterScene2D

	look_at(confirmed.global_position)

	sprite.play("fire")

	if weapon.projectile_type == Weapon.ProjectileType.LASER:
		var laser_instance = laser_scene.instantiate()
		laser_instance.origin = global_position
		laser_instance.target = confirmed
		laser_instance.weapon = weapon
		projectile_folder.add_child(laser_instance)

	fire_timer.start(weapon.firerate)


func find_best_target():
	var monsters = get_tree().get_nodes_in_group("monster")

	if len(monsters) == 0:
		return null

	var monster_distance: Dictionary[MonsterScene2D, float]
	for monster in monsters:
		if monster is not MonsterScene2D:
			continue
		monster_distance[monster as MonsterScene2D] = monster.global_position.distance_squared_to(global_position)

	monster_distance.sort()

	var target: MonsterScene2D = monster_distance.keys()[0]

	if target.global_position.distance_to(global_position) > weapon.weapon_range:
		return null
	else:
		return target


func setup():
	weapon = weapon.duplicate()
	weapon.weapon_scene = self
	range_circle.scale = Vector2(weapon.weapon_range, weapon.weapon_range)
	sprite.sprite_frames = weapon.sprite
