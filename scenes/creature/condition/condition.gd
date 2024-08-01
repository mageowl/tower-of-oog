class_name Condition extends Resource

static func _on_turn(_creature: Creature) -> void:
	pass

func _to_string() -> String:
	return "condition"

static func _get_id() -> String:
	assert(false)
	return ""
