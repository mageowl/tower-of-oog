class_name EqProduct extends Equation

@export var a: Equation
@export var b: Equation

func _get_value(creature: Creature) -> int:
	return a._get_value(creature) * b._get_value(creature)

func _to_string() -> String:
	return str(a) + " * " + str(b)
