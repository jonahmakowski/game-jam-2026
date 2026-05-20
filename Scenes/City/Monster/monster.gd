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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		progress += monster.speed_2d * delta


func take_damage(damage: float):
	current_health -= damage
	if current_health <= 0:
		queue_free()


func setup() -> void:
	sprite.sprite_frames = monster.sprite
	sprite.play("walk")
	collision_shape.shape.size = monster.sprite_size
