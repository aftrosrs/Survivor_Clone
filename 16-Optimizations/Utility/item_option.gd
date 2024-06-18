extends TextureButton

# Make a texture button -> add the sword texture to its textures
#A bit lower -> Button Group new ButtonGroup -> allow unpress
# Connect the two signals to detect if the mouse is over or not
#thats it!
@onready var label_name: Label = %Label_Name
@onready var label_description: Label = %Label_Description
@onready var label_level: Label = %Label_Level
@onready var item_option: TextureButton = $"."




var mouse_over: bool = false
var item = null# variable so we can pull from database
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('player')
signal selected_upgrade(upgrade)

func _ready() -> void:
	assert(selected_upgrade.connect(player.upgrade_character) == OK)
	if item == null:
		item = 'food'
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]#add the parameter you want to add
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_option.texture_normal = load(UpgradeDb.UPGRADES[item]["icon"])
	_on_pressed()

func _on_pressed() -> void:
		if mouse_over:
			selected_upgrade.emit(item)


func _on_mouse_entered() -> void:
	mouse_over = true


func _on_mouse_exited() -> void:
	mouse_over = false
