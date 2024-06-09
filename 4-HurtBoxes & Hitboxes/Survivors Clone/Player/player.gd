extends CharacterBody2D

var hp = Globals.hp
var movement_speed = Globals.movement_speed
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _physics_process(_delta):# Every 1/60 seconds this runs
	movement()

func movement():
	velocity = Input.get_vector("Left", "Right", "Up", "Down").normalized() * Globals.movement_speed # Grabs input and assigns a velocity
	#checks the velocity against x position
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
#sets the direction
	if velocity != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	move_and_slide()

func _on_hurt_box_hurt(damage):#player takes damge
	hp -= damage
	print(hp)
