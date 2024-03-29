extends Node2D

const joint = preload("res://scenes/joint.tscn")
var connected_joints = []

var physical_length = 22
var selected = false
var rotation_speed = 3

var target_snap = null
var self_snap = null
var broken = false

var is_strut = true

func _ready():
	truss(true)

func _process(delta):
	if Input.is_action_just_pressed("de_snap"):
		disconnect_area()
	
	if broken:
		connected_joints = []
		broken = false
		truss(true)
	
	if selected:
		if is_instance_valid(target_snap):
			position = target_snap.position - self_snap.rotated(rotation)
		else:
			position = get_global_mouse_position()
	
	if selected:
		rotation += delta * rotation_speed * (int(Input.is_action_pressed("rotate_clockwise")) - int(Input.is_action_pressed("rotate_anticlockwise")))

func _on_interaction(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("grab"):
		selected = !selected
		$selected.visible = !$selected.visible
		
		if not selected:
			deselect()
		else:
			get_parent().new_selection(self)
			for connected_joint in connected_joints:
				if is_instance_valid(connected_joint) and connected_joint:
					connected_joint.connected_struts.erase(self)
			connected_joints = []
			$remove.play()
			$sprite.play("grow", -5, true)

func deselect():
	if truss(false):
		$combine.play()
	selected = false
	$selected.visible = false
	$sprite.play("grow", 5, false)

func queue_separation():
	broken = true
	$remove.play()

func truss(broken):
	var lower_links = $snappingAreaLower.get_overlapping_areas()
	var upper_links = $snappingAreaUpper.get_overlapping_areas()
	
	var new_joint_lower
	var new_joint_upper
	
	if not lower_links or broken:
		new_joint_lower = construct_joint(-1)
	else:
		new_joint_lower = lower_links[0].get_parent()
	
	if not upper_links or broken:
		new_joint_upper = construct_joint(1)
	else:
		new_joint_upper = upper_links[0].get_parent()
	
	connected_joints.append(new_joint_lower)
	connected_joints.append(new_joint_upper)
	
	new_joint_lower.connected_struts[self] = new_joint_upper
	new_joint_upper.connected_struts[self] = new_joint_lower
	
	if upper_links:
		var throwaway = new_joint_upper.connected_to()
	if lower_links:
		var throwaway = new_joint_lower.connected_to()
	
	return lower_links or upper_links

func construct_joint(direction):
	var new_joint = joint.instantiate()
	get_parent().add_child.call_deferred(new_joint)
	new_joint.position = position + direction * physical_length/2 * Vector2.UP.rotated(rotation)
	
	return new_joint

func get_other_joint(joint):
	return connected_joints[(connected_joints.find(joint)+1) % 2]

func reinforce():
	if selected:
		deselect()
	
	$sprite.play("reinforce")

# When being held by player, snap to near joints
func _on_snappingAreaUpper_enter(area: Area2D):
	if not target_snap:
		target_snap = area.get_parent()
		self_snap = Vector2(0, -physical_length/2)

func _on_snappingAreaLower_enter(area: Area2D):
	if not target_snap:
		target_snap = area.get_parent()
		self_snap = Vector2(0, physical_length/2)

func disconnect_area():
	target_snap = null
	self_snap = Vector2(0, 1)

func delete():
	_deletion_area_entered(null)

func _deletion_area_entered(area):
	for connected_joint in connected_joints:
		if is_instance_valid(connected_joint) and connected_joint:
			connected_joint.connected_struts.erase(self)
	queue_free()
