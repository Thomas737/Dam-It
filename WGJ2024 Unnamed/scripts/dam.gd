extends Node2D

var static_joints = []

const static_layer_n = 5
var current_layer = 0

func _process(_delta):
	if not $creaking.playing and current_layer > 0:
		$creaking.playing = true

func _ready():
	for static_joint in range(static_layer_n):
		static_joints.append(get_node("layer%sLower" % static_joint))
		static_joints.append(get_node("layer%sUpper" % static_joint))
		
		if static_joint > 0:
			remove_child(get_node("layer%sUpper" % static_joint))
			remove_child(get_node("layer%sLower" % static_joint))

func static_connection(layer):
	if current_layer < layer:
		current_layer = max(current_layer, layer)
		
		if current_layer < static_layer_n:
			add_child(static_joints[current_layer * 2])
			add_child(static_joints[current_layer * 2 + 1])
