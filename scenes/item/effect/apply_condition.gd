class_name EfcApplyCondition extends Effect

@export var duration: Equation
@export var condition: Condition

func _apply(attacker: Creature, victim: Creature) -> void:
	victim.conditions[condition._get_id()] = { "duration": duration._get_value(attacker), "condition": condition }
