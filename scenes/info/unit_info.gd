class_name UnitInfo extends ScrollContainer

signal selection_changed

var selected: Creature

func _input(event: InputEvent) -> void:
	if event.is_action("select_next") and event.is_pressed():
		var current_index = CombatManager.player_team.find(selected)
		var index = (current_index + 1) % CombatManager.player_team.size()
		while CombatManager.player_team[current_index].ap == 0:
			index = (index + 1) % CombatManager.player_team.size()
		
		Globals.tower.get_node("%Players").get_child(index)._on_pressed()

func select_unit(creature: Creature) -> void:
	if creature == selected: return
	selection_changed.emit()
	
	if selected:
		selected.hp_changed.disconnect(_on_hp_changed)
		selected.max_hp_changed.disconnect(_on_hp_changed)
		selected.ap_changed.disconnect(_on_ap_changed)
		selected.max_ap_changed.disconnect(_on_ap_changed)
		selected.dc_changed.disconnect(_on_dc_changed)
		selected.stats_changed.disconnect(_on_stats_changed)
		
		if selected is Humanoid:
			%HumanoidItems/Head.item_changed.disconnect(selected.set_item_head)
			%HumanoidItems/Body.item_changed.disconnect(selected.set_item_body)
			%HumanoidItems/HandL.item_changed.disconnect(selected.set_item_hand_l)
			%HumanoidItems/HandR.item_changed.disconnect(selected.set_item_hand_r)
			selected.items_changed.disconnect(_on_actions_changed)
	
	selected = creature
	
	if creature:
		$VSplitContainer/TabContainer.current_tab = 1
		
		%InfoContainer/Name.text = creature.name.to_lower()
		if creature.get_type_name() != "":
			%InfoContainer/CreatureType.visible = true
			%InfoContainer/CreatureType.text = creature.get_type_name()
			%InfoContainer/CreatureType/CWikiLink.file = creature.get_type_wiki_page()
		else:
			%InfoContainer/CreatureType.visible = false
		
		_on_hp_changed(creature.hp)
		_on_ap_changed(creature.ap)
		_on_dc_changed(creature.get_dodge_chance())
		
		_on_stats_changed()
		_on_actions_changed()
		
		if creature is Humanoid:
			%HumanoidItems.visible = true
			%HumanoidItems/Head.modifiable = creature.modifiable
			%HumanoidItems/Head.item = creature.item_head
			%HumanoidItems/Head.item_changed.connect(creature.set_item_head)
			%HumanoidItems/Body.modifiable = creature.modifiable
			%HumanoidItems/Body.item = creature.item_body
			%HumanoidItems/Body.item_changed.connect(creature.set_item_body)
			%HumanoidItems/HandL.modifiable = creature.modifiable
			%HumanoidItems/HandL.item = creature.item_hand_l
			%HumanoidItems/HandL.item_changed.connect(creature.set_item_hand_l)
			%HumanoidItems/HandR.modifiable = creature.modifiable
			%HumanoidItems/HandR.item = creature.item_hand_r
			%HumanoidItems/HandR.item_changed.connect(creature.set_item_hand_r)
			
			creature.items_changed.connect(_on_actions_changed)
		else:
			%HumanoidItems.visible = false
		
		creature.hp_changed.connect(_on_hp_changed)
		creature.max_hp_changed.connect(_on_hp_changed)
		creature.ap_changed.connect(_on_ap_changed)
		creature.max_ap_changed.connect(_on_ap_changed)
		creature.dc_changed.connect(_on_dc_changed)
		creature.stats_changed.connect(_on_stats_changed)
	else:
		$VSplitContainer/TabContainer.current_tab = 0

func clear_inventory() -> void:
	for slot in $VSplitContainer/Inventory/HBoxContainer.get_children():
		slot.item = null

func _on_hp_changed(hp: int) -> void:
	%InfoContainer/Points/HP.text = "%d/%d hp" % [hp, selected.get_max_hp()]

func _on_ap_changed(ap: int) -> void:
	%InfoContainer/Points/AP.text = "%d/%d ap" % [ap, selected.get_max_ap()]

func _on_dc_changed(dc: float) -> void:
	%InfoContainer/Points/DodgeChance.text = "%d%% dc" % (dc * 100)

func _on_stats_changed() -> void:
	%Statistics/Might.text = "might    " + Utils.signed_int(selected.get_might())
	%Statistics/Might/CTooltip.label = "\n".join(selected.get_might_hint())
	%Statistics/Agility.text = "agility  " + Utils.signed_int(selected.get_agility())
	%Statistics/Agility/CTooltip.label = "\n".join(selected.get_agility_hint())
	%Statistics/Wisdom.text = "wisdom   " + Utils.signed_int(selected.get_wisdom())
	%Statistics/Wisdom/CTooltip.label = "\n".join(selected.get_wisdom_hint())

func _on_actions_changed() -> void:
	Utils.free_children(%Actions)
	%Actions.add_child(
		Utils.label(
			"actions",
			LabelSettingsBuilder.size(30)
		)
	)
	
	for row in selected.get_action_nodes():
		if row is ActionRow:
			row.click.connect(func (): _on_start_action(row.action))
		
		%Actions.add_child(row)

func _on_start_action(action: Action) -> void:
	if action.target == Action.TargetType.NONE:
#		apply action
		return
	
