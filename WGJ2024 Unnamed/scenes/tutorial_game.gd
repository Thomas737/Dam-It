extends Node2D

var game_state = 0
var can_increase_game_state = false
var time_until_can = 5

@onready var space = $space_to_continue
@onready var state = $game_state

func _ready():
	$dam.water_on(false)
	$dam.spawn_more_struts = false
	$tutorial_river.water_on(false)
	space.hide()

func _process(delta):
	if time_until_can > 0:
		time_until_can -= delta
	else:
		space.show()
		can_increase_game_state = true

func _input(event):
	if can_increase_game_state:
		if event.is_action_pressed("continue"):
			if game_state == 0:
				set_game_state(5)
			elif game_state == 1:
				$darkness_mask.modulate.a = 67/255
				set_game_state(5)
				state.position = Vector2(-139, -75)
			elif game_state == 2:
				$dam.water_on(true)
				$dam.spawn_more_struts = true
				$tutorial_river.water_on(true)
				set_game_state(5)

func set_game_state(time):
	game_state += 1
	state.frame = game_state
	can_increase_game_state = false
	time_until_can = time
	space.hide()
