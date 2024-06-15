extends Area2D

@onready var rock = $"."
var speed = 5


func _process(delta):
	rock.position.x = rock.position.x - speed

func _on_body_entered(body):
	rock.get_parent().get_parent().got_hit()
