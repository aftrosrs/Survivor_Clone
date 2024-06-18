extends Area2D

@export var experience: int = 1
#Used a comment to learn that you click a file and hold left click, 
#then press ctrl while holding left click and drag into script
# only thing i changed is the const to var, which i dont think it doesnt need to be
var GEM_GREEN: CompressedTexture2D = preload("res://Textures/Items/Gems/Gem_green.png")
var GEM_BLUE: CompressedTexture2D = preload("res://Textures/Items/Gems/Gem_blue.png")
var GEM_RED: CompressedTexture2D = preload("res://Textures/Items/Gems/Gem_red.png")

var target: CharacterBody2D = null
var speed: int = -1 # causes it to move in opposite direction when collected

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sound: AudioStreamPlayer = $Sound_Collected

func _ready() -> void:
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = GEM_BLUE
	else:
		sprite.texture = GEM_RED
func get_next_location() -> void:
	pass
func _physics_process(delta) -> void:
	if target != null:#move_towards just changes a Vector2 closer to another vector 2, isnt a physics function
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta #increast speed to move towards the player as time goes on increasingly

func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience#removes gem


func _on_sound_collected_finished() -> void:
	queue_free()#when sound finishes, the gem gets deleted.
