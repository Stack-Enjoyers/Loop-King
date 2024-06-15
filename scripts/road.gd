extends Node2D

const ROCK_SCENE = preload("res://scenes/rock.tscn")

@onready var rocks = $Rocks
@onready var tilemap = $TileMap
@onready var timer = $Timer

var rng = RandomNumberGenerator.new()

var speed = 5

signal hit()

func _ready():
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for n in rocks.get_children():
		n.speed =  speed
		
	tilemap.position = Vector2(tilemap.position.x - speed, 0)
	if tilemap.position.x < -200:
		tilemap.position.x = -100
		
func spawn_obstacle():
	var r = rng.randi_range(0, 2)
	var new_rock = ROCK_SCENE.instantiate()
	rocks.add_child(new_rock)
	#print("i added a new ", new_rock.name)
	if r == 0:
		new_rock.position.y -= 73.75
	elif r == 1:
		pass
	elif r == 2:
		new_rock.position.y += 73.75
		

func _on_combo_screen_speed_changed(new_speed):
	speed = new_speed

func _on_timer_timeout():
	spawn_obstacle()
	
func got_hit():
	hit.emit()
