class_name GoblinSprite extends HumanoidSprite

func get_arm() -> Texture:
	return preload("res://scenes/creature/type/goblin/arm.png")

func get_leg() -> Texture:
	return preload("res://scenes/creature/type/goblin/leg.png")

func get_head() -> Texture:
	return preload("res://scenes/creature/type/goblin/head.png")

func get_skin_darken() -> Color:
	return 0x063919ff
