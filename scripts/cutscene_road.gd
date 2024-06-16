extends Node2D

@onready var node_2d = $"."
@onready var road = $Road

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	road.position = Vector2(road.position.x - 15, road.position.y)
	if road.position.x < -200:
		road.position.x = -100
