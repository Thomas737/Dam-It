extends Node2D

const game = preload("res://scenes/game.tscn")
const pause_menu = preload("res://scenes/pause_menu.tscn")

var current_game
var current_pause_menu

func _ready():
	current_game = game.instantiate()
	current_pause_menu = pause_menu.instantiate()
	add_child(current_game)
	add_child(current_pause_menu)

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			current_pause_menu.show()
		else:
			current_pause_menu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
