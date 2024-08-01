extends Node

var cursor_manager: CursorManager
var info_panel: InfoPanel
var tower: Tower
var logger: Log

func register_cursor_manager(node: CursorManager):
	cursor_manager = node

func register_info_panel(node: InfoPanel):
	info_panel = node

func register_tower(node: Tower):
	tower = node

func register_log(node: Log):
	logger = node
