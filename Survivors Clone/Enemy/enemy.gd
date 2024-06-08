extends CharacterBody2D


@export var movement_speed = 20.0
@export var hp = 10.0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hitBox = $HitBox



func _ready():
	anim.play("walk")

func _physics_process(_delta):
	velocity = global_position.direction_to(player.global_position).normalized() * movement_speed
	move_and_slide()
	
	if velocity.x > 0.1:
		sprite.flip_h = true
	elif velocity.x < -0.1:
		sprite.flip_h = false

func _on_hurt_box_hurt(damage,):
	hp -= damage
	if hp <= 0:
		queue_free()
