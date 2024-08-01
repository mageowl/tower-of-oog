class_name Modifier extends Resource

enum Type {
	SET,
	ADD,
	MULTIPLY
}

@export var type: Type
@export var target: Creature.Stat
@export var equation: Equation

static func sorter(a: Modifier, b: Modifier) -> bool:
	match [a.type, b.type]:
		[Type.SET, Type.ADD]: return true
		[Type.SET, Type.MULTIPLY]: return true
		[Type.MULTIPLY, Type.ADD]: return true
		_: return false

func apply(creature: Creature, base: int) -> int:
	match type:
		Type.SET: return equation._get_value(creature)
		Type.ADD: return base + equation._get_value(creature)
		Type.MULTIPLY: return base * equation._get_value(creature)
		_: return -1
