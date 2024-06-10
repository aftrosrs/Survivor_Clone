extends Sprite2D



func _ready():
	$AnimationPlayer.play("explode")#play the animation when it spawns


func _on_animation_player_animation_finished(_anim_name):
	queue_free()#delete itself when animation finishes
