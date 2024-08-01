class_name Creature

signal died
signal hp_changed(value: int)
@warning_ignore("unused_signal")
signal max_hp_changed(value: int)
@warning_ignore("unused_signal")
signal ap_changed(value: int)
@warning_ignore("unused_signal")
signal max_ap_changed(value: int)
@warning_ignore("unused_signal")
signal dc_changed(value: float)
@warning_ignore("unused_signal")
signal stats_changed
@warning_ignore("unused_signal")
signal sprite_changed

enum Stat {
	MIGHT,
	AGILITY,
	WISDOM,
	MAX_HP,
	MAX_AP,
	DODGE_CHANCE,
}

enum BaseStat {
	MIGHT,
	AGILITY,
	WISDOM
}

var name: String
var modifiable: bool

var base_might: int = -2
var base_agility: int = -2
var base_wisdom: int = -2

var hp: int = -1 :
	set(v):
		hp = clamp(v, 0, get_max_hp())
		if hp == 0:
			hp_changed.emit(0)
			died.emit()
		else:
			hp_changed.emit(hp)
	get:
		if hp == -1:
			hp = get_max_hp()
		return hp

var ap: int = -1 :
	set(v):
		ap = clamp(v, 0, get_max_ap())
		ap_changed.emit(ap)
	get:
		if ap == -1:
			ap = get_max_ap()
		return ap

var conditions = {}

static func random(points: int, instance: Creature = Creature.new()) -> Object:
	var stats = [BaseStat.MIGHT, BaseStat.AGILITY, BaseStat.WISDOM]
	for _i in points:
		var stat = stats.pick_random()
		instance.set_base_stat(stat, instance.get_base_stat(stat) + 1)
		
		if instance.get_base_stat(stat) >= 3:
			stats.erase(stat)
	
	return instance

func get_might() -> int:
	return base_might

func get_might_hint() -> Array[String]:
	return ["base " + Utils.signed_int(base_might)]

func get_agility() -> int:
	return base_agility

func get_agility_hint() -> Array[String]:
	return ["base " + Utils.signed_int(base_agility)]

func get_wisdom() -> int:
	return base_wisdom

func get_wisdom_hint() -> Array[String]:
	return ["base " + Utils.signed_int(base_wisdom)]

func get_max_hp() -> int:
	return 7 + get_might()

@warning_ignore("integer_division")
func get_max_ap() -> int:
	return max(1 + (get_wisdom() / 3), 1)

## Chance out of 10
func get_dodge_chance_int() -> int:
	return max(1 + get_agility(), 0)

func get_dodge_chance() -> float:
	return float(get_dodge_chance_int()) / 10.0

func get_type_name() -> String:
	return ""

func get_type_wiki_page() -> String:
	return ""

func get_actions() -> Array[Action]:
	return []

func get_action_nodes() -> Array[Control]:
	return []

func get_automated_action() -> Action:
	assert(false)
	return null

func get_stat(stat: BaseStat) -> int:
	match stat:
		BaseStat.MIGHT: return get_might()
		BaseStat.AGILITY: return get_agility()
		BaseStat.WISDOM: return get_wisdom()
		_: return -1

func get_base_stat(stat: BaseStat) -> int:
	match stat:
		BaseStat.MIGHT: return base_might
		BaseStat.AGILITY: return base_agility
		BaseStat.WISDOM: return base_wisdom
		_: return -1

func set_base_stat(stat: BaseStat, value: int) -> void:
	match stat:
		BaseStat.MIGHT: base_might = value
		BaseStat.AGILITY: base_agility = value
		BaseStat.WISDOM: base_wisdom = value

func get_sprite() -> PackedScene:
	assert(false)
	return null
