extends Button

const GAME = preload("res://scenes/game.tscn")
@onready var main_menu = $".."
@onready var logo = $"../Logo"
@onready var bg = $"../Bg"
@onready var road = $"../Road"
@onready var character_body_2d = $"../CharacterBody2D"
@onready var start_button = $"."
@onready var music = $"../music"

var rng = RandomNumberGenerator.new()

func _on_pressed():
	print("signal")
	var g = GAME.instantiate()
	main_menu.add_child(g)
	main_menu_nuke()
	music.get_node("main_menu").playing = false
	music.get_node("spin_mode1").playing = true

func main_menu_nuke():
	logo.queue_free()
	bg.queue_free()
	road.queue_free()
	character_body_2d.queue_free()
	start_button.queue_free()
