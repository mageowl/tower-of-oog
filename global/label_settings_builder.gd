class_name LabelSettingsBuilder extends LabelSettings

func _init() -> void:
	font_size = 20

func with_size(size: int) -> LabelSettingsBuilder:
	font_size = size
	return self

static func size(size: int) -> LabelSettingsBuilder:
	return LabelSettingsBuilder.new().with_size(size)
