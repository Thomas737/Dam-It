extends CanvasLayer

var helpUI = false

func _ready():
	%helpUI.hide()
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _input(event):
	if event.is_action_pressed("help"):
		helpUI = !helpUI
		if helpUI:
			$helpUI.show()
		else:
			%helpUI.hide()
	if event.is_action_pressed("quit"):
		get_tree().quit()
