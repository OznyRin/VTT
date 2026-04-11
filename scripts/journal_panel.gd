extends Control

var notes := {}
var current_note_id := ""

func _ready():
	# Style du panel
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color("#252525")
	bg_style.border_color = Color("#F5A623")
	bg_style.border_width_top = 2
	bg_style.corner_radius_top_left = 8
	bg_style.corner_radius_top_right = 8
	bg_style.corner_radius_bottom_left = 8
	bg_style.corner_radius_bottom_right = 8
	$Background.add_theme_stylebox_override("panel", bg_style)
	
	# Style titre
	$Background/VBox/Header/Title.add_theme_font_size_override("font_size", 22)
	$Background/VBox/Header/Title.add_theme_color_override("font_color", Color("#F5A623"))
	$Background/VBox/Header/Title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Style bouton fermer
	var close_style = StyleBoxFlat.new()
	close_style.bg_color = Color("#D94444")
	close_style.corner_radius_top_left = 4
	close_style.corner_radius_top_right = 4
	close_style.corner_radius_bottom_left = 4
	close_style.corner_radius_bottom_right = 4
	$Background/VBox/Header/BtnClose.add_theme_stylebox_override("normal", close_style)
	$Background/VBox/Header/BtnClose.add_theme_color_override("font_color", Color("#F0EDE8"))
	$Background/VBox/Header/BtnClose.custom_minimum_size = Vector2(30, 30)
	
	# Style bouton nouvelle note
	var new_style = StyleBoxFlat.new()
	new_style.bg_color = Color("#F5A623")
	new_style.corner_radius_top_left = 6
	new_style.corner_radius_top_right = 6
	new_style.corner_radius_bottom_left = 6
	new_style.corner_radius_bottom_right = 6
	$Background/VBox/NotesList/NoteTabs/BtnNewNote.add_theme_stylebox_override("normal", new_style)
	$Background/VBox/NotesList/NoteTabs/BtnNewNote.add_theme_color_override("font_color", Color("#1A1A1A"))
	
	# Style tabs
	var tabs_style = StyleBoxFlat.new()
	tabs_style.bg_color = Color("#2F2F2F")
	tabs_style.corner_radius_top_left = 6
	tabs_style.corner_radius_top_right = 6
	tabs_style.corner_radius_bottom_left = 6
	tabs_style.corner_radius_bottom_right = 6
	$Background/VBox/NotesList/NoteTabs.add_theme_stylebox_override("panel", tabs_style) if $Background/VBox/NotesList/NoteTabs is PanelContainer else null
	
	# Style éditeur
	var edit_style = StyleBoxFlat.new()
	edit_style.bg_color = Color("#2F2F2F")
	edit_style.corner_radius_top_left = 6
	edit_style.corner_radius_top_right = 6
	edit_style.corner_radius_bottom_left = 6
	edit_style.corner_radius_bottom_right = 6
	$Background/VBox/NotesList/NoteContent/NoteTitle.add_theme_stylebox_override("normal", edit_style)
	$Background/VBox/NotesList/NoteContent/NoteTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	$Background/VBox/NotesList/NoteContent/NoteTitle.add_theme_color_override("font_placeholder_color", Color("#8A8680"))
	
	var body_style = StyleBoxFlat.new()
	body_style.bg_color = Color("#2F2F2F")
	body_style.corner_radius_top_left = 6
	body_style.corner_radius_top_right = 6
	body_style.corner_radius_bottom_left = 6
	body_style.corner_radius_bottom_right = 6
	$Background/VBox/NotesList/NoteContent/NoteBody.add_theme_stylebox_override("normal", body_style)
	$Background/VBox/NotesList/NoteContent/NoteBody.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	# Style boutons d'action
	var action_style = StyleBoxFlat.new()
	action_style.bg_color = Color("#F5A623")
	action_style.corner_radius_top_left = 6
	action_style.corner_radius_top_right = 6
	action_style.corner_radius_bottom_left = 6
	action_style.corner_radius_bottom_right = 6
	var action_hover = action_style.duplicate()
	action_hover.bg_color = Color("#E8932A")
	
	for btn in [$Background/VBox/NotesList/NoteContent/NoteActions/BtnSaveNote, $Background/VBox/NotesList/NoteContent/NoteActions/BtnShareNote]:
		btn.add_theme_stylebox_override("normal", action_style)
		btn.add_theme_stylebox_override("hover", action_hover)
		btn.add_theme_color_override("font_color", Color("#1A1A1A"))
		btn.custom_minimum_size = Vector2(100, 35)
	
	var del_style = StyleBoxFlat.new()
	del_style.bg_color = Color("#D94444")
	del_style.corner_radius_top_left = 6
	del_style.corner_radius_top_right = 6
	del_style.corner_radius_bottom_left = 6
	del_style.corner_radius_bottom_right = 6
	$Background/VBox/NotesList/NoteContent/NoteActions/BtnDeleteNote.add_theme_stylebox_override("normal", del_style)
	$Background/VBox/NotesList/NoteContent/NoteActions/BtnDeleteNote.add_theme_color_override("font_color", Color("#F0EDE8"))
	$Background/VBox/NotesList/NoteContent/NoteActions/BtnDeleteNote.custom_minimum_size = Vector2(100, 35)
	
	# Connexions
	$Background/VBox/Header/BtnClose.pressed.connect(_on_close)
	$Background/VBox/NotesList/NoteTabs/BtnNewNote.pressed.connect(_on_new_note)
	$Background/VBox/NotesList/NoteContent/NoteActions/BtnSaveNote.pressed.connect(_on_save_note)
	$Background/VBox/NotesList/NoteContent/NoteActions/BtnDeleteNote.pressed.connect(_on_delete_note)
	$Background/VBox/NotesList/NoteContent/NoteActions/BtnShareNote.pressed.connect(_on_share_note)
	
	# Charger les notes existantes
	load_notes()
	visible = false

func _on_new_note():
	var id = str(Time.get_unix_time_from_system())
	notes[id] = {"title": "Nouvelle note", "body": ""}
	current_note_id = id
	refresh_tabs()
	display_note(id)

func display_note(id):
	current_note_id = id
	if notes.has(id):
		$Background/VBox/NotesList/NoteContent/NoteTitle.text = notes[id]["title"]
		$Background/VBox/NotesList/NoteContent/NoteBody.text = notes[id]["body"]

func refresh_tabs():
	for child in $Background/VBox/NotesList/NoteTabs/TabsScroll/TabsList.get_children():
		child.queue_free()
	
	for id in notes:
		var btn = Button.new()
		btn.text = notes[id]["title"]
		btn.add_theme_color_override("font_color", Color("#F0EDE8"))
		var tab_style = StyleBoxFlat.new()
		tab_style.bg_color = Color("#3A3A3A") if id == current_note_id else Color("#2F2F2F")
		tab_style.corner_radius_top_left = 4
		tab_style.corner_radius_top_right = 4
		tab_style.corner_radius_bottom_left = 4
		tab_style.corner_radius_bottom_right = 4
		btn.add_theme_stylebox_override("normal", tab_style)
		btn.pressed.connect(display_note.bind(id))
		$Background/VBox/NotesList/NoteTabs/TabsScroll/TabsList.add_child(btn)

func _on_save_note():
	if current_note_id == "":
		return
	notes[current_note_id]["title"] = $Background/VBox/NotesList/NoteContent/NoteTitle.text
	notes[current_note_id]["body"] = $Background/VBox/NotesList/NoteContent/NoteBody.text
	save_notes()
	refresh_tabs()

func _on_delete_note():
	if current_note_id == "":
		return
	notes.erase(current_note_id)
	current_note_id = ""
	$Background/VBox/NotesList/NoteContent/NoteTitle.text = ""
	$Background/VBox/NotesList/NoteContent/NoteBody.text = ""
	save_notes()
	refresh_tabs()

func _on_share_note():
	if current_note_id == "" or not notes.has(current_note_id):
		return
	var title = notes[current_note_id]["title"]
	var body = notes[current_note_id]["body"]
	var parent = get_parent()
	if parent.has_method("add_chat_message"):
		parent.add_chat_message("Journal", "[b]" + title + "[/b]\n" + body)

func save_notes():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")
	var file = FileAccess.open("user://saves/journal.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(notes, "\t"))
	file.close()

func load_notes():
	var file = FileAccess.open("user://saves/journal.json", FileAccess.READ)
	if not file:
		return
	var json_text = file.get_as_text()
	file.close()
	var json = JSON.new()
	if json.parse(json_text) == OK:
		notes = json.data
		refresh_tabs()

func _on_close():
	visible = false
