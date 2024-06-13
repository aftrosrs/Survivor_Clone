extends TextureRect

#we just check if upgrade has a value
var upgrade = null

func _ready():
	if upgrade != null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])# access the database and grab the icon for that upgrade
