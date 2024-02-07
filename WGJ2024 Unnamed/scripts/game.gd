extends Node2D

var rng = RandomNumberGenerator.new()
var time_to_lightning = 0
var time_to_thunder = 0

var thunder_types = []
var ending = false
const darkening_speed = 0.1/4

func _ready():
	randomize()
	reset_lightning()
	reset_thunder()
	thunder_types = [%thunder_1, %thunder_2, %thunder_3]

func _process(delta):
	if not ending:
		if $river/water.volume_db < -18:
			$river/water.volume_db += 7 * delta
		if $darkness_mask.modulate.a > 66/255:
			$darkness_mask.modulate.a -= darkening_speed * delta
	
	if ending:
		$darkness_mask.modulate.a += darkening_speed * delta
		if $darkness_mask.modulate.a > 1:
			ending = false
			var score = $dam.score()
			get_parent().final_score(score)
	
	time_to_lightning -= delta
	time_to_thunder -= delta
	
	if %lightning_mask.modulate.a > 0:
		%lightning_mask.modulate.a -= %lightning_mask.modulate.a * delta
	
	if time_to_lightning < 0:
		%lightning_mask.modulate.a = 1
		reset_lightning()
	
	if time_to_thunder < 0:
		thunder_types[rng.randi() % 2].playing = true
		reset_thunder()

func play_ending():
	$ending_music.playing = true

func end():
	ending = true
	
	$river.alarm()
	$dam.reinforce()
	reset_lightning(5)
	reset_thunder()
	$vignette/ColorRect.mouse_filter = 0
	for alarm_light in $alarm_lights.get_children():
		alarm_light.end()

func reset_lightning(set_as=0):
	time_to_lightning = rng.randf() * 30 + 40
	if set_as:
		time_to_lightning = set_as
	elif ending:
		time_to_lightning = rng.randf() * 5 + 10

func reset_thunder():
	time_to_thunder = time_to_lightning + rng.randf() * 2 + 1
