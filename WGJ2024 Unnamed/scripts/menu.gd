extends CanvasLayer

func _on_play(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		get_parent().run_game(true)

func _on_quit(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("grab"):
		get_tree().quit()
