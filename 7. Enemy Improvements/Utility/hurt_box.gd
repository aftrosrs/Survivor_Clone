extends Area2D


@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer
# Built in condition that allows a function to be called in another script

signal hurt(damage, angle, knockback)#signal adjusted to carry angle and knockback arguements
var hit_once_array = []#array used to hold attacks that have already hit

func _on_area_entered(area):
	if area.is_in_group("attack"):#HurtBox
		if not area.get("damage") == null:#Checks damage value
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set","disabled",true)#Disabled Hurtbox collision
					disableTimer.start()#start a 0.5 second timer
				1: #HitOnce
					if hit_once_array.has(area) == false:#see if attack isnt in our array
						hit_once_array.append(area)#if not within array, add to array
						if area.has_signal("remove_from_array"):#1 check if attack has the signal
							if not area.is_connected("remove_from_array",Callable(self,"remove_from_list")):#check if it's already connected
								area.connect("remove_from_array",Callable(self,"remove_from_list"))# connect the attacks signal with hurtbox's func remove_from_list
					else:
						return#if attack is in array return and skip the hurt signal stuff
				2: #DisableHitBox
					if area.has_method("tempdisable"):#if an area has this method it will call the method
						area.tempdisable()
			var damage = area.damage#sets damage
			var angle = Vector2.ZERO#sets angle
			var knockback = 1#sets knockback
			if not area.get("angle") == null:#Checks if attack actually has a var angle
				angle = area.angle#sets angle to attack.angle
			if not area.get("knockback_amount") == null:#Check if attack has a var knockback_amount
				knockback = area.knockback_amount#set knockback to attack.knockback_amount
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)
			emit_signal("hurt",damage, angle, knockback)#emits the signal>#added kb and ang args in part 7
			
func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false)#reinable hurt box
