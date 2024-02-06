extends Node2D

const game = preload("res://scenes/game.tscn")
const tutorial = preload("res://scenes/tutorial_game.tscn")
const pause_menu = preload("res://scenes/pause_menu.tscn")

var current_game
var current_pause_menu

var running = false
var ending = false

var end_timing = 1
var end_time_taken = 10
var master_audio

func _ready():
	master_audio = AudioServer.get_bus_index("Master")

func _process(delta):
	if ending:
		end_timing -= delta
	if end_timing < 0:
		end_time_taken -= delta * 0.05
		AudioServer.set_bus_volume_db(master_audio, (end_time_taken-10)*80)

func _input(event):
	if event.is_action_pressed("pause") and running:
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			current_pause_menu.show()
		else:
			current_pause_menu.hide()

func run_game(with_tutorial):
	$menu.hide()
	$vignette.hide()
	initialise_pause_menu()
	if with_tutorial:
		run_tutorial()
	else:
		run_main_game()

func run_main_game():
	running = true
	current_game = game.instantiate()
	add_child(current_game)

func run_tutorial():
	running = true
	current_game = tutorial.instantiate()
	add_child(current_game)

func initialise_pause_menu():
	current_pause_menu = pause_menu.instantiate()
	add_child(current_pause_menu)

func final_score(score):
	ending = true
	print(score)
