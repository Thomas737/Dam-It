extends Node2D

var max_water_volume = -18
var min_water_volume = -80
var d_volume = -5

func water_on(value):
	$"SubViewport/riverParticles".emitting = value
	$"SubViewport/foam".emitting = value
	$SubViewport/foam2.emitting = value
	d_volume = (int(value) * 2 - 1) * 7

func _process(delta):
	$water.volume_db += d_volume * delta
	$water.volume_db = clamp($water.volume_db, min_water_volume, max_water_volume)
