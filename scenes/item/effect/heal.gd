class_name EfcHeal extends Effect

@export var amount: Equation

func _apply(attacker: Creature, victim: Creature) -> void:
	var amount_val = amount._get_value(attacker)
	victim.hp += amount_val
	Globals.logger.write("%s was healed (%d hp)" % [victim.name, amount_val])
