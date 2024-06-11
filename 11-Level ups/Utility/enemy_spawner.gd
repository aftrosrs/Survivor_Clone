extends Node2D

@export var spawns: Array[spawn_info] = []
@export var time = 0
@onready var player = get_tree().get_first_node_in_group('player')


func _on_timer_timeout():
	time += 1 # Increase time by 1
	var enemy_spawns = spawns
	for i in enemy_spawns:# Loop back to the next Spawn_Info object after  increase counter until all enemies spawned
		if time >= i.time_start and time <= i.time_end: # Is between Time Start & End
			if i.spawn_delay_counter < i.enemy_spawn_delay: # Check if there is a delay
				i.spawn_delay_counter += 1  #Increase counter
			else:
				i.spawn_delay_counter = 0 #Set counter to 0
				var new_enemy = i.enemy
				var counter = 0
				while  counter < i.enemy_num: # Spawn number of enemies
					var enemy_spawn = new_enemy.instantiate() # create instance of packed scene
					enemy_spawn.global_position = get_random_position() # set random global position
					add_child(enemy_spawn) # adds the enemy
					counter += 1 # increase counter until all enemies spawned

func get_random_position():
	var vpr = get_viewport_rect().size
	var bottom_right_corner = Vector2(vpr.x/2, vpr.y/2)
	var radius = Vector2.ZERO.distance_to(bottom_right_corner) * randf_range(1.1,1.4)
	var angle = randf_range(0, 2*PI)
	return Vector2(radius, 0).rotated(angle)

# this entire function can be done easier as done above, but spawns them in a circle around the player

#func get_random_position():
	#var vpr = get_viewport_rect().size * randf_range(1.1,1.4) #Size of view port 
	#
	 #corners
	#var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	#var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	#var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	#var bottom_right = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	#
	 #pick random value in the array
	#var pos_side = ["up","down","right","left"].pick_random()
	#var spawn_pos1 = Vector2.ZERO
	#var spawn_pos2 = Vector2.ZERO
	#
	#
	#pick a side
#
	#match pos_side:
		#'up':
			#spawn_pos1 = top_left
			#spawn_pos2 = top_right
		#"down":
			#spawn_pos1 = bottom_left
			#spawn_pos2 = bottom_right
		#"right":
			#spawn_pos1 = top_right
			#spawn_pos2 = bottom_right
		#"left":
			#spawn_pos1 = top_left
			#spawn_pos2 = top_right
	#
	 #Get the value between the points
	#var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	#var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	#
	#return Vector2(x_spawn,y_spawn)
	#
