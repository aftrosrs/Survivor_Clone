extends Button


signal click_end()

func _on_mouse_entered():
	$Sound_Hover.play()
	
func _on_pressed():
	$Sound_Click.play()

func _on_sound_click_finished():
	emit_signal("click_end")
