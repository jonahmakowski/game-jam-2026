@tool
class_name MonsterScene
extends CharacterBody3D

@export var monster_data: Monster

@onready var player_finder: RayCast3D = %PlayerFinder
@onready var player: PlayerScene = get_tree().get_first_node_in_group("player")
@onready var model: Node3D = %Model
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D


func _ready() -> void:
	model.add_child(monster_data.model.instantiate())


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		match monster_data.monster_type:
			"flying":
				velocity = Vector3.ZERO

				if can_see_player():
					model.look_at(position + global_position.direction_to(player.global_position))
					velocity = global_position.direction_to(player.global_position) * monster_data.speed
			"walking":
				velocity = Vector3.ZERO

				nav_agent.target_position = player.global_position

				if not nav_agent.is_navigation_finished():
					var next_position = nav_agent.get_next_path_position()
					if can_see_player():
						if global_position != next_position:
							model.look_at(position + global_position.direction_to(next_position))
						velocity = global_position.direction_to(next_position) * monster_data.speed
				else:
					model.look_at(position + global_position.direction_to(player.global_position))
			_:
				push_error("Running a monster type that is not permited")
				assert(false, "Running a monster type that is not permited")

		move_and_slide()


func can_see_player() -> bool:
	if global_position.distance_to(player.global_position) < monster_data.agro_range:
		player_finder.target_position = global_position.direction_to(player.global_position) * monster_data.agro_range
		player_finder.force_raycast_update()
		if player_finder.get_collider() == player:
			return true

	return false
