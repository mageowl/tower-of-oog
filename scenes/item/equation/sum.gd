class_name EqSum extends Equation

@export var a: Equation
@export var b: Equation

func _get_value(creature: Creature) -> int:
	return a._get_value(creature) + b._get_value(creature)
