extends Node2D

var rng = RandomNumberGenerator.new()
var time_to_lightning = 0
var time_to_thunder = 0

var thunder_types = []

func _ready():
	randomize()
	reset_lightning()
	reset_thunder()
	thunder_types = [%thunder_1, %thunder_2, %thunder_3]

func _process(delta):
	print(time_to_lightning)
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

func reset_lightning():
	time_to_lightning = rng.randf() * 30 + 40

func reset_thunder():
	time_to_thunder = time_to_lightning + rng.randf() * 2 + 1
