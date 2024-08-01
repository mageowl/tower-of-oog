class_name CondBurn extends Condition

static func _on_turn(creature: Creature) -> void:
	creature.hp -= 1
	Globals.logger.write("%s burned (-1 hp)" % creature.name)

static func _get_id() -> String:
	return "burn"

func _to_string() -> String:
	return "burning"
