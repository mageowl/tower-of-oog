class_name EfcMeleeDamage extends Effect

@export var min_damage: Equation
@export var max_damage: Equation

func _apply(attacker: Creature, victim: Creature) -> void:
	if randf() > victim.get_dodge_chance():
		var min_val = max(min_damage._get_value(attacker), 0)
		var damage = randi_range(min_val, max(max_damage._get_value(attacker), min_val))
		victim.hp -= damage
		Globals.logger.write(
			"{victim} was hit (-{damage} hp)".format({"damage": damage, "victim": victim.name})
		)
	else:
		Globals.logger.write(
			"{victim} dodged".format({"victim": victim.name})
		)
