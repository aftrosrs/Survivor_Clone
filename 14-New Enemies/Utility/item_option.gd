extends TextureButton

# Make a texture button -> add the sword texture to its textures
#A bit lower -> Button Group new ButtonGroup -> allow unpress
# Connect the two signals to detect if the mouse is over or not
#thats it!
@onready var label_name = %Label_Name
@onready var label_description = %Label_Description
@onready var label_level = %Label_Level
@onready var item_option = $"."




var mouse_over = false
var item = null# variable so we can pull from database
@onready var player = get_tree().get_first_node_in_group('player')
signal selected_upgrade(upgrade)

func _ready():
	assert(selected_upgrade.connect(player.upgrade_character) == OK)
	if item == null:
		item = 'food'
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]#add the parameter you want to add
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_option.texture_normal = load(UpgradeDb.UPGRADES[item]["icon"])
	_on_pressed()

func _on_pressed():
		if mouse_over:
			emit_signal("selected_upgrade",item)


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false
