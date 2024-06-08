extends CharacterBody2D 


@export var movement_speed = 20.0 #allows the editor to edit the value
@export var hp = 10.0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hitBox = $HitBox



func _ready():
	anim.play("walk") # plays walk animation

func _physics_process(_delta):
	velocity = global_position.direction_to(player.global_position).normalized() * movement_speed #compares the direction from the enemy to the player and multiplies it by movement speed
	move_and_slide()
	
	#flips sprite
	if velocity.x > 0.1:
		sprite.flip_h = true
	elif velocity.x < -0.1:
		sprite.flip_h = false

func _on_hurt_box_hurt(damage):#Enemy takes damage
	hp -= damage
	if hp <= 0:
		queue_free() # clears the object
