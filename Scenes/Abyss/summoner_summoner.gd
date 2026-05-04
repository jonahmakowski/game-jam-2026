@tool
extends EditorScript

const POSITIONS = [
	Vector3(-94.5487, -81.12161, -93.60976),
	Vector3(-102.5417, -82.20398, -81.17628),
	Vector3(-138.4653, -84.87961, -0.272778),
	Vector3(-60.65639, -77.69891, 126.501),
	Vector3(121.8774, -50.71696, 59.35038),
	Vector3(114.5161, -81.28527, -68.0723),
	Vector3(69.62313, -106.9167, -120.886),
	Vector3(61.6744, -107.0785, -124.2105),
	Vector3(-40.83508, -104.7114, -137.6332),
	Vector3(-134.4955, -107.2808, -32.61962),
	Vector3(-43.84459, 71.08082, 113.9685),
	Vector3(97.74528, 56.82775, 73.72391),
	Vector3(59.91122, 109.3922, -94.11208),
	Vector3(-77.68027, 112.4207, -88.36126),
	Vector3(2.520038, 108.9568, 110.692),
	Vector3(26.24268, 109.2611, 107.9869),
	Vector3(-26.99883, 113.2926, -116.1734),
	Vector3(-29.028, 113.2789, -115.6277),
	Vector3(-79.08152, 112.9765, -88.3756),
	Vector3(71.50534, 164.203, 81.48689),
	Vector3(90.33904, 164.5744, 61.12108),
	Vector3(88.96871, 164.295, 62.35635),
	Vector3(-107.2518, 165.039, 25.29314),
	Vector3(-110.9628, 166.1472, 17.07467),
	Vector3(-108.8403, 164.4815, 3.737135),
]

var scene: PackedScene = preload("uid://by1ssldc3md2j")
var possible_ores: Array[Ore] = [preload("uid://bo8rf66bpefv5")]
var possible_monster: Array[Monster] = [preload("uid://b6j4q5yinv5y1")]


func add_children():
	var selection = EditorInterface.get_selection()
	var child_of = selection.get_selected_nodes()[0]

	for position in POSITIONS:
		var instance = (scene.instantiate() as Node3D)

		if instance is OreSummonerScene:
			(instance as OreSummonerScene).possible_ores = possible_ores
		elif instance is MonsterSummonerScene:
			(instance as MonsterSummonerScene).possible_monsters = possible_monster

		child_of.add_child(instance)
		instance.global_position = position
		instance.owner = EditorInterface.get_edited_scene_root()


func _run():
	add_children()
