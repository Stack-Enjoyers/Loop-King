extends CharacterBody2D

@onready var collision_shape2d = $CollisionShape2D
@onready var character_body2d = $"."


var t = 0.0
var speed = 200
var lane_switch_distance = null
var lerping = false
var direction = 0
var previous_location = 0
var target_location = 0
var timetolerp = 0.1
			
func _ready():
	lane_switch_distance = collision_shape2d.shape.get_rect().size[1]

func _physics_process(delta):
	if !lerping:
		if Input.is_action_pressed("car_up") and character_body2d.position.y > -73.75:
			direction = -1
			lerping = true
			t = 0.0
		elif Input.is_action_pressed("car_down") and character_body2d.position.y < 73.75:
			direction = 1
			lerping = true
			t = 0.0
	else:
		if t == 0.0:
			previous_location = character_body2d.position
			target_location = previous_location.y + (direction * lane_switch_distance * 2.5)
			target_location = Vector2(previous_location.x, target_location)

		t += delta *0.8
		if t>=0.1:
			t=0.1
			lerping = false
		print(t)
		character_body2d.position = previous_location.lerp(target_location, t / timetolerp)
	
	"""
func _input(event):
	if event.is_action_pressed("car_up") and character_body2d.position.y > -73.75:
		lane_switch(-1)
	elif event.is_action_pressed("car_down") and character_body2d.position.y < 73.75:
		lane_switch(1)

func lane_switch(direction):
	var previous_location = character_body2d.position
	var target_location = previous_location.y + (direction * lane_switch_distance * 2.5)
	character_body2d.position = Vector2(previous_location.x, target_location)
	#print(character_body2d.position)"""

func arrow_combo(direction):
	print(direction)
