class_name EfcRangeDamage extends Effect

## Out of ten
@export var integer_chance: Equation
@export var amount: Equation

func _apply(attacker: Creature, victim: Creature) -> void:
	if randf() > victim.get_dodge_chance():
		if randf() <= integer_chance._get_value(attacker):
			var damage = amount._get_value(attacker)
			victim.hp -= damage
			Globals.logger.write(
				"{victim} was hit (-{damage} hp)".format({"damage": damage, "victim": victim.name})
			)
		else:
			Globals.logger.write(
				"{attacker} missed".format({"attacker": attacker.name})
			)
	else:
		Globals.logger.write(
			"{victim} dodged".format({"victim": victim.name})
		)
