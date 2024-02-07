extends Node2D

const game = preload("res://scenes/game.tscn")
const tutorial = preload("res://scenes/tutorial_game.tscn")
const pause_menu = preload("res://scenes/pause_menu.tscn")

const storyp1 = preload("res://scenes/storyp1.tscn")
const storyp2 = preload("res://scenes/storyp2.tscn")
const storyp3 = preload("res://scenes/storyp3.tscn")

var current_game
var current_pause_menu
var final_story_part

var running = false
var ending = false
var tutorial_on = true

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

func storyp1_ended():
	current_game.queue_free()
	if tutorial_on:
		run_tutorial()
	else:
		run_story_p2()

func tutorial_ended():
	current_game.queue_free()
	run_story_p2()

func storyp2_ended():
	current_game.queue_free()
	run_main_game()

func run_game(with_tutorial):
	tutorial_on = with_tutorial
	$menu.hide()
	$vignette.hide()
	initialise_pause_menu()
	run_story_p1()

func run_main_game():
	running = true
	current_game = game.instantiate()
	add_child(current_game)

func run_story_p1():
	running = true
	current_game = storyp1.instantiate()
	current_game.tutorial_on = tutorial_on
	add_child(current_game)

func run_story_p2():
	running = true
	current_game = storyp2.instantiate()
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
	final_story_part = storyp3.instantiate()
	final_story_part.score = int(score)
	add_child(final_story_part)

func reset():
	ending = false
	if is_instance_valid(current_game):
		current_game.queue_free()
	current_pause_menu.queue_free()
	final_story_part.queue_free()
	$menu.show()
	AudioServer.set_bus_volume_db(master_audio, 0)
	
	end_timing = 1
	end_time_taken = 10
