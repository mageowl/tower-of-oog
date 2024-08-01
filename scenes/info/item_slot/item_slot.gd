@tool
class_name ItemSlot extends TextureButton

signal item_changed(v: Item)

enum Type {
	Head,
	Body,
	Hand,
	Consumable
}

const TEXTURES = {
	[Type.Head, false]: preload("res://scenes/info/item_slot/slot_hat.png"),
	[Type.Hand, false]: preload("res://scenes/info/item_slot/slot_hand_l.png"),
	[Type.Hand, true]: preload("res://scenes/info/item_slot/slot_hand_r.png"),
	[Type.Body, false]: preload("res://scenes/info/item_slot/slot_body.png"),
	[Type.Consumable, false]: preload("res://scenes/info/item_slot/slot_any.png")
}

var modifiable = true
var slot_type = Type.Head :
	set(v):
		slot_type = v
		if not v == Type.Hand:
			flip = false
		
		texture_normal = TEXTURES[[v, flip]]
		notify_property_list_changed()
var flip = false :
	set(v):
		flip = v
		texture_normal = TEXTURES[[slot_type, v]]

var item: Item :
	set(v):
		item = v
		item_changed.emit(v)
		
		if item != null:
			$Item.texture = item.texture
			$CTooltip.label = item.name.to_lower()
		else:
			$Item.texture = null
			$CTooltip.label = ""

func _get_property_list() -> Array[Dictionary]:
	return [
		{
			"name": "modifiable",
			"type": TYPE_BOOL,
		},
		{
			"name": "slot_type",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Head,Body,Hand,Consumable"
		},
		{
			"name": "flip",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT if slot_type == Type.Hand else PROPERTY_USAGE_NO_EDITOR
		}
	]


func _on_button_down() -> void:
	if Input.is_action_pressed("open_wiki_under_cursor"):
		if item != null and item.wiki_page != "":
			Globals.info_panel.open_wiki(item.wiki_page)
	elif modifiable:
		if item != null and Globals.cursor_manager.slot == null:
			Globals.cursor_manager.take_from(self)
		elif Globals.cursor_manager.slot != null:
			Globals.cursor_manager.place_into(self)
