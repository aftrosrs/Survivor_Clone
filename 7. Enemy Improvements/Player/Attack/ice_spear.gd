extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group('player')
signal remove_from_array(object)
func _ready():
	angle = global_position.direction_to(target)#sets the angle to point toward an enemy
	rotation = angle.angle() + deg_to_rad(135)#sets the rotation in radiance to 135degrees adjusting for the -45
	match level:#Checks level
		1:#Sets the values of level 1
			hp = 2
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
	# Create tween to scale up
	var tween = create_tween()
	#Set up> Node you want to alter > Set Property you want to change > Set value > Time to complete> Transition Type>EaseType
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle*speed*delta
	#moves the ice spear

func enemy_hit(charge = 1):
	hp -= charge#removes hp from spear
	if hp <= 0:
		emit_signal('remove_from_array',self)
		queue_free()#if hp is less or = 0, remove the spear


func _on_timer_timeout():
	emit_signal('remove_from_array',self)
	queue_free()
#deletes after 10 seconds
