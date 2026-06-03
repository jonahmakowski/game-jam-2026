@tool
class_name MonsterScene2D
extends PathFollow2D

@export var monster: Monster:
	set(val):
		monster = val
		current_health = monster.health

var current_health: float

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var collision_shape: CollisionShape2D = %CollisionShape


func _ready() -> void:
	setup()


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		var premove_progress = progress_ratio

		progress += monster.speed_2d * delta * Globals.player_data.enemy_speed_mult

		if premove_progress > progress_ratio:
			Globals.player_data.city_health -= int(monster.damage * Globals.player_data.enemy_damage_mult)
			queue_free()
			EventBus.update_hud.emit()


func take_damage(damage: float):
	current_health -= damage
	if current_health <= 0:
		queue_free()


func setup() -> void:
	sprite.sprite_frames = monster.sprite
	sprite.play("walk")
	collision_shape.shape.size = monster.sprite_size
