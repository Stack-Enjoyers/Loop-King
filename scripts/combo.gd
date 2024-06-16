extends Node2D

@onready var arrows_NODE = $Arrows
@onready var timer = $Timer
@onready var loop_mode_safety = $loop_mode_safety
@onready var loop_mode_sound_1 = $loop_mode_sound1
@onready var spin_mode_1 = $music/spin_mode1

signal speed_changed(new_speed)
signal spin_control_animation()
signal got_hit(real)
signal wrong_input()
signal loop_mode()

@export var speed = 5
var loop_mode_min = speed * 1.4

var rng = RandomNumberGenerator.new()
const arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")
const spin_control_arrows_scene: PackedScene = preload("res://scenes/spin_control_arrows.tscn")

var spin_control_node = null
var switch_mode = true
var arrows = []
var spin_control_input = 0
var mode 
var top_speed = 5

const CAP = 15
const PAC = 2

func _ready():
	#check_mode()
	rng.randomize()
	
func _process(delta):
	print(top_speed)
	if mode != "hit":
		check_mode()
		timer_fixer_upper_loop_mode()
	
func check_mode():
	if speed >= loop_mode_min and mode != "loop_mode":
		loop_mode.emit()
		order66()
		mode = "loop_mode"
		loop_mode_safety.start()
		loop_mode_sound_1.playing = true
		get_parent().get_parent().get_node("music").get_node("spin_mode1").playing = false
		timer.start()
	elif switch_mode:
		loop_mode_safety.stop()
		spin_control_animation.emit()
		switch_mode = false
		order66()
		if speed == CAP:
			loop_mode_min = speed + 1
		else:
			loop_mode_min = speed * 1.4
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
			switch_mode = true
			loop_mode_sound_1.playing = false
			get_parent().get_parent().get_node("music").get_node("spin_mode1").playing = true
			decrease_speed()
			got_hit.emit(true)
			order66()
	elif mode == "spin_control":
		if len(arrows) > 0 and direction == arrows[0]:
			arrows.pop_front()
			spin_control_animation.emit()
			spin_control_node.frame +=4
		else:
			_on_road_hit()
		
			
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
	spin_control_input = 2
	spin_control_node.frame = (spin_control_input + 2) % 4
	spin_control_node.position = Vector2(spin_control_node.position.x - 750, spin_control_node.position.y + 120)
	arrows.append(spin_control_input)

func order66():
	for n in arrows_NODE.get_children():
		arrows_NODE.remove_child(n)
		n.queue_free()
		arrows.pop_front()
		
func increase_speed():
	var add = speed * 0.2
	if speed < CAP:
		speed = speed * 1.2
	else:
		speed = CAP
	top_speed += add
	speed_changed.emit(speed)
	
func decrease_speed():
	var remove = speed * 0.2
	if speed > PAC:
		speed = speed * 0.8
	else:
		speed = PAC
	top_speed -= remove
	speed_changed.emit(speed)
	
func timer_fixer_upper_loop_mode():
	var cof = 7
	var calc = cof / 1.0 / speed
	if mode == "loop_mode" and calc < 1:
		calc = 1
	timer.wait_time = calc
		
func _on_kill_zone_area_shape_entered(area_rid, area, area_shape_index, local_shape_index): #killzone for incoming arrows in loop_mode
	switch_mode = true
	loop_mode_sound_1.playing = false
	get_parent().get_parent().get_node("music").get_node("spin_mode1").playing = true
	decrease_speed()
	got_hit.emit(true)

func _on_timer_timeout():
	if mode == "spin_control":
		if len(arrows) > 0:
			reset_spin_control()
		else:
			spin_control_input += 1
			spin_control_node.frame = (spin_control_input + 2) % 4
			spin_control_input = spin_control_input % 4
			arrows.append(spin_control_input)
			spin_control_animation.emit()
			#add animations
			if spin_control_input == 2:
				if speed == CAP:
					speed += 1
				else:
					increase_speed()
			
	elif mode == "loop_mode":
		spawn_random_child_arrow()
	else:
		mode = "spin_control"
		switch_mode = true

func reset_spin_control():
	timer.stop()
	arrows = []
	spin_control_input = 2
	spin_control_node.frame = (spin_control_input + 2) % 4
	arrows.append(spin_control_input)
	wrong_input.emit()
	timer.start()
	timer_fixer_upper_loop_mode()

func _on_road_hit(): #hitbox detection for obstacles hitting car
	if mode != "hit":
		if mode == "spin_control":
			reset_spin_control()
			decrease_speed()
			got_hit.emit(true)


func _on_character_body_2d_hit_animation_playing():
	if mode != "hit":
		loop_mode_safety.stop()
		mode = "hit"
		order66()
		timer.wait_time = 1
		timer.start()


func _on_loop_mode_safety_timeout():
	got_hit.emit(false)
	loop_mode_sound_1.playing = false
	get_parent().get_parent().get_node("music").get_node("spin_mode1").playing = true
	loop_mode_min = speed * 1.4
