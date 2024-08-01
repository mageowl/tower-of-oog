class_name Piece extends Button

var creature: Creature
var flip: bool = false

@warning_ignore("shadowed_variable")
static func from(creature: Creature) -> Piece:
	var instance = preload("res://scenes/creature/piece/piece.tscn").instantiate()
	instance.creature = creature
	return instance

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Sprite, "scale:y", 1, 0.2).set_trans(Tween.TRANS_EXPO).from(0)
	
	$CTooltip.label = creature.name.to_lower()
	
	$HealthBar.max_value = creature.get_max_hp()
	$HealthBar.value = creature.hp
	$HealthBar/Label.text = "%d/%d" % [creature.hp, creature.get_max_hp()]
	
	$ActionPoints.max_value = creature.get_max_ap()
	$ActionPoints.value = creature.ap
	$ActionPoints.stretch_margin_left = creature.get_max_ap() * 20
	
	var sprite = creature.get_sprite().instantiate()
	sprite.creature = creature
	$Sprite.add_child(sprite)
	$Sprite.scale.x = -1 if flip else 1
	creature.sprite_changed.connect(func (): sprite.update())
	
	creature.hp_changed.connect(_on_hp_changed)
	creature.max_hp_changed.connect(_on_max_hp_changed)
	creature.ap_changed.connect(_on_ap_changed)
	creature.max_ap_changed.connect(_on_max_ap_changed)
	

func _on_hp_changed(value: int) -> void:
	$HealthBar.value = value
	$HealthBar/Label.text = "%d/%d" % [value, creature.get_max_hp()]

func _on_max_hp_changed(value: int) -> void:
	$HealthBar.max_value = value
	$HealthBar/Label.text = "%d/%d" % [value, creature.get_max_hp()]

func _on_ap_changed(value: int) -> void:
	$ActionPoints.value = value

func _on_max_ap_changed(value: int) -> void:
	$ActionPoints.max_value = value
	$ActionPoints.stretch_margin_left = value * 20

func _on_pressed() -> void:
	Globals.info_panel.unit_info.select_unit(creature)
	
	$SelectionMarker.visible = true
	if creature.modifiable:
		$SelectionMarker/AnimationPlayer.play("flash")
	Globals.info_panel.unit_info.selection_changed.connect(
		func ():
			$SelectionMarker.visible = false
			$SelectionMarker/AnimationPlayer.stop(),
		CONNECT_ONE_SHOT
	)
