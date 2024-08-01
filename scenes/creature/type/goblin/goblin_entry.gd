class_name GoblinEntry extends HumanoidEntry

func make() -> Goblin:
	return super.add_items(Goblin.random(power))
