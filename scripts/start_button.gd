extends Button

const GAME = preload("res://scenes/game.tscn")
@onready var main_menu = $".."
@onready var logo = $"../Logo"
@onready var bg = $"../Bg"
@onready var road = $"../Road"
@onready var character_body_2d = $"../CharacterBody2D"
@onready var start_button = $"."

func _button_pressed():
	print("built in")
	GAME.instantiate()

func _on_pressed():
	print("signal")
	var g = GAME.instantiate()
	main_menu.add_child(g)
	main_menu_nuke()

func main_menu_nuke():
	logo.queue_free()
	bg.queue_free()
	road.queue_free()
	character_body_2d.queue_free()
	start_button.queue_free()
