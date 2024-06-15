extends Node2D

const ROCK_SCENE = preload("res://scenes/rock.tscn")
const BANANA_SCENE = preload("res://scenes/banana.tscn")
const CONE_SCENE = preload("res://scenes/cone.tscn")

@onready var rocks = $Rocks
@onready var tilemap = $TileMap
@onready var timer = $Timer

var rng = RandomNumberGenerator.new()

var speed = 5

signal hit()

func _ready():
	timer.start()

func _process(delta):
	for n in rocks.get_children():
		n.speed =  speed
		
	tilemap.position = Vector2(tilemap.position.x - speed, 10)
	if tilemap.position.x < -200:
		tilemap.position.x = -100
		
	timer_fixer_upper()
		
func spawn_obstacle():
	var r = rng.randi_range(0, 2)
	var r2 = rng.randi_range(0, 2)
	var new_obstacle = null
	
	if r2 == 0:
		new_obstacle = BANANA_SCENE.instantiate()
	if r2 == 1:
		new_obstacle = CONE_SCENE.instantiate()
	if r2 == 2:
		new_obstacle = ROCK_SCENE.instantiate()
		
	rocks.add_child(new_obstacle)
	
	if r == 0:
		new_obstacle.position.y -= 58
	elif r == 1:
		new_obstacle.position.y += 58
		
func timer_fixer_upper():
	var cof = 7.5
	timer.wait_time = cof * (1.0 / speed)

func _on_combo_screen_speed_changed(new_speed):
	speed = new_speed

func _on_timer_timeout():
	spawn_obstacle()
	
func got_hit():
	hit.emit()


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	rocks.remove_child(area)
	area.queue_free()
