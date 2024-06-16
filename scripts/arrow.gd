extends Area2D

@onready var area_2d = $"."

var START_POSITION: Vector2
var TARGET_POSITION: Vector2

var t:float = 0.0

var parent
func _ready():
	START_POSITION = area_2d.position
	TARGET_POSITION = Vector2(area_2d.position.x - 1180, area_2d.position.y)
	parent = get_parent().get_parent()

func _process(delta):
	t += delta * 0.5
	if t < 1.0:
		area_2d.position = START_POSITION.lerp(TARGET_POSITION, t)
