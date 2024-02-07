extends Node2D

var newspaper_t = 0

var newspaper1_onscreen = false
var newspaper2_onscreen = false

var fade_out = 3

func _process(delta):
	newspaper_t += delta
	$newspaper2.position.y = 200 * exp(-newspaper_t)
	$newspaper1.position.y = 200 * exp(3-newspaper_t)
	
	if not newspaper2_onscreen and newspaper_t > 0.5:
		newspaper2_onscreen = true
		$paper1.play()
	if not newspaper1_onscreen and newspaper_t > 2.8:
		newspaper1_onscreen = true
		$paper2.play()
	if newspaper_t > 8.5:
		$newspaper1.hide()
		$newspaper2.hide()
		$"10m".visible = true
	if newspaper_t > 12:
		$"10m".visible = false
		$"can".visible = true
	if newspaper_t > 15:
		fade_out -= delta
	if fade_out < -3:
		get_parent().storyp2_ended()
	
	$can.modulate.a = fade_out / 3
