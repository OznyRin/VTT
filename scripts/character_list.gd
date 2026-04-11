extends Control

func _ready():
	# NavBar
	var nav_style = StyleBoxFlat.new()
	nav_style.bg_color = Color("#252525")
	nav_style.border_color = Color("#3A3A3A")
	nav_style.border_width_bottom = 1
	$NavBar.add_theme_stylebox_override("panel", nav_style)
	
	var home_style = StyleBoxEmpty.new()
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("normal", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("hover", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("pressed", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_color_override("font_color", Color("#F5A623"))
	$NavBar/HBoxContainer/BtnHome.add_theme_color_override("font_hover_color", Color("#E8932A"))
	$NavBar/HBoxContainer/BtnHome.add_theme_font_size_override("font_size", 24)
	
	$NavBar/HBoxContainer/NavTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	$NavBar/HBoxContainer/NavTitle.add_theme_font_size_override("font_size", 20)
	
	# Titre
	$Content/VBox/Header/PageTitle.add_theme_font_size_override("font_size", 36)
	$Content/VBox/Header/PageTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	# Bouton nouveau
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = Color("#F5A623")
	btn_style.corner_radius_top_left = 8
	btn_style.corner_radius_top_right = 8
	btn_style.corner_radius_bottom_left = 8
	btn_style.corner_radius_bottom_right = 8
	var btn_hover = btn_style.duplicate()
	btn_hover.bg_color = Color("#E8932A")
	$Content/VBox/Header/BtnNew.add_theme_stylebox_override("normal", btn_style)
	$Content/VBox/Header/BtnNew.add_theme_stylebox_override("hover", btn_hover)
	$Content/VBox/Header/BtnNew.add_theme_stylebox_override("pressed", btn_hover)
	$Content/VBox/Header/BtnNew.add_theme_color_override("font_color", Color("#1A1A1A"))
	$Content/VBox/Header/BtnNew.custom_minimum_size = Vector2(200, 45)
	
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)
	$Content/VBox/Header/BtnNew.pressed.connect(_on_new_pressed)
	
	# Charger la liste des personnages
	load_character_list()

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_new_pressed():
	# Ouvrir une fiche vierge
	Global.current_character_file = ""
	get_tree().change_scene_to_file("res://scenes/character_sheet.tscn")

func load_character_list():
	# Vider la liste
	for child in $Content/VBox/CharList.get_children():
		child.queue_free()
	
	var dir = DirAccess.open("user://saves/")
	if not dir:
		var empty_label = Label.new()
		empty_label.text = "Aucun personnage sauvegardé"
		empty_label.add_theme_color_override("font_color", Color("#8A8680"))
		empty_label.add_theme_font_size_override("font_size", 18)
		$Content/VBox/CharList.add_child(empty_label)
		return
	
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".json"):
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	if files.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Aucun personnage sauvegardé"
		empty_label.add_theme_color_override("font_color", Color("#8A8680"))
		empty_label.add_theme_font_size_override("font_size", 18)
		$Content/VBox/CharList.add_child(empty_label)
		return
	
	for fname in files:
		var file = FileAccess.open("user://saves/" + fname, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		if json.parse(json_text) != OK:
			continue
		
		var data = json.data
		
		# Créer une carte pour ce personnage
		var card = PanelContainer.new()
		card.custom_minimum_size = Vector2(0, 70)
		var card_style = StyleBoxFlat.new()
		card_style.bg_color = Color("#2F2F2F")
		card_style.corner_radius_top_left = 10
		card_style.corner_radius_top_right = 10
		card_style.corner_radius_bottom_left = 10
		card_style.corner_radius_bottom_right = 10
		card.add_theme_stylebox_override("panel", card_style)
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 20)
		
		var name_label = Label.new()
		name_label.text = data.get("name", "Sans nom")
		name_label.add_theme_font_size_override("font_size", 22)
		name_label.add_theme_color_override("font_color", Color("#F0EDE8"))
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var info_label = Label.new()
		info_label.text = data.get("class", "") + " Niv." + str(data.get("level", 1))
		info_label.add_theme_font_size_override("font_size", 16)
		info_label.add_theme_color_override("font_color", Color("#8A8680"))
		
		var hp_label = Label.new()
		hp_label.text = "PV: " + str(data.get("hp_current", 0)) + "/" + str(data.get("hp_max", 0))
		hp_label.add_theme_font_size_override("font_size", 16)
		hp_label.add_theme_color_override("font_color", Color("#F5A623"))
		
		var open_btn = Button.new()
		open_btn.text = "Ouvrir"
		var open_style = StyleBoxFlat.new()
		open_style.bg_color = Color("#F5A623")
		open_style.corner_radius_top_left = 6
		open_style.corner_radius_top_right = 6
		open_style.corner_radius_bottom_left = 6
		open_style.corner_radius_bottom_right = 6
		open_btn.add_theme_stylebox_override("normal", open_style)
		open_btn.add_theme_color_override("font_color", Color("#1A1A1A"))
		open_btn.custom_minimum_size = Vector2(80, 35)
		open_btn.pressed.connect(_on_open_character.bind(fname))
		
		hbox.add_child(name_label)
		hbox.add_child(info_label)
		hbox.add_child(hp_label)
		hbox.add_child(open_btn)
		card.add_child(hbox)
		$Content/VBox/CharList.add_child(card)

func _on_open_character(file_name):
	Global.current_character_file = file_name
	get_tree().change_scene_to_file("res://scenes/character_sheet.tscn")
