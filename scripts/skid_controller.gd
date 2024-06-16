extends Node2D

@onready var character_body_2d = $CharacterBody2D

const SKID = preload("res://scenes/skid.tscn")

var skid_speed = 300.0

var skid

func _input(event):
	if event.is_action_pressed("ui_up"):
		skid = SKID.instantiate()
		character_body_2d.add_child(skid)
	
	print(skid)
	if skid != null:
		skid.velocity.x -= skid_speed
		skid.move_and_slide()
