class_name HumanoidEntry extends CreatureEntry

@export_group("Items")
@export var pool_body: ResourcePool
@export var pool_hand_dominant: ResourcePool
@export var pool_hand_non_dominant: ResourcePool
@export var pool_head: ResourcePool

func add_items(creature: Humanoid) -> Humanoid:
	var left_handed = randf() >= 0.9
	
	if pool_body != null:
		creature.item_body = pool_body.pick_random()
	if pool_hand_dominant != null:
		if left_handed:
			creature.item_hand_l = pool_hand_dominant.pick_random()
		else:
			creature.item_hand_r = pool_hand_dominant.pick_random()
	if pool_hand_non_dominant != null:
		if left_handed:
			creature.item_hand_r = pool_hand_non_dominant.pick_random()
		else:
			creature.item_hand_l = pool_hand_non_dominant.pick_random()
	if pool_head != null:
		creature.item_head = pool_head.pick_random()
	
	return creature
