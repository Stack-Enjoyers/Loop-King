extends CharacterBody2D

@onready var collision_shape2d = $CollisionShape2D
@onready var character_body2d = $"."

var t = 0.1
var lane_switch_distance = null

var direction = 0
var previous_location = Vector2()
var target_y = 0
var target_location = Vector2()
var timetolerp = 0.1
			
func _ready():
	lane_switch_distance = collision_shape2d.shape.get_rect().size[1]
	target_location = character_body2d.position

func _process(delta):
	if direction != 0 and t == 0.0:
		previous_location = character_body2d.position
		target_y = previous_location.y + (direction * lane_switch_distance * 2.85)
		target_location = Vector2(previous_location.x, target_y)
		direction = 0
	else:
		t += delta * 2
		if t >= 0.1:
			t = 0.1
		character_body2d.position = previous_location.lerp(target_location, t / timetolerp)
	
func _input(event):
	if t == 0.1 and event.is_action_pressed("car_up") and character_body2d.position.y > 392.25:
		t = 0.0
		direction = -1
	elif t == 0.1 and event.is_action_pressed("car_down") and character_body2d.position.y < 539.75:
		t = 0.0
		direction = 1
