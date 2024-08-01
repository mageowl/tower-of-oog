class_name Utils

static func signed_int(num: int) -> String:
	if num == 0: return " 0"
	else: return "%s%d" % ["+" if num >= 0 else "-", abs(num)]

static func flatten(arr: Array[Array]) -> Array:
	var res = []
	
	for sub in arr:
		res.append_array(sub)
	
	return res

static func free_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()

static func label(text: String, style: LabelSettings = null) -> Label:
	var l = Label.new()
	l.text = text
	l.label_settings = style
	return l
