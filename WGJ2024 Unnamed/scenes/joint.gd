extends RigidBody2D

const water_power = -20
const k = 10

var connected_struts = {}

func _ready():
	pass

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
			
			var spring_force = direction_inwards * extension * k
			var water_force = Vector2(water_power * ((position.x-192)/600 + 2) - linear_velocity.x, 0)
			add_constant_central_force(spring_force + water_force)
			
			strut.position = direction_inwards * distance_to_joint/2 + position
			strut.rotation = direction_inwards.angle() + PI/2
