@tool
extends EditorScript

const POSITIONS = [
	Vector3(-94.5487, -81.12161, -93.60976),
	Vector3(-102.5417, -82.20398, -81.17628),
	Vector3(69.62313, -106.9167, -120.886),
	Vector3(-43.84459, 71.08082, 113.9685),
	Vector3(97.74528, 56.82775, 73.72391),
	Vector3(59.91122, 109.3922, -94.11208),
	Vector3(-110.9628, 166.1472, 17.07467),
	Vector3(110.9726, 55.09351, -44.42659),
	Vector3(113.0988, 54.11467, 34.99991),
	Vector3(84.78486, 80.3544, 82.06402),
	Vector3(-8.479722, 25.23934, 117.3637),
	Vector3(46.02481, -1.945028, 112.7828),
	Vector3(-106.6718, -106.8672, 90.33102),
	Vector3(-109.3124, -14.23706, 68.77043),
	Vector3(-142.3124, -161.5706, 18.12938),
]

var scene: PackedScene = preload("uid://j7mx53rdut7j")
var possible_ores: Array[Ore] = [preload("uid://bo8rf66bpefv5"), preload("uid://c4ypk5186d5q2")]
var possible_monster: Array[Monster] = [preload("uid://b6j4q5yinv5y1")]


func add_children():
	var selection = EditorInterface.get_selection()
	var child_of = selection.get_selected_nodes()[0]

	for child in child_of.get_children():
		child.queue_free()

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
