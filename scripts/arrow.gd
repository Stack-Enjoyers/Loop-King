extends Area2D

@onready var area_2d = $"."

const START_POSITION: Vector2 = Vector2(800, -100)
const TARGET_POSITION: Vector2 = Vector2(0, -100)

var parent
func _ready():
	parent = get_parent().get_parent()

func _process(delta):
	area_2d.position.x = area_2d.position.x - 10
