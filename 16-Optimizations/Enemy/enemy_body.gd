class_name EnemyBody extends CharacterBody2D

@export var enemy_damage: int = 1
@export var movement_speed: float = 20.0
@export var enemy_hp: float = 10.0
@export var experience: int = 1
@export var knockback_recovery: float = 3.5
var knockback: Vector2 = Vector2.ZERO


@onready var hurt_box: Area2D = $EnemyBase/HurtBox
@onready var hit_box: Area2D = $EnemyBase/HitBox
@onready var sprite: Sprite2D = $EnemyBase/Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sound_hit: AudioStreamPlayer2D = $EnemyBase/SoundHit
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hideTimer: Timer = $EnemyBase/HideTimer


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')
@onready var loot_base: = get_tree().get_first_node_in_group('loot')
var death_anim: PackedScene = preload("res://Enemy/explosion.tscn")
var EXP_GEM: PackedScene = preload("res://Objects/exp_gem.tscn")

signal remove_from_array(object)

#Performance
var screen_size

func _ready() -> void:
	add_to_group("enemy")
	anim.play("walk") # plays walk animations
	hit_box.damage = enemy_damage
	screen_size = get_viewport_rect().size
	hurt_box.connect("hurt",Callable(self,"_on_hurt_box_hurt"))
	hideTimer.connect('timeout',Callable(self,"_on_hide_timer_timerout"))


func _physics_process(_delta) -> void:
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

func death() -> void:
	emit_signal('remove_from_array',self)#emit signal for the HitOnce Hurtbox Array
	var enemy_death = death_anim.instantiate()#instance the explosion scene
	enemy_death.scale = sprite.scale#set scale of dead enemy sprite
	enemy_death.global_position = position#sets position to the dead enemy position
	get_parent().call_deferred('add_child',enemy_death)#spawn the explosion on the enemy spawner
	#creates the gem
	var new_gem = EXP_GEM.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred('add_child',new_gem)
	queue_free() # clears the enemy


func _on_hurt_box_hurt(damage, angle, knockback_amount) -> void:#the hurt function
	enemy_hp -= damage#Enemy takes damage
	knockback = angle * knockback_amount #knockback = Vector2(0.28,95)*100
	if enemy_hp<= 0:#if hp is less or = to 0
		death()#if it is call death()
	else:
		sound_hit.play()#if not play the hit sound

func frame_save(amount = 20) -> void:
		var rand_disable = randi() % 100
		if rand_disable < amount:
			collision.call_deferred("set","disabled",true)
			anim.stop()

func _on_hide_timer_timeout() -> void:
	var location_dif = global_position - player.global_position
	if abs(location_dif.x) < (screen_size.x/2) * 1.4 || abs(location_dif.y) > (screen_size.y/2) * 1.4:
		visible = false
	else:
		visible = true
