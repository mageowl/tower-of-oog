class_name Player extends Humanoid

static func random_name() -> String:
	return (Names.HUMAN + Names.SPECIAL).pick_random()

static func random(points: int, instance: Creature = Player.new()) -> Player:
	super.random(points, instance)
	
	instance.name = Player.random_name()
	instance.modifiable = true
	
	return instance

func get_type_name() -> String:
	return "human"

func get_type_wiki_page() -> String:
	return "res://wiki/creatures/humans.md"
