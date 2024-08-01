class_name Action extends Resource

enum TargetType {
	NONE,
	ALLY,
	ENEMY,
	ALLY_TEAM,
	ENEMY_TEAM,
}

@export var name: String
@export var target: TargetType
@export var effect: Effect
@export var ap_cost = 1
@export var animation: String

func row() -> ActionRow:
	var row_node: ActionRow = preload("res://scenes/info/action_row.tscn").instantiate()
	row_node.action = self
	return row_node
