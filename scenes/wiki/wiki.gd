extends RichTextLabel

signal open_search

var file_path = "res://wiki/"

func load_from_md(source: String) -> void:
	text = ""
	
	var link = 0
	var link_to = ""
	var link_text = ""
	var num_font = false
	var title = false
	var first_title = true
	
	var i = 0
	while i < source.length():
		var char = source[i]
		
		match char:
			"[":
				link = 1
				link_to = ""
				link_text = ""
			"]":
				if link > 0:
					push_color(Color("#9ae"))
					push_meta("res://wiki/" + (link_to if link_to != "" else link_text), RichTextLabel.META_UNDERLINE_ON_HOVER)
					add_text(link_text)
					push_font(preload("res://global/theme/numbers.png"))
					add_text("^")
					pop()
					pop()
					pop()
					link = 0
			"|":
				if link == 1:
					link = 2
				else:
					add_text("|")
			"#":
				title = true
				push_font_size(30)
				if source[i + 1] == " ":
					i += 1
				if first_title:
					first_title = false
					push_meta(file_path.get_base_dir(), RichTextLabel.META_UNDERLINE_NEVER)
					push_font(preload("res://global/theme/numbers.png"))
					add_text("<")
					pop()
					pop()
					add_text(" ")
			"\n":
				if title:
					title = false
					pop()
				add_text("\n")
				if i < source.length() - 1 and source[i + 1] == "-":
					add_text("•")
					i += 1
			"_":
				if link == 1:
					link_text += "_"
				elif link == 2:
					link_to += "_"
				else:
					num_font = !num_font
					if num_font:
						push_italics()
					else:
						pop()
			_:
				if link == 1:
					link_text += char
				elif link == 2:
					link_to += char
				else:
					add_text(char)
		
		i += 1

func load_from_dir(files: Array[String], directories: Array[String]) -> void:
	if files.has("index.md"):
		var file = FileAccess.open(file_path + "/index.md", FileAccess.READ)
		load_from_md(file.get_as_text())
		add_text("\n")
	else:
		text = ""
		
		push_font_size(30)
		if file_path != "res://wiki":
			push_meta(file_path.get_base_dir(), RichTextLabel.META_UNDERLINE_NEVER)
			push_font(preload("res://global/theme/numbers.png"))
			add_text("<")
			pop()
			pop()
			add_text(" ")
		add_text(file_path.get_file().capitalize() + "\n")
		pop()
	
	for dir in directories:
		push_color(Color("#9ae"))
		push_meta(file_path + "/" + dir)
		push_font(preload("res://global/theme/numbers.png"))
		add_text("~`")
		pop()
		add_text(dir.capitalize() + "/\n")
		pop()
		pop()
	for file in files:
		if file == "index.md":
			continue
		
		push_color(Color("#9ae"))
		push_meta(file_path + "/" + file)
		add_text(file.get_file().get_basename().capitalize() + "\n")
		pop()
		pop()

func open(path: String) -> void:
	file_path = path.trim_suffix("/")
	
	if not FileAccess.file_exists(file_path) and not DirAccess.dir_exists_absolute(file_path):
		text = ""
		
		push_color(Color("#de6139"))
		add_text("Wiki article '%s' does not exist. " % file_path)
		pop()
		push_color(Color("#9ae"))
		push_meta("res://wiki")
		add_text("Go home")
		pop()
		pop()
	elif file_path.ends_with(".md"):
		var file = FileAccess.open(file_path, FileAccess.READ)
		load_from_md(file.get_as_text())
	else:
		var dir = DirAccess.open(file_path)
		load_from_dir(dir.get_files(), dir.get_directories())

func _ready() -> void:
	open("res://wiki")

func _on_meta_clicked(meta: Variant) -> void:
	if meta is String:
		if not meta.begins_with("\\"): open(meta)
		else:
			match meta:
				"\\search": open_search.emit()
