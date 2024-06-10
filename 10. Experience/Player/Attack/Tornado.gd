extends Area2D

var level = Globals.level
var hp = Globals.cant_die
var speed = Globals.speed
var damage = Globals.attack_damage
var attack_size = Globals.attack_size
var knockback_amount = Globals.knockback_amount

var last_movement = Globals.last_movement
var angle = Globals.angle
var angle_less = Globals.angle_less
var angle_more = Globals.angle_more
signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	match level:
		1:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
	var move_to_less = Vector2.ZERO
	var move_to_more = Vector2.ZERO
	match last_movement:#     Get 2 random Vector 2s that are roughly 500 px away from the tornado
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1,-0.25), last_movement.y)*500
			move_to_more = global_position + Vector2(randf_range(0.25,1), last_movement.y)*500
		Vector2.RIGHT, Vector2.LEFT:
			move_to_less = global_position + Vector2(last_movement.x, randf_range(-1,-0.25))*500
			move_to_more = global_position + Vector2(last_movement.x, randf_range(0.25,1))*500
		Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1):
			move_to_less = global_position + Vector2(last_movement.x, last_movement.y * randf_range(0,0.75))*500
			move_to_more = global_position + Vector2(last_movement.x * randf_range(0,0.75), last_movement.y)*500
	#get the angles
	angle_less = global_position.direction_to(move_to_less)
	angle_more = global_position.direction_to(move_to_more)
	# Transitions from 0.1 scale to 1 and increase speed from 20% to 100%
	var initital_tween = create_tween().set_parallel(true)
	initital_tween.tween_property(self,"scale",Vector2(1,1)*attack_size,3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var final_speed = speed
	speed = speed/5.0
	initital_tween.tween_property(self,"speed",final_speed,6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initital_tween.play()
	var tween = create_tween()
	var set_angle = randi_range(0,1)#coinflip
	if set_angle == 1:
		angle = angle_less
		tween.set_loops()#allows for looping these instead of having on multiple lines
		tween.tween_property(self,"angle", angle_more,2)
		tween.tween_property(self,"angle", angle_less,2)
	else:
		angle = angle_more
		tween.set_loops()
		tween.tween_property(self,"angle", angle_less,2)
		tween.tween_property(self,"angle", angle_more,2)
	tween.play()

func _physics_process(delta):
	position += angle*speed*delta #actual movement code, everything above is just to calculate angles

func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()





#extends Area2D
#
#var level = Globals.level
#var hp = Globals.cant_die
#var speed = Globals.speed
#var damage = Globals.attack_damage
#var knockback_amount = Globals.knockback_amount
#var attack_size = Globals.attack_size
#var last_movement = Vector2.ZERO
#var target = Vector2.ZERO
#var angle = Vector2.ZERO
#var angle_less = Vector2.ZERO
#var angle_more = Vector2.ZERO
#@onready var player = get_tree().get_first_node_in_group('player')
#
#signal  remove_from_array(object)
#func _ready():
	#match level:
		#1:
			#hp = 9999
			#speed = 100
			#damage = 20
			#knockback_amount = 100
			#attack_size = 1
			#
	#var move_to_less = Vector2.ZERO
	#var move_to_more = Vector2.ZERO
	#match last_movement:
		#Vector2.UP, Vector2.DOWN:
			#move_to_less = global_position + Vector2(randf_range(-1,-0.25), last_movement.y)*500
			#move_to_more = global_position + Vector2(randf_range(0.25,1), last_movement.y)*500
		#Vector2.RIGHT, Vector2.LEFT:
			#move_to_less = global_position + Vector2(last_movement.x, randf_range(-1,-0.25))*500
			#move_to_more = global_position + Vector2(last_movement.x, randf_range(0.25,1))*500
		#Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1):
			#move_to_less = global_position + Vector2(last_movement.x, last_movement.y * randf_range(0,0.75))*500
			#move_to_more = global_position + Vector2(last_movement.x * randf_range(0,0.75), last_movement.y)*500
	#
	#angle_less = global_position.direction_to(move_to_less)
	#angle_more = global_position.direction_to(move_to_more)
	#
	#var initital_tween = create_tween().set_parallel(true)
	#initital_tween.tween_property(self,"scale",Vector2(1,1)*attack_size,3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#var final_speed = speed
	#speed = speed/5.0
	#initital_tween.tween_property(self,"speed",final_speed,6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#initital_tween.play()
	#
	#var tween = create_tween()
	#var set_angle = randi_range(0,1)
	#if set_angle == 1:
		#angle = angle_less
		#tween.set_loops()
		#tween.tween_property(self,"angle", angle_more,2)
		#tween.tween_property(self,"angle", angle_less,2)
	#else:
		#angle = angle_more
		#tween.set_loops()
		#tween.tween_property(self,"angle", angle_less,2)
		#tween.tween_property(self,"angle", angle_more,2)
	#tween.play()
#
#func _physics_process(delta):
	#position += angle*speed*delta
#
#func _on_timer_timeout():
	#emit_signal("remove_from_array",self)
	#queue_free()






#extends Area2D
#var time = Globals.time
#
#@export_range(1, 1000) var frequency := 8.0
#@export_range(1, 1000) var amplitude := 100.0
#@export_range(1, 1000) var initial_boost := 150
#@export_range(0, 360) var wave_offset := 0.0
#@export_range(1, 1000) var length_multiplier := 15.0
#@export var num_of_points := 1200
#@export var spawn_point := Vector2(50, 150)
#var level = Globals.level
#var hp = Globals.cant_die
#var speed = Globals.speed
#var damage = Globals.attack_damage
#var knockback_amount = Globals.knockback_amount
#var attack_size = Globals.attack_size
#var last_movement = Vector2.ZERO
#var target = Vector2.ZERO
#var angle = Vector2.ZERO
#var angle_less = Vector2.ZERO
#var angle_more = Vector2.ZERO
#@onready var player = get_tree().get_first_node_in_group('player')
#@onready var timer := $Timer as Timer
#
#signal remove_from_array(object)
#
#func _ready() -> void:
	#assert(timer.timeout.connect(_on_timer_timeout) == OK)
	#match level:
		#1:
			#hp = 9999
			#speed = 200.0
			#damage = 5
			#knockback_amount = 100
			#attack_size = 1.0
	#
	#
	#get_parent().rotation = last_movement.angle() # set the rotation of the parent to the player direction
	#rotation -= last_movement.angle() # reset the rotation of the sprite irrespective of the parent
	#pass
#
#
#func _physics_process(delta: float) -> void:
	#time += delta
	#var movement := sin(time * frequency + wave_offset) * ((amplitude * time) + initial_boost)
	#position.y += movement * delta
	#position.x += speed * delta
	#pass
#
#
#func _on_timer_timeout() -> void:
	#remove_from_array.emit(self)
	#queue_free()
	#pass
