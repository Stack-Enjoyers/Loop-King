extends CharacterBody2D

@onready var collision_shape2d = $Area2D/CollisionShape2D
@onready var character_body2d = $"."

var speed = 200
var lane_switch_distance = null
func _process(delta):
	lane_switch_distance = collision_shape2d.shape.size[1]
	# lane switching controls
	var direction = Input.get_axis("car_up", "car_down")
	if direction:
		lane_switch(direction)

func lane_switch(direction):
	var previous_location = character_body2d.position
	var target_location = previous_location.y + (direction * lane_switch_distance)
	character_body2d.position = Vector2(previous_location.x, target_location)
