extends CharacterBody2D

@export var movement_speed = 20.0 #allows the editor to edit the value
@export var hp = 10.0
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	anim.play("walk") # plays walk animation

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position).normalized() #compares the direction from the enemy to the player and multiplies it by movement speed
	velocity = direction*movement_speed
	move_and_slide()

	#flips sprite
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false
	queue_free() # clears the object


func _on_hurt_box_hurt(damage):#Enemy takes damage
	hp -= damage
	if hp <= 0:
		queue_free()
