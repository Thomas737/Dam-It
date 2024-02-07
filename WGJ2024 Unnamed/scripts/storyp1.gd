extends Node2D

var timing = 10
var awaiting_end = 20
var tutorial_on = true

var morse_on = false
var alarm_on = false
var thunder_on = false

var end_time_taken = 10

@onready var story_sound = AudioServer.get_bus_index("story_sound")

func _ready():
	AudioServer.set_bus_volume_db(story_sound, 0)

func _process(delta):
	if timing > 0:
		timing -= delta
	else:
		$darkness_mask.modulate.a = 1
		end_time_taken -= delta * 0.05
		AudioServer.set_bus_volume_db(story_sound, (end_time_taken-10)*140)
	if timing < 9 and not alarm_on:
		alarm_on = true
		$alarm.play()
	if timing < 8 and not morse_on:
		morse_on = true
		$storyp1_music.play()
		$morse.play()
	elif timing < 7 and not thunder_on:
		%lightning_mask.modulate.a = 1
		$radio.visible = true
		thunder_on = true
		$thunder.play()
	
	if %lightning_mask.modulate.a > 0:
		%lightning_mask.modulate.a -= %lightning_mask.modulate.a * delta
	
	if awaiting_end > 0:
		awaiting_end -= delta
		if tutorial_on:
			$"2_years_ago".modulate.a = 5-awaiting_end
	else:
		get_parent().storyp1_ended()
