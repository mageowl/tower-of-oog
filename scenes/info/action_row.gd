class_name ActionRow extends MarginContainer

signal click

var action: Action :
	set(v):
		action = v
		
		$HBoxContainer/Name.text = action.name
		$HBoxContainer/Cost.text = "%d ap" % action.ap_cost
		
		match action.target:
			Action.TargetType.NONE: $HBoxContainer/Target.visible = false
			Action.TargetType.ALLY: $HBoxContainer/Target.text = " > ally"
			Action.TargetType.ENEMY: $HBoxContainer/Target.text = " > enemy"
			Action.TargetType.ALLY_TEAM: $HBoxContainer/Target.text = " > ally team"
			Action.TargetType.ENEMY_TEAM: $HBoxContainer/Target.text = " > enemy team"

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		click.emit()
