extends RigidBody2D

@export var other_layer_joint: RigidBody2D

const water_power = -20
const k = 8
const b = -0.5

const break_point = 10

var connected_struts = {}

func _ready():
	connected_to()

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
		if is_instance_valid(joint) and joint:
			var direction_inwards = position.direction_to(joint.position)
			var distance_to_joint = position.distance_to(joint.position)
			var extension = distance_to_joint - strut.physical_length
			
			var spring_force = direction_inwards * pow(abs(extension), 1.8) * k * sign(extension)
			var water_force = Vector2(water_power * ((position.x-192)/600 + 2) - linear_velocity.x, 0)
			add_constant_central_force(spring_force + water_force)
			
			if (abs(extension) > break_point):
				strut.connected_joints = []
				strut.queue_separation()
				connected_struts.erase(strut)
			elif (abs(extension) < 2):
				var relative_velocity = linear_velocity - joint.linear_velocity
				add_constant_central_force(relative_velocity * b)
			
			strut.position = direction_inwards * distance_to_joint/2 + position
			strut.rotation = direction_inwards.angle() + PI/2
