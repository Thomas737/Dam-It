extends RigidBody2D

@export var other_layer_joint: RigidBody2D

const break_point = 16
const water_power = -20
const k = 8
const rope_pull = 50

var connected_struts = {}
var rope_connections = []

var selected = false

func _ready():
	connected_to()
	$selected.visible = false

func connected_to():
	if connected_struts.values():
		var connected_joint_iteration = [self]
		var iterating_successfully = true
		
		while iterating_successfully:
			iterating_successfully = false
			for joint in connected_joint_iteration:
				if joint.connected_struts.values():
					for joint_iter in joint.connected_struts.values():
						if not (joint_iter in connected_joint_iteration):
							connected_joint_iteration.append(joint_iter)
							iterating_successfully = true
		
		for joint in connected_joint_iteration:
			if joint.freeze:
				if joint.other_layer_joint in connected_joint_iteration:
					get_parent().static_connection(int(str(joint.name)[5]) + 1)

func _process(delta):
	if not len(connected_struts) and not freeze:
		call_deferred("queue_free")
	
	constant_force = Vector2.ZERO
	for strut in connected_struts:
		var joint = connected_struts[strut]
		if is_instance_valid(joint) and is_instance_valid(strut):
			var direction_inwards = position.direction_to(joint.position)
			var distance_to_joint = position.distance_to(joint.position)
			var extension = distance_to_joint - strut.physical_length
			
			var spring_force = direction_inwards * pow(abs(extension), 1.5) * k * sign(extension)
			var water_force = Vector2(water_power * ((position.x-192)/600 + 2) - linear_velocity.x, 0)
			add_constant_central_force(spring_force + water_force)
			
			if (abs(extension) > break_point):
				$break.playing = true
				strut.connected_joints = []
				strut.queue_separation()
				connected_struts.erase(strut)
			
			strut.position = direction_inwards * distance_to_joint/2 + position
			strut.rotation = direction_inwards.angle() + PI/2
	
	for connector in rope_connections:
		if is_instance_valid(connector):
			var to_self = (connector.position - position).normalized()
			var pull_force = rope_pull * to_self
			add_constant_central_force(pull_force)
	
	queue_redraw()

func _draw():
	for connector in rope_connections:
		var dir = (connector.position - position).rotated(-rotation)
		draw_line(Vector2.ZERO + dir.normalized() * 2.5, dir - dir.normalized() * 2.5, Color(0, 0, 0), 1)

func _on_clicked(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		if freeze:
			selected = !selected
			$selected.visible = !$selected.visible
			get_parent().new_selection(self)
		else:
			var connector = get_parent().get_selected()
			if connector is RigidBody2D:
				if connector.freeze:
					if connector in rope_connections:
						add_rope(connector)
					elif get_parent().rope_available():
						add_rope(connector)

func add_rope(connector):
	if connector in rope_connections:
		rope_connections.erase(connector)
	else:
		rope_connections.append(connector)

func deselect():
	selected = false
	$selected.visible = false

func _on_downstream_entered(area):
	queue_free()
