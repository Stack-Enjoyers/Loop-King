extends Line2D

@onready var skid = $"."
@onready var rigid_body_2d = $".."

var t:float = 0.0
var start:Vector2
var target:Vector2
var direction = 0

func _process(delta):
	update()
	var pos = get_parent().global_position
	oscillate(delta)
	
func update():
	start = rigid_body_2d.position
	target = Vector2(rigid_body_2d.position.x, rigid_body_2d.position.y + 200)

func oscillate(delta):
	if direction == 0:
		t += delta * 1.6
	else:
		t -= delta * 1.6
	add_point(start.lerp(target, t))
	if t > 1.0:
		direction = 1
	elif t < 0.0:
		direction = 0
