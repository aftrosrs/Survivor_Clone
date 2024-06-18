extends Area2D

var level: int = Globals.level
var hp: float = Globals.attack_hp
var speed: float = Globals.speed
var damage: float = Globals.attack_damage
var knockback_amount: float = Globals.knockback_amount
var attack_size: float = Globals.attack_size
var target: Vector2 = Globals.target
var angle: Vector2 = Globals.angle

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')
signal remove_from_array(object)

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 100
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 100
			damage = 8
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
	# Create tween to scale up
	var tween = create_tween()
	#Set up> Node you want to alter > Set Property you want to change > Set value > Time to complete> Transition Type>EaseType
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta) -> void:
	position += angle*speed*delta
	#moves the ice spear

func enemy_hit(charge = 1) -> void:
	hp -= charge#removes hp from spear
	if hp <= 0:
		emit_signal('remove_from_array',self)
		queue_free()#if hp is less or = 0, remove the spear


func _on_timer_timeout() -> void:
	emit_signal('remove_from_array',self)
	queue_free()
#deletes after 10 seconds
