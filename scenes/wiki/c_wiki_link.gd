@tool
class_name CWikiLink extends Node

@export_file("*.md") var file = "" :
	set(v):
		file = v
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	return [] \
		+ (["Parent must be a Control node to detect click events."] if not get_parent() is Control else []) \
		+ (["A file must be provided to link to."] if file == "" else []) \
		+ (["A mouse filter of ignore will prevent the link from being clicked."] if get_parent() is Control and get_parent().mouse_filter == Control.MouseFilter.MOUSE_FILTER_IGNORE else [])

func _enter_tree() -> void:
	update_configuration_warnings()

func _ready() -> void:
	if get_parent() is Control and file != "":
		(get_parent() as Control).gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and file != "":
		if event.button_index == MOUSE_BUTTON_LEFT and Input.is_action_pressed("open_wiki_under_cursor"):
			Globals.info_panel.open_wiki(file)
