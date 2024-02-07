extends Node2D

const strut = preload("res://scenes/strut.tscn")
const max_ropes = 5

var spawn_more_struts = true
var next_strut_time = 0
var rng = RandomNumberGenerator.new()

var static_joints = []
var reinforcing = false
var reinforce_next_sound = 1
var sound_n = 3

var water_stopped = false
var in_tutorial = false

const static_layer_n = 5
var current_layer = 0

func _process(delta):
	if in_tutorial:
		for joint in get_children():
			if joint is RigidBody2D:
				if water_stopped:
					joint.water_on = 0
				else:
					joint.water_on = 0.5
	
	if not $creaking.playing and current_layer > 0:
		$creaking.playing = true
	
	reinforce_next_sound -= delta
	if reinforcing and reinforce_next_sound <= 0 and sound_n:
		reinforce_next_sound = rng.randf_range(3, 6)
		if (sound_n % 2 == 0):
			$hydraulic.playing = true
		else:
			$lock.playing = true
		sound_n -= 1
	
	if spawn_more_struts:
		next_strut_time -= delta
	if next_strut_time < 0 and not reinforcing:
		var new_strut = strut.instantiate()
		new_strut.position = Vector2(220, randf_range(-50, 50))
		new_strut.rotation = randf() * 2*PI
		add_child(new_strut)
		next_strut_time = 10 + rng.randf_range(-5, 5)

func _ready():
	randomize()
	if not get_parent().name == "tutorial_game":
		for static_joint in range(static_layer_n):
			static_joints.append(get_node("layer%sLower" % static_joint))
			static_joints.append(get_node("layer%sUpper" % static_joint))
			
			if static_joint > 0:
				remove_child(get_node("layer%sUpper" % static_joint))
				remove_child(get_node("layer%sLower" % static_joint))

func _input(event):
	if event.is_action_pressed("deselect"):
		new_selection(null)

func static_connection(layer):
	if not in_tutorial:
		if current_layer < layer:
			current_layer = max(current_layer, layer)
			
			if current_layer < static_layer_n:
				add_child(static_joints[current_layer * 2])
				add_child(static_joints[current_layer * 2 + 1])

func new_selection(newly_selected):
	for child in get_children():
		if not child is AudioStreamPlayer and not child == newly_selected:
			if child.selected: child.deselect()

func get_selected():
	for child in get_children():
		if not child is AudioStreamPlayer and child.selected:
			if child.selected: return child

func rope_available():
	var used_ropes = 0
	for child in get_children():
		if child is RigidBody2D:
			if not child.freeze: used_ropes += len(child.rope_connections)
	return not used_ropes == max_ropes

func reinforce():
	for strut_and_joint in get_children():
		if not strut_and_joint is AudioStreamPlayer:
			strut_and_joint.reinforce()
	reinforcing = true

func score():
	var total_strut_score = 0
	var longest_string = 0
	var layer_connections = 0
	
	for strut_or_joint in get_children():
		if not strut_or_joint is AudioStreamPlayer:
			if strut_or_joint.is_strut:
				var strut = strut_or_joint
				var strut_score = (floor(strut.position.x) + 192) * (sign(60-abs(strut.position.y))+1) / 2
				for connected_joint in strut.connected_joints:
					if is_instance_valid(connected_joint):
						if connected_joint.freeze:
							strut_score = 0
				total_strut_score += strut_score/384
			
			else:
				var joint = strut_or_joint
				if joint.freeze:
					var all_connections = joint.connected_to()
					longest_string = max(len(all_connections), longest_string)
					if joint.other_layer_joint in all_connections:
						layer_connections += 100/all_connections.find(joint.other_layer_joint)
	
	return total_strut_score + longest_string + layer_connections

func water_on(value: bool):
	in_tutorial = true
	water_stopped = not value

func manual_spawn():
	var new_strut = strut.instantiate()
	new_strut.position = Vector2(randf_range(50, 150), randf_range(-100, 100))
	new_strut.rotation = randf() * 2*PI
	add_child(new_strut)
	next_strut_time = 10 + rng.randf_range(-5, 5)
