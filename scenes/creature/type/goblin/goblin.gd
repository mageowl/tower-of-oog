class_name Goblin extends Humanoid

static func random_name() -> String:
	return Names.GOBLIN.pick_random()

static func random(points: int, instance: RefCounted = Goblin.new()) -> Goblin:
	super.random(points, instance)
	instance.eye_color = Color.BLACK
	instance.name = random_name()
	return instance

func get_might() -> int:
	return super.get_might() + 2

func get_might_hint() -> Array[String]:
	var hint = super.get_might_hint()
	hint.append("goblin +2")
	return hint

func get_sprite() -> PackedScene:
	return preload("res://scenes/creature/type/goblin/goblin_sprite.tscn")

func get_type_name() -> String:
	return "goblin"

func get_type_wiki_page() -> String:
	return "res://wiki/creatures/goblins.md"

func get_automated_action() -> Action:
	return get_actions().pick_random()
