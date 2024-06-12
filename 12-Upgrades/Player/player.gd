extends CharacterBody2D

var hp = Globals.hp
var max_hp = Globals.max_hp
var movement_speed = Globals.movement_speed
var last_movement = Vector2.UP

var experience = 0
var experience_lvl = 1
var collected_experience = 0

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

#Gui
@onready var ExpBar = get_node("%ExperienceBar")
@onready var LabelLevel = get_node("%LabelLevel")
@onready var LevelPanel = get_node("%LevelPanel")
@onready var UpgradeOptions = get_node("%UpgradeOptions")
@onready var ItemOption = preload("res://Utility/item_option.tscn")
@onready var SoundLvl_Up = get_node("%SoundLvlUp")

# Attacks
var IceSpear = preload("res://Player/Attack/ice_spear.tscn")
var Tornado = preload("res://Player/Attack/Tornado.tscn")
var Javelin = preload("res://Player/Attack/javelin.tscn")

#Attack Nodes
@onready var IceSpear_Timer = get_node("%IceSpearTimer")
@onready var IceSpear_AttackTimer = get_node("%IceSpearAttackTimer")
@onready var Tornado_Timer = get_node("%TornadoTimer")
@onready var Tornado_AttackTimer = get_node("%TornadoAttackTimer")
@onready var JavelinBase = get_node('%JavelinBase')

#Upgrades
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0
# Ice Spear
var IceSpear_Ammo = 0
var IceSpear_BaseAmmo = 0
var IceSpear_AttackSpeed = 1.5
var IceSpear_Level = 0 

#Tornado
var Tornado_Ammo = 0
var Tornado_BaseAmmo = 0
var Tornado_AttackSpeed = 3
var Tornado_Level = 0

#Javelin
var Javelin_Ammo = 0
var javelin_level = 0

#Enemy Related
var enemy_close = []

func _ready():
	upgrade_character("icespear1")# gives you icespear lvl 1
	attack()#Calls attack() function at the very start
	set_expbar(experience, calculate_experienceCap())

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
		IceSpear_Timer.wait_time = IceSpear_AttackSpeed * (1 - spell_cooldown)#set reload timer to attack speed
		if IceSpear_Timer.is_stopped():#Is timer stopped
			IceSpear_Timer.start()#Start the timer

	if Tornado_Level > 0: #Check's the Tornado_Level is greater than 0
		Tornado_Timer.wait_time = Tornado_AttackSpeed * (1 - spell_cooldown) #set reload timer to attack speed
		if Tornado_Timer.is_stopped():#Is timer stopped
			Tornado_Timer.start()#Start the timer

	if javelin_level > 0:#checks the javelin level
		spawn_javelin()#spawns javelin

func _on_hurt_box_hurt(damage, _angle, _knockback):#player takes damge
	hp -= clamp(damage-armor, 1.0, 999.0)
	#healthBar.max_value = maxhp
	#healthBar.value = hp
	if hp <= 0:
		pass#death()

func _on_ice_spear_timer_timeout():
	IceSpear_Ammo += IceSpear_BaseAmmo + additional_attacks #add IceSpear_BaseAmmo to Ammo count reload
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
	Tornado_Ammo += Tornado_BaseAmmo + additional_attacks #add Tornado_BaseAmmo to Ammo count reload
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

func spawn_javelin():
	var get_Javelin_total = JavelinBase.get_child_count()
	var calc_spawns = (Javelin_Ammo + additional_attacks) - get_Javelin_total
	while calc_spawns > 0:# sets new attack speed
		var Javelin_spawn = Javelin.instantiate()
		Javelin_spawn.global_position = global_position
		JavelinBase.add_child(Javelin_spawn)
		calc_spawns -= 1
	#Upgrade Javelin
	var get_Javelins = JavelinBase.get_children()
	for i in get_Javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()#update all jabelins


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


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var exp_gem = area.collect()
		calculate_experience(exp_gem)#when the gem gets collected you start calculations passed from the function below
		

func calculate_experience(gem_exp):
	var exp_required = calculate_experienceCap()#calculate the exp needed to level
	collected_experience += gem_exp#transfer gem_exp to our handler variable
	if experience + collected_experience >= exp_required: #Checks if we level up
		collected_experience -= exp_required-experience#only take exp that is needed to lvl
		experience_lvl += 1# lvl up
		#LabelLevel.text = str("Level:", experience_lvl)#updates the experience bar
		experience = 0
		level_up()# calls level_up()
	else:
		experience += collected_experience#add collected exp to pool and move on
		collected_experience = 0
	set_expbar(experience, exp_required)#updates exp bar
	
func upgrade_character(upgrade):# upon taking the upgrade, do this
	
	match upgrade:
		"icespear1":
			IceSpear_Level = 1
			IceSpear_BaseAmmo += 1
		"icespear2":
			IceSpear_Level = 2
			IceSpear_BaseAmmo += 1
		"icespear3":
			IceSpear_Level = 3
		"icespear4":
			IceSpear_Level = 4
			IceSpear_BaseAmmo += 2
		"tornado1":
			Tornado_Level = 1
			IceSpear_BaseAmmo += 1
		"tornado2":
			Tornado_Level = 2
			IceSpear_BaseAmmo += 1
		"tornado3":
			Tornado_Level = 3
			Tornado_AttackSpeed -= 0.5
		"tornado4":
			Tornado_Level = 4
			IceSpear_BaseAmmo += 1
		"javelin1":
			javelin_level = 1
			Javelin_Ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,max_hp)
			
	attack()#calls attack function
	var option_children = UpgradeOptions.get_children()# gets the children the UpgradeOptions var we set up top
	for i in option_children:
		i.queue_free() #remove the item children
	upgrade_options.clear()# clear our upgrade options ( reset for next time we level) so elif i in upgrade_options: works properly
	collected_upgrades.append(upgrade)#add upgrade to collected upgrades array so we can exclude it next time if i in collected_upgrades: 
	LevelPanel.visible = false#  ^^and use it for future pre req in if not n in collected_upgrades:
	LevelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)

func calculate_experienceCap():
	var exp_cap = experience_lvl
	if experience_lvl < 20:
		exp_cap = experience_lvl*5# Lvl 5: 5*5
	elif experience_lvl < 40:
		exp_cap = 95 * (experience_lvl-19)*8#lvl 25: 95 + 5*5
	else:
		exp_cap = 255 + (experience_lvl-39)*12#lvl 57: 255 + 17*12
	return exp_cap

func level_up():
	SoundLvl_Up.play() # play sound
	LabelLevel.text = str("Level:", experience_lvl) # change text of exp bar
	var tween = LevelPanel.create_tween()
	tween.tween_property(LevelPanel,'position',Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()#tween the panel to the center of the screen
	LevelPanel.visible = true
	var options = 0
	var optionsMax = 3
	while options < optionsMax:
		var option_choice = ItemOption.instantiate()
		option_choice.item = get_random_item()# assign the item we add from our database
		UpgradeOptions.add_child(option_choice)#becomes 1 of the 3 options
		options += 1
	get_tree().paused = true#pause game when we level


func set_expbar(set_value = 1, set_max_value = 100):#update gui
	ExpBar.value = set_value
	ExpBar.max_value = set_max_value

func get_random_item():
	var dblist = []# empty array to add eligable items into
	for i in UpgradeDb.UPGRADES: # go through the upgrades in database
		if i in collected_upgrades:# if its already collected
			pass# do nothing
		elif i in upgrade_options:#If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":# Dont pick with the type "item" i.e. food or w/e else has item type
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: # Check for Prerequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:# go through prereq
				if not n in collected_upgrades:
					to_add = false# if any are missing set to dont add
			if to_add:# if we have all the prereq
				dblist.append(i)#add the item to our []
		else:
			dblist.append(i)#                                   #if no pre requisites add to []
	if dblist.size() > 0:# make sure we have at least 1 item to pick
		var randomitem = dblist.pick_random()# picks a random item
		upgrade_options.append(randomitem)# make sure we dont add the same item for option 2 or 3
		return randomitem # gives the item
	else:# if no more upgrades to choose
		return null# return null, which we default to food
