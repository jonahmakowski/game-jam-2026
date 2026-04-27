@tool
class_name MonsterScene
extends CharacterBody3D

const HEALTH_OFFSET = 0.5

@export var monster_data: Monster

var current_health: int
var is_agroed: bool
var animation_player: AnimationPlayer

@onready var player_finder: RayCast3D = %PlayerFinder
@onready var player: PlayerScene = get_tree().get_first_node_in_group("player")
@onready var model: Node3D = %Model
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var health_text: Label = %HealthText
@onready var health_3d_sprite: Sprite3D = %Health3DSprite
@onready var collision_shape: CollisionShape3D = %CollisionShape3D


func _ready() -> void:
	update_model()

	animation_player.animation_finished.connect(_on_animation_finished)

	match PlayerData.loaded_settings.show_enemy_health_mode:
		"Always":
			health_3d_sprite.show()
		"Never":
			health_3d_sprite.hide()


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		update_health_bar()
		if PlayerData.loaded_settings.show_enemy_health_mode == "On Agro":
			if is_agroed:
				health_3d_sprite.show()
			else:
				health_3d_sprite.hide()


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		match monster_data.monster_type:
			"flying":
				velocity = Vector3.ZERO

				if can_see_player():
					model.look_at(position + global_position.direction_to(player.global_position))
					velocity = global_position.direction_to(player.global_position) * monster_data.speed
					is_agroed = true
				else:
					is_agroed = false
			"walking":
				velocity = Vector3.ZERO

				nav_agent.target_position = player.global_position

				if not nav_agent.is_navigation_finished():
					var next_position = nav_agent.get_next_path_position()
					if can_see_player():
						if global_position != next_position:
							model.look_at(position + global_position.direction_to(next_position))
						velocity = global_position.direction_to(next_position) * monster_data.speed
						is_agroed = true
					else:
						is_agroed = false
				else:
					model.look_at(position + global_position.direction_to(player.global_position))
			_:
				push_error("Running a monster type that is not permited")
				assert(false, "Running a monster type that is not permited")

		move_and_slide()


func update_model() -> void:
	model.add_child(monster_data.model.instantiate())

	var model_aabb = Helper.get_aabb(model)
	health_3d_sprite.position.y = model_aabb.size.y + HEALTH_OFFSET
	current_health = monster_data.health

	var col_shape = collision_shape.shape as BoxShape3D

	col_shape.size = model_aabb.size

	collision_shape.position.y = model_aabb.size.y / 2

	animation_player = model.get_child(0).get_children(true).filter(func(node): return node is AnimationPlayer)[0]


func can_see_player() -> bool:
	if global_position.distance_to(player.global_position) < monster_data.agro_range:
		player_finder.target_position = global_position.direction_to(player.global_position) * monster_data.agro_range
		player_finder.force_raycast_update()
		if player_finder.get_collider() == player:
			return true

	return false


func update_health_bar() -> void:
	health_bar.max_value = monster_data.health
	health_bar.value = current_health

	health_text.text = "%d/%d" % [current_health, monster_data.health]


func take_damage(damage: int) -> void:
	current_health -= damage

	if current_health <= 0:
		PlayerData.inventory.append(monster_data.to_drop)
		EventBus.update_inventory.emit()
		animation_player.play("Death")
		update_health_bar()
		process_mode = Node.PROCESS_MODE_DISABLED


func _on_animation_finished(anim_name: StringName):
	if anim_name == "Death":
		queue_free()
