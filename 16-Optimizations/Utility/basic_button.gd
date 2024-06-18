extends Button


signal click_end()

func _on_mouse_entered() -> void:
	$Sound_Hover.play()
	
func _on_pressed() -> void:
	$Sound_Click.play()

func _on_sound_click_finished() -> void:
	emit_signal("click_end")
