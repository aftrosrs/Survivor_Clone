extends Control

var level = ("res://World/world.tscn")

func _on_button_play_click_end():
	var _level = get_tree().change_scene_to_file(level)


func _on_button_quit_click_end():
	get_tree().quit()
