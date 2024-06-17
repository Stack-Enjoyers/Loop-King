extends RichTextLabel

@onready var animation_player = $"../AnimatableBody2D/AnimationPlayer"
@onready var rich_text_label = $"."

var high_score
# Called when the node enters the scene tree for the first time.
func _ready():
	high_score = get_parent().get_parent().get_parent().get_node("Start Button").high_score
	rich_text_label.add_text("High Score: " + str(int(high_score)))