extends Node2D

@onready var tilemap = $TileMap

var speed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tilemap.position = Vector2(tilemap.position.x - speed, 0)
	if tilemap.position.x < -200:
		tilemap.position.x = -100

func _on_combo_screen_speed_changed(new_speed):
	print("speed changed from ", speed, " to ", new_speed)
	speed = new_speed
