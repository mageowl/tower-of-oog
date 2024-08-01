class_name CursorManager extends CanvasLayer

@export var cursor: Texture2D
@export var cursor_wiki_link: Texture2D
var tooltip_size: float = 0.0
var slot: ItemSlot
var skip_next_up: bool = false

func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Globals.register_cursor_manager(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Sprite.global_position = event.global_position
		if event.global_position.x >= get_viewport().get_visible_rect().size.x - tooltip_size:
			$Sprite/Tooltip.layout_direction = Control.LAYOUT_DIRECTION_RTL
		else:
			$Sprite/Tooltip.layout_direction = Control.LAYOUT_DIRECTION_LTR
	elif event is InputEventKey and event.is_action("open_wiki_under_cursor"):
		$Sprite.texture = cursor_wiki_link if event.is_pressed() else cursor
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and slot != null and !event.is_pressed():
		if skip_next_up:
			skip_next_up = false
			return
		
		slot.get_node("Item").show()
		$Sprite/Item.hide()
		
		slot = null


func _notification(event):
	if event == NOTIFICATION_WM_MOUSE_ENTER:
		$Sprite.show()
	elif event == NOTIFICATION_WM_MOUSE_EXIT:
		$Sprite.hide()

func set_tooltip(text: String) -> void:
	$Sprite/Tooltip/Label.text = text
	tooltip_size = ($Sprite/Tooltip/Label.get_minimum_size().x + 20)
	$Sprite/Tooltip/Label.show()

func clear_tooltip() -> void:
	tooltip_size = 0.0
	$Sprite/Tooltip/Label.hide()

func take_from(item_slot: ItemSlot) -> void:
	item_slot.get_node("Item").hide()
	$Sprite/Item.texture = item_slot.item.texture
	$Sprite/Item.show()
	
	skip_next_up = true
	slot = item_slot

func place_into(item_slot: ItemSlot) -> void:
	if (item_slot.slot_type != slot.item.slot and item_slot.slot_type != ItemSlot.Type.Consumable) \
			or (item_slot.item and item_slot.item.slot != slot.slot_type and slot.slot_type != ItemSlot.Type.Consumable):
		return
	
	var item = item_slot.item
	item_slot.item = slot.item
	slot.item = item
	
	slot.get_node("Item").show()
	item_slot.get_node("Item").show()
	slot = null
	$Sprite/Item.hide()
