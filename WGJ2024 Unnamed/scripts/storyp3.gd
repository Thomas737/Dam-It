extends Node2D

var timing = 25
var score = 0

func _ready():
	$ones.frame = 9 - floor(score % 10)
	$tens.frame = 9 - floor((score/10) % 10)
	$hundreds.frame = 9 - floor((score/100) % 10)
	$thousands.frame = 9 - floor((score/1000) % 10)

func _process(delta):
	if timing > 0:
		timing -= delta
	else:
		get_parent().reset()
	if timing > 20:
		$darkness_mask.modulate.a += delta/5
	elif timing > 18:
		$did_you.modulate.a += delta/2
	elif timing > 16:
		$catch_every_strut.modulate.a += delta/2
	elif timing > 14:
		$catch_every_strut.modulate.a -= delta/2
	elif timing > 12:
		$save_every_life.modulate.a += delta/2
	elif timing > 10:
		$save_every_life.modulate.a -= delta/2
		$did_you.modulate.a -= delta/2
	elif timing > 8:
		$actions_have_consequences.modulate.a += delta/2
	elif timing > 2 and timing < 4:
		$actions_have_consequences.modulate.a -= delta/2
		$ones.modulate.a -= delta/2
		$tens.modulate.a -= delta/2
		$hundreds.modulate.a -= delta/2
		$thousands.modulate.a -= delta/2
