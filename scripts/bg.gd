extends ParallaxBackground
@onready var bg = $"."

var scroll = 0
var standard_speed = 100
var current_speed = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll -= current_speed * delta
	bg.scroll_offset.x = scroll


func _on_combo_screen_speed_changed(new_speed):
	current_speed = standard_speed + new_speed
