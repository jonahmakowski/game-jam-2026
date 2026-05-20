extends Sprite2D

@export var weapon: Weapon

var target: MonsterScene2D
var origin: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	look_at(target.global_position)

	var angle := origin.direction_to(target.global_position)
	var distance = origin.distance_to(target.global_position)
	global_position = (angle * (distance / 2)) + origin

	texture.width = distance

	set_instance_shader_parameter("color", weapon.laser_color)
	set_instance_shader_parameter("width", weapon.laser_width)
	set_instance_shader_parameter("progress", 0)

	var tween = create_tween()

	tween.tween_method(func(v): set_instance_shader_parameter("progress", v), 0.0, 1.0, weapon.laser_speed)
	tween.tween_callback(func(): target.take_damage(weapon.damage))
	tween.tween_callback(func(): queue_free())
	tween.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
