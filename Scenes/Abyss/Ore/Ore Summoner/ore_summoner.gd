class_name OreSummonerScene
extends Marker3D

@export var possible_ores: Array[Ore]
@export var ore_scene: PackedScene


func _ready() -> void:
	var weighted_array: Array[Ore]

	for ore in possible_ores:
		for i in range(ore.rarity):
			weighted_array.append(ore)

	var selected_ore = weighted_array[randi_range(0, len(weighted_array) - 1)]

	var ore_scene_instance: OreScene = ore_scene.instantiate()

	ore_scene_instance.ore_type = selected_ore
	ore_scene_instance.transform = transform

	call_deferred("replace_with_ore", ore_scene_instance)


func replace_with_ore(to_replace_with: OreScene):
	replace_by(to_replace_with)
	queue_free()
