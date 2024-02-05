extends CanvasLayer

var helpUI = false

func _ready():
	%helpUI.hide()
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_help_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		helpUI = !helpUI
		if helpUI:
			$helpUI.show()
		else:
			%helpUI.hide()

func _on_quit_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		get_tree().quit()
