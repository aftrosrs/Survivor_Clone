extends CharacterBody2D

@export var movement_speed = Globals.enemy_movement_speed
@export var enemy_hp = Globals.enemy_hp
@export var knockback_recovery = Globals.knockback_recovery
var knockback = Globals.knockback
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var sound_hit = $SoundHit
@onready var player = get_tree().get_first_node_in_group('player')
var death_anim = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object)

func _ready():
	anim.play("walk") # plays walk animation

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)#reduces the knockback every frame
	var direction = global_position.direction_to(player.global_position).normalized() #compares the direction from the enemy to the player and multiplies it by movement speed
	velocity = direction*movement_speed
	velocity += knockback#add the knockback force to the velocity
	move_and_slide()

	#flips sprite
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func death():
	emit_signal('remove_from_array',self)#emit signal for the HitOnce Hurtbox Array
	var enemy_death = death_anim.instantiate()#instance the explosion scene
	enemy_death.scale = sprite.scale#set scale of dead enemy sprite
	enemy_death.global_position = position#sets position to the dead enemy position
	get_parent().call_deferred('add_child',enemy_death)#spawn the explosion on the enemy spawner
	queue_free() # clears the enemy


func _on_hurt_box_hurt(damage, angle, knockback_amount):#the hurt function
	enemy_hp -= damage#Enemy takes damage
	knockback = angle * knockback_amount #knockback = Vector2(0.28,95)*100
	if enemy_hp<= 0:#if hp is less or = to 0
		death()#if it is call death()
	else:
		sound_hit.play()#if not play the hit sound
