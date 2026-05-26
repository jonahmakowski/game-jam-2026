class_name WeaponScene
extends Node2D

@export var weapon: Weapon
@export var laser_scene: PackedScene
@export var upgrade_ui_scene: PackedScene

var mouse_in_area = false

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var fire_timer: Timer = %FireTimer
@onready var projectile_folder: CanvasGroup = %ProjectileFolder
@onready var area_2d: Area2D = %Area2D
@onready var ui_layer: CanvasLayer = %UILayer
@onready var upgrade_parent: VBoxContainer = %UpgradeParent
@onready var title_label: Label = %TitleLabel


func _ready() -> void:
	ui_layer.hide()
	if not Engine.is_editor_hint():
		EventBus.hide_building_ui.connect(ui_layer.hide)
		EventBus.update_upgrades.connect(setup_upgrades)
		setup()
		setup_upgrades()


func _process(_delta: float) -> void:
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_building") and mouse_in_area:
		EventBus.hide_building_ui.emit()
		ui_layer.show()
		get_viewport().set_input_as_handled()


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
	title_label.text = weapon.name
	weapon = weapon.duplicate()
	weapon.weapon_scene = self
	sprite.sprite_frames = weapon.sprite


func setup_upgrades():
	for child in upgrade_parent.get_children():
		child.queue_free()

	for upgrade in weapon.upgrades:
		if not upgrade.has_prereq():
			continue

		var instance = upgrade_ui_scene.instantiate()
		instance.upgrade = upgrade
		upgrade_parent.add_child(instance)


func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false


func _on_close_button_pressed() -> void:
	ui_layer.hide()
