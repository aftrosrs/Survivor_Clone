extends CharacterBody2D

var hp = Globals.hp
var movement_speed = Globals.movement_speed
var last_movement = Vector2.UP
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

# Attacks
var IceSpear = preload("res://Player/Attack/ice_spear.tscn")
var Tornado = preload("res://Player/Attack/Tornado.tscn")

#Attack Nodes
@onready var IceSpear_Timer = get_node("%IceSpearTimer");
@onready var IceSpear_AttackTimer = get_node("%IceSpearAttackTimer")
@onready var Tornado_Timer = get_node("%TornadoTimer")
@onready var Tornado_AttackTimer = get_node("%TornadoAttackTimer")
# Ice Spear
var IceSpear_Ammo = 0
var IceSpear_BaseAmmo = 1
var IceSpear_AttackSpeed = 1.5
var IceSpear_Level = 0 #Globals.attack_level
#Tornado
var Tornado_Ammo = 0
var Tornado_BaseAmmo = 5
var Tornado_AttackSpeed = 3
var Tornado_Level = Globals.attack_level

#Enemy Related
var enemy_close = []

func _ready():
	attack()#Calls attack() function at the very start

func _physics_process(_delta):# Every 1/60 seconds this runs
	movement()
#this movement method breaks the tornado so use the other method. below
#func movement():
	#velocity = Input.get_vector("Left", "Right", "Up", "Down") * movement_speed # Grabs input and assigns a velocity
	#checks the velocity against x position
	#if velocity.x > 0:
		#sprite.flip_h = true
	#elif velocity.x < 0:
		#sprite.flip_h = false
#sets the direction
	#if velocity != Vector2.ZERO:
		#last_movement = velocity
		#if walkTimer.is_stopped():
			#if sprite.frame >= sprite.hframes - 1:
				#sprite.frame = 0
			#else:
				#sprite.frame += 1
			#walkTimer.start()
	#move_and_slide()
func movement():
	var x_mov = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y_mov = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false

	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()
func attack():
	if IceSpear_Level > 0: #Check's the IceSpear_Level is greater than 0
		IceSpear_Timer.wait_time = IceSpear_AttackSpeed #set reload timer to attack speed
		if IceSpear_Timer.is_stopped():#Is timer stopped
			IceSpear_Timer.start()#Start the timer
	if Tornado_Level > 0: #Check's the Tornado_Level is greater than 0
		Tornado_Timer.wait_time = Tornado_AttackSpeed #set reload timer to attack speed
		if Tornado_Timer.is_stopped():#Is timer stopped
			Tornado_Timer.start()#Start the timer

func _on_hurt_box_hurt(damage, _angle, _knockback):#player takes damge
	hp -= damage
	print(hp)
	

func _on_ice_spear_timer_timeout():
	IceSpear_Ammo += IceSpear_BaseAmmo #add IceSpear_BaseAmmo to Ammo count reload
	IceSpear_AttackTimer.start()#Starts the attack timer


func _on_ice_spear_attack_timer_timeout():
	if IceSpear_Ammo > 0:#checks if there is any ammo left
		var IceSpear_Attack = IceSpear.instantiate()#create an instance of the IceSpear
		IceSpear_Attack.position = position #Sets the position of the IceSpear
		IceSpear_Attack.target = get_random_target() # Gets the enemies global_position
		IceSpear_Attack.level = IceSpear_Level # set the level
		add_child(IceSpear_Attack)#spawns spear
		IceSpear_Ammo -= 1#removes 1 ammo
		if IceSpear_Ammo > 0:#checks if we have ammo left
			IceSpear_AttackTimer.start()#if we do, start next attack
		else:
			IceSpear_AttackTimer.stop()#if not stop timer


func _on_tornado_timer_timeout():
	Tornado_Ammo += Tornado_BaseAmmo #add Tornado_BaseAmmo to Ammo count reload
	Tornado_AttackTimer.start()#Starts the attack timer


func _on_tornado_attack_timer_timeout():
	if Tornado_Ammo > 0:#checks if there is any ammo left
		var Tornado_Attack = Tornado.instantiate()#create an instance of the Tornado
		Tornado_Attack.position = position #Sets the position of the Tornado
		Tornado_Attack.last_movement = last_movement
		Tornado_Attack.level = Tornado_Level # set the level
		add_child(Tornado_Attack)#spawns Nado
		Tornado_Ammo -= 1#removes 1 ammo
		if Tornado_Ammo > 0:#checks if we have ammo left
			Tornado_AttackTimer.start()#if we do, start next attack
		else:
			Tornado_AttackTimer.stop()#if not stop timer


func get_random_target():
	if enemy_close.size() > 0:# if enemy_close has a value
		return enemy_close.pick_random().global_position# returns a random enemy from the list's global position
	else:#if there is no enemies
		return Vector2.UP#return a vector 2 so it can return something


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body): #If enemy_close does not have the enemy body
		enemy_close.append(body) #Add body to the enemy_close[] <-array


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):# If enemy leaves the area or gets queue_free()
		enemy_close.erase(body)#Remove body from enemy_close
