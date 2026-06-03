extends Node2D

@export var enemy_scene: PackedScene
@export var monster_data: Monster

var num_of_enemies: int
var enemies_spawned: int = 0
var pathes: Array[Path2D]

@onready var current_wave = Globals.player_data.current_wave
@onready var right_pathes: Node2D = %RightPathes
@onready var left_pathes: Node2D = %LeftPathes
@onready var spawn_timer: Timer = %SpawnTimer


func _ready() -> void:
	Globals.player_data.enemy_damage_mult += 0.1
	Globals.player_data.enemy_health_mult += 0.1
	Globals.player_data.enemy_speed_mult += 0.1
	Globals.player_data.current_wave += 1

	find_pathes()
	num_of_enemies = int(Globals.player_data.current_wave * 0.5) + 2
	spawn_timer.wait_time = 5 - (Globals.player_data.current_wave * 0.5)
	spawn_timer.start()
	_on_spawn_timer_timeout()


func find_pathes():
	for child in right_pathes.get_children():
		pathes.append(child)

	for child in left_pathes.get_children():
		pathes.append(child)


func _on_spawn_timer_timeout() -> void:
	if enemies_spawned >= num_of_enemies:
		return

	var randx = randi_range(0, len(pathes) - 1)

	var instance: MonsterScene2D = enemy_scene.instantiate()
	instance.monster = monster_data
	pathes[randx].add_child(instance)

	enemies_spawned += 1
