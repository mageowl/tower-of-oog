class_name Humanoid extends Creature

signal items_changed

var item_head: Item
var item_body: Item
var item_hand_l: Item
var item_hand_r: Item

var skin_tone = 0
var face = 0
var eye_color = Color.BLACK
var hair_style = 0
var hair_color = Color.BLACK

static func random(points: int, instance: Creature = Humanoid.new()) -> Humanoid:
	super.random(points, instance)
	
	instance.skin_tone = randi_range(0, HumanoidSprite.ARMS.size() - 1)
	instance.face = randi_range(0, HumanoidSprite.FACES.size() - 1)
	instance.eye_color = HumanoidSprite.EYES.pick_random() if randf() >= 0.1 else HumanoidSprite.EYES_RARE.pick_random()
	instance.hair_style = randi_range(0, HumanoidSprite.HAIR_STYLES.size() - 1)
	instance.hair_color = HumanoidSprite.HAIR_COLORS.pick_random() if randf() >= 0.1 else HumanoidSprite.HAIR_COLORS_RARE.pick_random()
	
	return instance

func get_items() -> Array[Item]:
	return [item_head, item_body, item_hand_l, item_hand_r]

func get_modifiers() -> Array[Modifier]:
	var m: Array[Array] = []
	m.append_array(get_items().map(func (item: Item): return item.modifiers if item != null else []))
	var r: Array[Modifier] = []
	r.append_array(Utils.flatten(m))
	return r

func get_modified_value(base: int, target: Creature.Stat) -> int:
	var value = base
	var modifiers = get_modifiers() \
		.filter( \
			func (mod: Modifier): \
				return mod.target == target \
		)
	
	modifiers.sort_custom(Modifier.sorter)
	
	for modifier in modifiers:
		value = modifier.apply(self, base)
	
	return value

func get_modified_hint(base: Array[String], target: Creature.Stat) -> Array[String]:
	var modifiers: Array[Array] = []
	
	for item in get_items():
		if item == null: continue
		
		for modifier in item.modifiers:
			if modifier.target == target:
				modifiers.push_front([item, modifier])
	
	modifiers.sort_custom(func (a, b): return Modifier.sorter(a[1], b[1]))
	
	var hint = base
	for g in modifiers:
		var item: Item = g[0]
		var modifier: Modifier = g[1]
		var name = item.name.to_lower()
		
		match modifier.type:
			Modifier.Type.SET:
				hint = ["%s %d" % [name, modifier.equation._get_value(self)]]
			Modifier.Type.ADD:
				hint.push_back("%s %s" % [name, Utils.signed_int(modifier.equation._get_value(self))])
			Modifier.Type.MULTIPLY:
				hint.push_back("%s x%d" % [name, modifier.equation._get_value(self)])
	
	return hint

func get_might() -> int:
	return get_modified_value(super.get_might(), Stat.MIGHT)

func get_might_hint() -> Array[String]:
	return get_modified_hint(super.get_might_hint(), Stat.MIGHT)

func get_agility() -> int:
	return get_modified_value(super.get_agility(), Stat.AGILITY)

func get_agility_hint() -> Array[String]:
	return get_modified_hint(super.get_agility_hint(), Stat.AGILITY)
	
func get_wisdom() -> int:
	return get_modified_value(super.get_wisdom(), Stat.WISDOM)

func get_wisdom_hint() -> Array[String]:
	return get_modified_hint(super.get_wisdom_hint(), Stat.WISDOM)

func get_max_hp() -> int:
	return get_modified_value(super.get_max_hp(), Stat.MAX_HP)

func get_max_ap() -> int:
	return get_modified_value(super.get_max_ap(), Stat.MAX_AP)

func get_dodge_chance_int() -> int:
	return get_modified_value(super.get_dodge_chance_int(), Stat.DODGE_CHANCE)

func get_actions() -> Array[Action]:
	var actions: Array[Action] = []
	for item in get_items():
		if item:
			actions.append_array(item.actions)
	
	return super.get_actions() + actions

func get_action_nodes() -> Array[Control]:
	var actions: Array[Control] = []
	for item in get_items():
		if item and not item.actions.is_empty():
			actions.append(Utils.label(item.name.to_lower()))
			
			for action in item.actions:
				actions.append(action.row())
	
	return super.get_action_nodes() + actions

func get_sprite() -> PackedScene:
	return preload("res://scenes/creature/type/humanoid/humanoid_sprite.tscn")

# ITEM SLOT HELPERS

func snap_changes() -> Dictionary:
	return {
		"might": get_might(),
		"agility": get_agility(),
		"wisdom": get_wisdom(),
		"max_hp": get_max_hp(),
		"max_ap": get_max_ap(),
		"dci": get_dodge_chance_int()
	}

func emit_changes(changes: Dictionary) -> void:
	if changes["might"] != get_might() \
			or changes["agility"] != get_agility() \
			or changes["wisdom"] != get_wisdom():
		stats_changed.emit()
	if changes["max_hp"] != get_max_hp():
		max_hp_changed.emit(get_max_hp())
		hp = min(hp, get_max_hp())
		hp_changed.emit(hp)
	if changes["max_ap"] != get_max_ap():
		max_ap_changed.emit(get_max_ap())
		ap = min(ap, get_max_ap())
		ap_changed.emit(ap)
	if changes["dci"] != get_dodge_chance_int():
		dc_changed.emit(get_dodge_chance())

func set_item_head(item: Item):
	var changes = snap_changes()
	item_head = item
	items_changed.emit()
	sprite_changed.emit()
	emit_changes(changes)

func set_item_body(item: Item):
	var changes = snap_changes()
	item_body = item
	items_changed.emit()
	sprite_changed.emit()
	emit_changes(changes)

func set_item_hand_l(item: Item):
	var changes = snap_changes()
	item_hand_l = item
	items_changed.emit()
	sprite_changed.emit()
	emit_changes(changes)

func set_item_hand_r(item: Item):
	var changes = snap_changes()
	item_hand_r = item
	items_changed.emit()
	sprite_changed.emit()
	emit_changes(changes)
