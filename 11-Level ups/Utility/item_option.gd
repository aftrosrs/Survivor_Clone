extends ColorRect

# Make a texture button -> add the sword texture to its textures
#A bit lower -> Button Group new ButtonGroup -> allow unpress
# Connect the two signals to detect if the mouse is over or not
#thats it!

@onready var button = $".."
var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group('player')
signal selected_upgrade(upgrade)

func _ready():
	assert(selected_upgrade.connect(player.upgrade_character) == OK)
	assert(button.pressed.connect(_input) == OK)

func _input(event):#makes left click work
	if event.is_action("LMB"):
		if mouse_over:
			emit_signal("selected_upgrade",item)

func _on_item_option_mouse_entered():
	mouse_over = true


func _on_item_option_mouse_exited():
	mouse_over = false
