@tool
class_name CTooltip extends Node

@export_multiline var label: String = ""

func _get_configuration_warnings() -> PackedStringArray:
	if get_parent() is Control:
		return []
	else:
		return ["Parent must be a Control node to detect hover events."]

func _enter_tree() -> void:
	update_configuration_warnings()

func _ready() -> void:
	if get_parent() is Control:
		(get_parent() as Control).mouse_entered.connect(_on_mouse_entered)
		(get_parent() as Control).mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if label != "":
		Globals.cursor_manager.set_tooltip(label)

func _on_mouse_exited() -> void:
	if label != "":
		Globals.cursor_manager.clear_tooltip()
