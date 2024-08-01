class_name Item extends Resource

@export var name: String
@export var slot: ItemSlot.Type
@export_file("*.md") var wiki_page: String

@export_group("Function")
@export var modifiers: Array[Modifier]
@export var actions: Array[Action]

@export_group("Texture")
@export var texture: Texture2D
@export var offset: Vector2
