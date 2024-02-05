extends Node2D

const strut = preload("res://scenes/strut.tscn")
const max_ropes = 3

var next_strut_time = 0
var rng = RandomNumberGenerator.new()

var static_joints = []

const static_layer_n = 5
var current_layer = 0

func _process(delta):
	if not $creaking.playing and current_layer > 0:
		$creaking.playing = true
	
	next_strut_time -= delta
	if next_strut_time < 0:
		var new_strut = strut.instantiate()
		new_strut.position = Vector2(220, randf_range(-50, 50))
		new_strut.rotation = randf() * 2*PI
		add_child(new_strut)
		next_strut_time = 10 + rng.randf_range(-5, 5)

func _ready():
	randomize()
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
