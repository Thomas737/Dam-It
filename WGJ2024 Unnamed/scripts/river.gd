extends Node2D

var alarm_activated = false
var alarm_time = 2

func alarm():
	alarm_activated = true

func _process(delta):
	if alarm_activated:
		alarm_time -= delta
		if alarm_time < delta:
			$alarm.play()
			alarm_activated = false
