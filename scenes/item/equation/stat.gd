class_name EqStat extends Equation

@export var stat: Creature.BaseStat

func _get_value(creature: Creature) -> int:
	return creature.get_stat(stat)

func _to_string() -> String:
	match stat:
		Creature.BaseStat.MIGHT: return "might"
		Creature.BaseStat.AGILITY: return "agility"
		Creature.BaseStat.WISDOM: return "wisdom"
		_: return "[unknown statistic]"
