extends Node2D

@onready var arrows_NODE = $Arrows

var rng = RandomNumberGenerator.new()
const arrow_scene: PackedScene = preload("res://scenes/arrow.tscn")

func _ready():
	spawn_random_child_arrow()

func spawn_random_child_arrow():
	"""returns random number between 0 and 3 (inclusive)
	"""
	var r = rng.randi_range(0, 3)
	var new_arrow = arrow_scene.instantiate()
	arrows_NODE.add_child(new_arrow)
	new_arrow.rotation_degrees = 1 * 90
