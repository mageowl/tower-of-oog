class_name EqConstant extends Equation

@export var value: int

func _get_value(_creature: Creature) -> int:
	return value

func _to_string() -> String:
	return str(value)
