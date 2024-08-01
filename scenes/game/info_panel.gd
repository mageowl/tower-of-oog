class_name InfoPanel extends Control

enum Tab {
	UNIT_INFO,
	WIKI
}

@onready var unit_info: UnitInfo = $TabContainer/UnitInfo

func _ready() -> void:
	Globals.register_info_panel(self)

func open_wiki(file: String) -> void:
	$TabContainer.current_tab = Tab.WIKI
	$TabContainer/Wiki.open(file)

func _on_wiki_toggled(toggled_on: bool) -> void:
	$TabContainer.current_tab = Tab.WIKI if toggled_on else Tab.UNIT_INFO
	$TabContainer/Wiki.open("res://wiki")

func _on_tab_container_tab_changed(tab: int) -> void:
	$OpenWiki.set_pressed_no_signal(tab == Tab.WIKI)
