class_name MonsterSummonerScene
extends Marker3D

@export var possible_monsters: Array[Monster]
@export var monster_scene: PackedScene


func _ready() -> void:
	var weighted_array: Array[Monster]

	for monster in possible_monsters:
		for i in range(monster.rarity):
			weighted_array.append(monster)

	var selected_monster = weighted_array[randi_range(0, len(weighted_array) - 1)]

	var monster_scene_instance: MonsterScene = monster_scene.instantiate()

	monster_scene_instance.ore_type = selected_monster
	monster_scene_instance.transform = transform

	call_deferred("replace_with_ore", monster_scene_instance)


func replace_with_ore(to_replace_with: MonsterScene):
	replace_by(to_replace_with)
	queue_free()
