extends CanvasLayer

var tutorial = true

func _on_play(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		get_parent().run_game(tutorial)

func _on_quit(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		get_tree().quit()

func _on_tutorial(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		tutorial = !tutorial
		$tick.visible = tutorial
