extends Node2D

func _process(delta):
	if (%joint and %joint2):
		%joint.connected_struts.append("1")
		%joint2.connected_struts.append("12")
		print(%joint.position, %joint2.position)
