extends Area2D

@onready var area_2d = $"."

const START_POSITION: Vector2 = Vector2(800, -100)
const TARGET_POSITION: Vector2 = Vector2(0, -100)
var t = 0.0

func _process(delta):
	t += delta * 0.4
	area_2d.position = START_POSITION.lerp(TARGET_POSITION, t)
