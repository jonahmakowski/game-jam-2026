class_name Building
extends Resource

@export var sprite: Texture2D
@export var name: String
@export var upgrades: Array[Upgrade]:
	set(val):
		upgrades = val

		for upgrade in upgrades:
			upgrade.building = self
