extends ParallaxBackground
@onready var bg = $"."

var scroll = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll -= 100 * delta
	bg.scroll_offset.x = scroll
