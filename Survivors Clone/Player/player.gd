extends CharacterBody2D

var hp = Globals.hp
var movement_speed = Globals.movement_speed
@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _physics_process(_delta):
	movement()

func movement():
	velocity = Input.get_vector("Left", "Right", "Up", "Down").normalized() * Globals.movement_speed
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false

	if velocity != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)
