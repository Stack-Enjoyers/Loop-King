extends Button

const GAME = preload("res://scenes/game.tscn")
const FINAL_CUTSCENE = preload("res://scenes/final_cutscene.tscn")

@onready var main_menu = $".."
@onready var logo = $"../Logo"
@onready var game_timer = $"../Game Timer"
@onready var bg = $"../Bg"
@onready var road = $"../Road"
@onready var character_body_2d = $"../CharacterBody2D"
@onready var start_button = $"."
@onready var music = $"../music"

var rng = RandomNumberGenerator.new()
var game
var final_cutscene
var game_running = true

var high_score

func _process(delta):
	if game_timer.time_left <= 0 and game_running:
		high_score = game.get_node("Combo Screen").top_speed
		music.get_node("spin_mode1").playing = false
		print("START CUTSCENE")
		game_running = false
		game.queue_free()
		final_cutscene = FINAL_CUTSCENE.instantiate()
		main_menu.add_child(final_cutscene)
	
func _on_pressed():
	game = GAME.instantiate()
	main_menu.add_child(game)
	main_menu_nuke()
	music.get_node("main_menu").playing = false
	music.get_node("spin_mode1").playing = true
	game_timer.wait_time = 40
	game_timer.start()
	print("timer started")

func main_menu_nuke():
	logo.queue_free()
	bg.queue_free()
	road.queue_free()
	character_body_2d.queue_free()
	start_button.visible = false
	start_button.disabled = true
