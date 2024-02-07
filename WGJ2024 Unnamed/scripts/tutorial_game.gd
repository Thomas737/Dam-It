extends Node2D

var game_state = 0
var can_increase_game_state = false
var time_until_can = 5

var ending = 10

@onready var space = $space_to_continue
@onready var state = $game_state

func _ready():
	$dam.spawn_more_struts = false
	$tutorial_river.water_on(false)
	$truss_example.hide()
	space.hide()

func _process(delta):
	if game_state == 7:
		$darkness_mask.modulate.a += 0.7 * delta
		$tutorial_river.water_on(false)
		$dam.water_on(false)
		
		if ending > 0:
			ending -= delta
		if ending < 7 and ending > 3:
			$return_to_present.modulate.a += 0.7 * delta
		elif ending < 3:
			$return_to_present.modulate.a -= 2 * delta
		if ending <= 0:
			get_parent().tutorial_ended()
	
	if time_until_can > 0 and game_state < 7:
		time_until_can -= delta
	if time_until_can <= 0:
		space.show()
		can_increase_game_state = true

func _input(event):
	if can_increase_game_state:
		if event.is_action_pressed("continue"):
			if game_state == 0:
				set_game_state(3) #10
				
			elif game_state == 1:
				$darkness_mask.modulate.a = 67/255
				set_game_state(5) #5
				state.position = Vector2(-139, -75)
				
			elif game_state == 2:
				for i in range(21): #21
					$dam.manual_spawn()
				$dam.water_on(false)
				$truss_example.show()
				$truss_example.play()
				set_game_state(12) #12
				
			elif game_state == 3:
				set_game_state(50) #50
				
			elif game_state == 4:
				set_game_state(10) #10
				$tutorial_river.water_on(true)
				$dam.water_on(true)
			
			elif game_state == 5:
				set_game_state(10) #10
			
			elif game_state == 6:
				$truss_example.hide()
				set_game_state(100) #100
	
	if event.is_action_pressed("reset_tutorial"):
		if game_state == 6:
			print("here")
			for child in $dam.get_children():
				if not child is RigidBody2D and not child is AudioStreamPlayer:
					child.delete()
			
			for i in range(20):
				$dam.manual_spawn()
			$dam.water_on(false)
			$tutorial_river.water_on(false)
			set_game_state(0, 3)

func set_game_state(time, value=0):
	game_state += 1
	if value:
		game_state = value
	state.frame = game_state
	can_increase_game_state = false
	time_until_can = time
	space.hide()
