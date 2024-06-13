extends Node

@onready var timer = $Timer

func _physics_process(_delta):
	if timer.is_stopped():
		if Engine.get_frames_per_second() < 55:
			disable_stuff(20)
		elif Engine.get_frames_per_second() < 70:
			disable_stuff(10)
		elif Engine.get_frames_per_second() < 80:
			disable_stuff(5)

func disable_stuff(args = 20):
	get_tree().call_group("enemy", "frame_save",args)
	timer.start()
