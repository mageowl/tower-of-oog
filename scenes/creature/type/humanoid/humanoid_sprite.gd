class_name HumanoidSprite extends PieceSprite

const ARMS = [
	preload("res://scenes/creature/type/humanoid/arm/skin_0.png"),
	preload("res://scenes/creature/type/humanoid/arm/skin_1.png"),
	preload("res://scenes/creature/type/humanoid/arm/skin_2.png"),
	preload("res://scenes/creature/type/humanoid/arm/skin_3.png"),
]
const LEGS = [
	preload("res://scenes/creature/type/humanoid/leg/skin_0.png"),
	preload("res://scenes/creature/type/humanoid/leg/skin_1.png"),
	preload("res://scenes/creature/type/humanoid/leg/skin_2.png"),
	preload("res://scenes/creature/type/humanoid/leg/skin_3.png"),
]
const HEADS = [
	preload("res://scenes/creature/type/humanoid/head/skin_0.png"),
	preload("res://scenes/creature/type/humanoid/head/skin_1.png"),
	preload("res://scenes/creature/type/humanoid/head/skin_2.png"),
	preload("res://scenes/creature/type/humanoid/head/skin_3.png"),
]

const FACES = [
	preload("res://scenes/creature/type/humanoid/face/angy.png"),
	preload("res://scenes/creature/type/humanoid/face/shocked.png"),
	preload("res://scenes/creature/type/humanoid/face/toungue.png"),
	preload("res://scenes/creature/type/humanoid/face/bottom.png"),
	preload("res://scenes/creature/type/humanoid/face/cat.png"),
	preload("res://scenes/creature/type/humanoid/face/derp.png"),
	preload("res://scenes/creature/type/humanoid/face/xd.png"),
]
const SKIN_DARKEN: Array[Color] = [
	0x9d6f4dff,
	0x6f452dff,
	0x381913ff,
	0x381913ff,
]
const EYES: Array[Color] = [
	0x189cc4ff,
	0x87cd4bff,
	0x2d3e54ff,
]
const EYES_RARE: Array[Color] = [
	0xbc3232ff,
	0x421e5fff,
]

const HAIR_STYLES = [
	preload("res://scenes/creature/type/humanoid/hair/long.png"),
	preload("res://scenes/creature/type/humanoid/hair/mohawk.png"),
	preload("res://scenes/creature/type/humanoid/hair/short.png"),
	preload("res://scenes/creature/type/humanoid/hair/short_bangs.png"),
	preload("res://scenes/creature/type/humanoid/hair/sweep_left.png"),
	preload("res://scenes/creature/type/humanoid/hair/bald.png"),
	preload("res://scenes/creature/type/humanoid/hair/single_hair.png"),
]
const HAIR_COLORS = [
	0xf7bf48ff,
	0x2c0903ff,
	0x6f452dff,
	0xde6139ff,
	0x1d273fff,
]
const HAIR_COLORS_RARE = [
	0xb65ad1ff,
	0xb8ff5fff,
	0x99ffd8ff,
	0x189cc4ff,
	0xb9c5c9ff,
]

func _ready() -> void:
	super._ready()
	$Body/Head/Face.material = $Body/Head/Face.material.duplicate()

func get_arm() -> Texture:
	return ARMS[creature.skin_tone]

func get_leg() -> Texture:
	return LEGS[creature.skin_tone]

func get_head() -> Texture:
	return HEADS[creature.skin_tone]

func get_skin_darken() -> Color:
	return SKIN_DARKEN[creature.skin_tone]

func get_hair_style() -> Texture:
	return HAIR_STYLES[creature.hair_style]

func update() -> void:
	if creature is Humanoid:
		if creature.item_body != null:
			$Body.texture = creature.item_body.texture
		else:
			$Body.texture = preload("res://scenes/creature/type/humanoid/tunic.png")
		
		if creature.item_head != null:
			$Body/Head/Item.show()
			$Body/Head/Item.texture = creature.item_head.texture
			$Body/Head/Item.offset = creature.item_head.offset
			$Body/Head/Hair.hide()
		else:
			$Body/Head/Item.hide()
			$Body/Head/Hair.texture = get_hair_style()
			$Body/Head/Hair.self_modulate = creature.hair_color
		
		if creature.item_hand_l != null:
			$Body/ArmL/Item.show()
			$Body/ArmL/Item.texture = creature.item_hand_l.texture
			$Body/ArmL/Item.offset = creature.item_hand_l.offset
		else:
			$Body/ArmL/Item.hide()
		
		if creature.item_hand_r != null:
			$Body/ArmR/Item.show()
			$Body/ArmR/Item.texture = creature.item_hand_r.texture
			$Body/ArmR/Item.offset = creature.item_hand_r.offset
		else:
			$Body/ArmR/Item.hide()
		
		$Body/ArmL.texture = get_arm()
		$Body/ArmR.texture = get_arm()
		$Body/LegL.texture = get_leg()
		$Body/LegR.texture = get_leg()
		$Body/Head.texture = get_head()
		
		$Body/Head/Face.texture = FACES[creature.face]
		var face_material = ($Body/Head/Face.material as ShaderMaterial)
		face_material.set_shader_parameter("skin_darken", get_skin_darken())
		face_material.set_shader_parameter("eyes", creature.eye_color)
