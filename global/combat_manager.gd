extends Node

const DAGGER = preload("res://scenes/item/items/hand/dagger.tres")
const SHORTBOW = preload("res://scenes/item/items/hand/shortbow.tres")
const MAGIC_STICK = preload("res://scenes/item/items/hand/magic_stick.tres")

var in_combat = false
var player_team: Array[Creature]
var enemy_team: Array[Creature]
var encounter_power = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func new_game() -> void:
	Globals.tower.clear()
	Globals.logger.clear()
	Globals.logger.write("new game!")
	Globals.info_panel.unit_info.clear_inventory()
	
	encounter_power = 1
	player_team = []
	enemy_team = []
	
	for _i in 4:
		var player = Player.random(10)
		
		var item
		var max_stat = max(player.base_might, player.base_agility, player.base_wisdom)
		if max_stat == player.base_might:
			item = DAGGER
		elif max_stat == player.base_agility:
			item = SHORTBOW
		elif max_stat == player.base_wisdom:
			item = MAGIC_STICK
		
		if randf() >= 0.9:
			player.item_hand_r = item
		else:
			player.item_hand_l = item
		
		player_team.append(player)
		Globals.tower.add_player(Piece.from(player))
	
	gen_encounter(preload("res://scenes/creature/pools/floor_0.tres"), 2)

func gen_encounter(pool: ResourcePool, power: int) -> void:
	var points_left = power
	
	while points_left > 0 and enemy_team.size() < 4:
		var entry: CreatureEntry = pool.filter(
				func (entry):
					return (entry.value as CreatureEntry).encounter_point_cost <= points_left,
			).pick_random()
		
		if entry == null:
			break
		points_left -= entry.encounter_point_cost
		
		var creature = entry.make()
		enemy_team.append(creature)
		Globals.tower.add_enemy(Piece.from(creature))
