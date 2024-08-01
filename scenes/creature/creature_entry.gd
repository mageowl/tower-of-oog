class_name CreatureEntry extends Resource

@export var encounter_point_cost = 1
@export var power = 10

func make() -> Creature:
	return Creature.random(power)
