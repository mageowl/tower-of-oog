class_name Log extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.register_log(self)

func write(text: String, style: LabelSettings = null) -> void:
	$VBoxContainer.add_child(Utils.label(text, style))

func clear() -> void:
	Utils.free_children($VBoxContainer)
