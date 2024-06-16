extends Node2D

@onready var arrows_NODE = $Arrows
@onready var timer = $Timer

signal speed_changed(new_speed)
@export var speed = 5
var loop_mode_min = speed * 1.2

var rng = RandomNumberGenerator.new()
const arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
const spin_control_arrows_scene: PackedScene = preload("res://scenes/spin_control_arrows.tscn")

var spin_control_node = null

var arrows = []
var spin_control_input = 0
var mode 

const CAP = 50
const PAC = 2

func _ready():
	check_mode()
	rng.randomize()
	
func _process(delta):
	check_mode()
	timer_fixer_upper_loop_mode()
	
func check_mode():
	if speed >= loop_mode_min and mode != "loop_mode":
		print("activate loop mode")
		order66()
		mode =  "loop_mode"
		timer.start()
	elif speed < (loop_mode_min) and mode != "spin_control":
		print("exit loop mode")
		order66()
		loop_mode_min = speed * 1.2
		mode = "spin_control"
		spawn_spin_control_arrows()
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
	if mode == "loop_mode":
		if len(arrows) > 0 and direction == arrows[0].rotation_degrees / 90:
			arrows[0].queue_free()
			arrows.pop_front()
			increase_speed()
		else:
			decrease_speed()
			order66()
	else:
		if len(arrows) > 0 and direction == arrows[0]:
			print("hit correct")
			arrows.pop_front()
			increase_speed()
			#animation
		else:
			print("hit wrong")
			reset_spin_control()
			#animation
			
func spawn_random_child_arrow():
	"""returns random number between 0 and 3 (inclusive)
	"""
	var r = rng.randi_range(0, 3)
	var new_arrow = arrow_scene.instantiate()
	#new_arrow.position.x = new_arrow.position.x + 800
	arrows_NODE.add_child(new_arrow)
	new_arrow.rotation_degrees = r * 90
	arrows.append(new_arrow)

func spawn_spin_control_arrows():
	var new_spin_control_arrows = spin_control_arrows_scene.instantiate()
	arrows_NODE.add_child(new_spin_control_arrows)
	spin_control_node = arrows_NODE.get_child(0)
	spin_control_input = 1
	spin_control_node.frame = (spin_control_input + 2) % 4
	spin_control_node.position = Vector2(spin_control_node.position.x - 750, spin_control_node.position.y + 120)
	arrows.append(spin_control_input)

func order66():
	for n in arrows_NODE.get_children():
		arrows_NODE.remove_child(n)
		n.queue_free()
		arrows.pop_front()
		
func increase_speed():
	if speed < CAP:
		speed += 0.5
	speed_changed.emit(speed)
	
func decrease_speed():
	if speed > PAC:
		speed -= 1
	speed_changed.emit(speed)
	
func timer_fixer_upper_loop_mode():
	var cof = 7
	timer.wait_time = cof / 1.0/speed
		
func _on_kill_zone_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	order66()

func _on_timer_timeout():
	if mode == "spin_control":
		spin_control_input += 1
		spin_control_node.frame = (spin_control_input + 2) % 4
		spin_control_input = spin_control_input % 4
		arrows.append(spin_control_input)
		#add animations
		if len(arrows) > 1:
			print("missed timing")
			reset_spin_control()
	elif mode == "loop_mode":
		spawn_random_child_arrow()

func reset_spin_control():
	timer.stop()
	arrows = []
	spin_control_input = 1
	spin_control_node.frame = (spin_control_input + 2) % 4
	arrows.append(spin_control_input)
	decrease_speed()
	timer.start()
	timer_fixer_upper_loop_mode()

func _on_road_hit():
	if mode == "spin_control":
		reset_spin_control()
	else:
		decrease_speed()
