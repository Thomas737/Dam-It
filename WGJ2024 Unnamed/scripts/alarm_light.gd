extends Node2D

var rng = RandomNumberGenerator.new()

var rotation_speed = 0.3
var ending = false
var random_rotation_change = false

var fade_in = 0

func _process(delta):
	randomize()
	if random_rotation_change:
		rotation = rng.randf_range(0, 2*PI)
		random_rotation_change = false
	if ending:
		rotation += delta * rotation_speed
		if fade_in < 1:
			fade_in += delta / 5
	
	queue_redraw()

func _draw():
	if ending:
		var points_right = [Vector2.ZERO, Vector2(1200, 240), Vector2(1200, -240)]
		var points_left = [Vector2.ZERO, Vector2(-1200, 240), Vector2(-1200, -240)]
		draw_polygon(PackedVector2Array(points_right), PackedColorArray([Color(1, 0, 0, 0.1 * fade_in)]))
		draw_polygon(PackedVector2Array(points_left), PackedColorArray([Color(1, 0, 0, 0.1 * fade_in)]))

func end():
	ending = true
	random_rotation_change = true
