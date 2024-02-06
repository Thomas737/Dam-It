extends Node2D

var ones
var tens
var hundreds

var ended

func _ready():
	ones = $ones
	tens = $tens
	hundreds = $hundreds

func _process(_delta):
	if (ones.frame == 4 and tens.frame == 9 and hundreds.frame == 7):
		get_parent().play_ending()
	if (ones.frame == 9 and tens.frame == 9 and hundreds.frame == 9) and not ended:
		ones.speed_scale = 0
		tens.speed_scale = 0
		hundreds.speed_scale = 0
		ended = true
		get_parent().end()
