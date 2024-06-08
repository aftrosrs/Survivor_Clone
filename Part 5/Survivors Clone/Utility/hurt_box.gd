extends Area2D

@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer
# Built in condition that allows a function to be called in another script
#
signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("attack"):#HurtBox
		if not area.get("damage") == null:#Checks damage value
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set","disabled",true)#Disabled Hurtbox collision
					disableTimer.start()#start a 0.5 second timer
				1: #HitOnce
					pass
				2: #DisableHitBox
					if area.has_method("tempdisable"):#if an area has this method it will call the method
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt",damage)#emits the signal

func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false)#reinable hurt box
