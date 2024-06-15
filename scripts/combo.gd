extends Node2D

@onready var arrows_NODE = $Arrows
@onready var timer = $Timer

signal speed_changed(new_speed)
@export var speed = 5

var rng = RandomNumberGenerator.new()
const arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
var arrows = []

func _ready():
	rng.randomize()
	timer.start()
	
func _input(event):
	if event.is_action_pressed("ui_up"):
		arrow_combo(0)
	elif event.is_action_pressed("ui_right"):
		arrow_combo(1)
	elif event.is_action_pressed("ui_down"):
		arrow_combo(2)
	elif event.is_action_pressed("ui_left"):
		arrow_combo(3)
		
func arrow_combo(direction):
	if len(arrows) > 0 and direction == arrows[0].rotation_degrees / 90:
		arrows[0].queue_free()
		arrows.pop_front()
		print("pop and change")
		speed += 1
		speed_changed.emit(speed)
	else:
		order66()
			
func spawn_random_child_arrow():
	"""returns random number between 0 and 3 (inclusive)
	"""
	var r = rng.randi_range(0, 3)
	var new_arrow = arrow_scene.instantiate()
	new_arrow.position.x = new_arrow.position.x + 800
	arrows_NODE.add_child(new_arrow)
	new_arrow.rotation_degrees = r * 90
	arrows.append(new_arrow)

func order66():
	for n in arrows_NODE.get_children():
		arrows_NODE.remove_child(n)
		n.queue_free()
		arrows.pop_front()
		
func _on_kill_zone_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	order66()

func _on_timer_timeout():
	spawn_random_child_arrow()
