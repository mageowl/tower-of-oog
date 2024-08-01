class_name Tower extends Control

func _ready() -> void:
	Globals.register_tower(self)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		Globals.info_panel.unit_info.select_unit(null)

func add_player(piece: Piece) -> void:
	%Players.add_child(piece)

func add_enemy(piece: Piece) -> void:
	piece.flip = true
	%Enemies.add_child(piece)

func clear() -> void:
	Utils.free_children(%Players)
	Utils.free_children(%Enemies)
