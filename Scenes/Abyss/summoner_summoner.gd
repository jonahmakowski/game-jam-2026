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
	Vector3(-110.5615, -12.80045, 67.64799),
	Vector3(-123.2064, -0.680496, -8.451603),
	Vector3(-39.0041, 56.45502, -115.796),
	Vector3(-6.441544, 53.65374, -116.8556),
	Vector3(93.48227, 55.39699, -75.85368),
	Vector3(110.9726, 55.09351, -44.42659),
	Vector3(113.0988, 54.11467, 34.99991),
	Vector3(84.78486, 80.3544, 82.06402),
	Vector3(-8.479722, 25.23934, 117.3637),
	Vector3(46.02481, -1.945028, 112.7828),
	Vector3(91.94789, 0.771635, 87.61864),
	Vector3(120.3208, -1.300672, 24.65687),
	Vector3(115.6967, -160.8824, 87.9515),
	Vector3(107.8674, -161.5531, 95.22549),
	Vector3(-15.72284, -160.0639, 145.9185),
	Vector3(-57.52267, -173.3096, 140.6816),
	Vector3(-102.1266, -175.8757, 101.0326),
	Vector3(-106.6718, -106.8672, 90.33102),
	Vector3(-109.3124, -14.23706, 68.77043),
]

var scene: PackedScene = preload("uid://by1ssldc3md2j")
var possible_ores: Array[Ore] = [preload("uid://bo8rf66bpefv5")]
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
