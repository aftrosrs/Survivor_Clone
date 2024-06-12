extends Area2D

var level = Globals.level # 1 
var hp = Globals.cant_die #9999
var speed = Globals.speed # Set to 200.0 in the match:
var damage = Globals.attack_damage #Set to 10 in the match:
var knockback_amount = Globals.knockback_amount # 100
var attack_size = Globals.attack_size # 1.0
var paths = 1
var attack_speed = 4.0

var target = Globals.target
var target_array = []

var angle = Globals.angle
var reset_pos = Vector2.ZERO

var spr_jav_reg = preload("res://Textures/Items/Weapons/javelin_3_new.png")
var spr_jav_atk = preload("res://Textures/Items/Weapons/javelin_3_new_attack.png")

@onready var player = get_tree().get_first_node_in_group('player')
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attackTimer = get_node("%AttackTimer")
@onready var changeDirectionTimer = get_node("%ChangeDirection")
@onready var resetPosTimer = get_node ("%ResetPosTimer")
@onready var Sound_Attack = $Sound_Attack

signal remove_from_array(object)

func _ready():
	update_javelin()#updates the level of the javelin
	_on_reset_pos_timer_timeout()# trigger the timeout function of ResetPosTimer

func update_javelin():#update the javelin
	level = player.javelin_level#the level is pulled from the match: in player.gd upgrade_character()
	match level:
		1:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 1
			attack_size = 1.0 * (1 + player.spell_size)#sets size of the jav
			attack_speed = 5.0 * (1-player.spell_cooldown)#attack speed of jav
		2:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 2# level 2 gives more paths
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		3:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		4:
			hp = 9999
			speed = 200.0
			damage = 15
			knockback_amount = 120
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
			
	
	scale = Vector2(1.0,1.0) * attack_size
	attackTimer.wait_time = attack_speed
	level = player.javelin_level
	match level:
		1:
			hp = 9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 1
			attack_size = 1.0
			attack_speed = 5.0

	scale = Vector2(1.0,1.0) * attack_size
	attackTimer.wait_time = attack_speed

func _physics_process(delta):#vvv if we have a target
	if target_array.size() > 0:#needs a targt to move towards enemy checks every 4 seconds with AttackTimer
		position += angle*speed*delta#position direction based on angle
	else:#if we dont have a target
		var player_angle = global_position.direction_to(reset_pos)#get angle between javelin and reset_pos
		var distance_diff = global_position - player.global_position#get distance between javelin and player
		var return_speed = 20#regular return speed
		if abs(distance_diff.x) > 500 or abs(distance_diff.y) > 500:#if distance is over 500 increase return speed
			return_speed = 100#fast return speed
		position += player_angle*return_speed*delta#change the position with the above angle #return speed used to speed up
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)
		#^^^^ Get teh angle between the javelin and the player and turn it into radians.
		#Add 135 degrees turned into radians to fix the -45 degree sprite tilt


func add_paths():
	Sound_Attack.play()#Play attack sound
	emit_signal("remove_from_array",self)#remove from HitOnce Hurtbox
	target_array.clear()#clear the target_array for fres targets
	var counter = 0
	while counter < paths:# get a target for each value in paths
		var new_path = player.get_random_target()#target gotten from player.gd
		target_array.append(new_path)#add to the array of targets
		counter += 1#close the loop increasing counter
	enable_attack(true)
	target = target_array[0]#also set the target to the first value in array
	process_path()

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set","disabled",false)#activate collision if argument is true
		sprite.texture = spr_jav_atk#sprite with blue outline
	else:
		collision.call_deferred("set","disabled",true)#disable collision if argument is true
		sprite.texture = spr_jav_reg#normal sprite

func process_path():
	angle = global_position.direction_to(target)#Sets the angle varialbe
	changeDirectionTimer.start()#Starts the change direction timer
	var tween = create_tween()
	var new_rotation_degrees = angle.angle() + deg_to_rad(135)#set rotation from vector2 to radians
	tween.tween_property(self,"rotation",new_rotation_degrees,0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()#^^^ tween the javelin's rotation towards the target
func _on_attack_timer_timeout():
	add_paths()#calls add_paths()

func _on_change_direction_timeout():
	if target_array.size() > 0:#check if target_array has any value
		target_array.remove_at(0)#removes 1st target from array
		if target_array.size() > 0:#checks if it still has a value
			target = target_array[0]#if still has a value set target to new first value in target_array
			process_path()#set the new angle and rotate the javelin to new target
			Sound_Attack.play()#play attack sound
			emit_signal("remove_from_array",self)#let javelin hit hintonce hurtboxes again
		else:
			changeDirectionTimer.stop()#stop change timer since no more targets
			attackTimer.start()#start attack timer to get new targets
			enable_attack(false)#if has no targets, disable the attack
	else:
		changeDirectionTimer.stop()#stop change timer since no more targets
		attackTimer.start()#start attack timer to get new targets
		enable_attack(false)#if has no targets, disable the attack


func _on_reset_pos_timer_timeout():
	var choose_direction = randi() % 4# choose a number from 0 to 3
	reset_pos = player.global_position# sets reset_pos to players global_position
	match choose_direction:#change reset_pos by 50 pixels when javelin is spawned and every 3 seconds afterwards
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
