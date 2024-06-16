extends CharacterBody2D

@onready var collision_shape2d = $CollisionShape2D
@onready var character_body2d = $"."
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_sound = $hit_sound

signal hit_animation_playing()

var t = 0.1
var lane_switch_distance = null
var spin_frame = 0
var direction = 0
var previous_location = Vector2()
var target_y = 0
var target_location = Vector2()
var timetolerp = 0.1
			
func _ready():
	lane_switch_distance = collision_shape2d.shape.get_rect().size[1]
	target_location = character_body2d.position
	animated_sprite_2d.play()

func _process(delta):
	if direction != 0 and t == 0.0:
		previous_location = character_body2d.position
		target_y = previous_location.y + (direction * 2 * 29.0)
		target_location = Vector2(previous_location.x, target_y)
		direction = 0
	else:
		t += delta * 2
		if t >= 0.1:
			t = 0.1
		character_body2d.position = previous_location.lerp(target_location, t / timetolerp)
	
func _input(event):
	if t == 0.1 and event.is_action_pressed("car_up") and character_body2d.position.y > 504:
		t = 0.0
		direction = -1
	elif t == 0.1 and event.is_action_pressed("car_down") and character_body2d.position.y < 620:
		t = 0.0
		direction = 1


func _on_combo_screen_spin_control_animation():
	if animated_sprite_2d.animation != "spin":
		animated_sprite_2d.animation = "spin"
		animated_sprite_2d.stop()
		spin_frame = 0
		animated_sprite_2d.frame = spin_frame
	else:
		spin_frame = (spin_frame + 1) % 8
		animated_sprite_2d.frame = spin_frame
		


func _on_combo_screen_wrong_input():
	if animated_sprite_2d.animation != "drive":
		animated_sprite_2d.animation = "drive"
		animated_sprite_2d.play()


func _on_combo_screen_got_hit():
	hit_sound.playing = true
	animated_sprite_2d.animation = "hit"
	animated_sprite_2d.play()
	hit_animation_playing.emit()


func _on_combo_screen_loop_mode():
	if animated_sprite_2d.animation != "spin_fast":
		animated_sprite_2d.animation = "spin_fast"
		animated_sprite_2d.play()
