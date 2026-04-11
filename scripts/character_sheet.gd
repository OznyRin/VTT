extends Control

var stat_names := ["For", "Dex", "Con", "Int", "Sag", "Cha"]

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
	
	# Style des labels
	for node in get_all_children(self):
		if node is Label:
			node.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	# Style du titre Stats
	$Content/VBox/StatsTitle.add_theme_font_size_override("font_size", 24)
	$Content/VBox/StatsTitle.add_theme_color_override("font_color", Color("#F5A623"))
	
	# Style Notes label
	$Content/VBox/NotesLabel.add_theme_font_size_override("font_size", 24)
	$Content/VBox/NotesLabel.add_theme_color_override("font_color", Color("#F5A623"))
	
	# Style des LineEdit
	var edit_style = StyleBoxFlat.new()
	edit_style.bg_color = Color("#2F2F2F")
	edit_style.border_color = Color("#4A4A4A")
	edit_style.border_width_bottom = 1
	edit_style.corner_radius_top_left = 6
	edit_style.corner_radius_top_right = 6
	edit_style.corner_radius_bottom_left = 6
	edit_style.corner_radius_bottom_right = 6
	
	for edit in [
		$Content/VBox/IdentityRow/NameGroup/NameEdit,
		$Content/VBox/IdentityRow/ClassGroup/ClassEdit
	]:
		edit.add_theme_stylebox_override("normal", edit_style)
		edit.add_theme_color_override("font_color", Color("#F0EDE8"))
		edit.add_theme_color_override("font_placeholder_color", Color("#8A8680"))
		edit.custom_minimum_size = Vector2(250, 40)
	
	# Style du TextEdit (Notes)
	var notes_style = StyleBoxFlat.new()
	notes_style.bg_color = Color("#2F2F2F")
	notes_style.border_color = Color("#4A4A4A")
	notes_style.border_width_bottom = 1
	notes_style.corner_radius_top_left = 6
	notes_style.corner_radius_top_right = 6
	notes_style.corner_radius_bottom_left = 6
	notes_style.corner_radius_bottom_right = 6
	$Content/VBox/NotesEdit.add_theme_stylebox_override("normal", notes_style)
	$Content/VBox/NotesEdit.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	# Style des boutons Lancer
	var roll_style = StyleBoxFlat.new()
	roll_style.bg_color = Color("#F5A623")
	roll_style.corner_radius_top_left = 6
	roll_style.corner_radius_top_right = 6
	roll_style.corner_radius_bottom_left = 6
	roll_style.corner_radius_bottom_right = 6
	var roll_hover = roll_style.duplicate()
	roll_hover.bg_color = Color("#E8932A")
	
	# Style des modificateurs
	for stat in stat_names:
		var roll_btn = $Content/VBox/StatsGrid.get_node("Roll" + stat)
		roll_btn.add_theme_stylebox_override("normal", roll_style)
		roll_btn.add_theme_stylebox_override("hover", roll_hover)
		roll_btn.add_theme_stylebox_override("pressed", roll_hover)
		roll_btn.add_theme_color_override("font_color", Color("#1A1A1A"))
		roll_btn.add_theme_color_override("font_hover_color", Color("#1A1A1A"))
		roll_btn.custom_minimum_size = Vector2(80, 35)
		roll_btn.pressed.connect(_on_roll_stat.bind(stat))
		
		var mod_label = $Content/VBox/StatsGrid.get_node("Mod" + stat)
		mod_label.add_theme_color_override("font_color", Color("#F5A623"))
		mod_label.add_theme_font_size_override("font_size", 18)
		mod_label.custom_minimum_size = Vector2(40, 0)
		mod_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var stat_spin = $Content/VBox/StatsGrid.get_node("Stat" + stat)
		stat_spin.min_value = 1
		stat_spin.max_value = 30
		stat_spin.value = 10
		stat_spin.value_changed.connect(_on_stat_changed.bind(stat))
		
		var stat_label = $Content/VBox/StatsGrid.get_node("Label" + stat)
		stat_label.custom_minimum_size = Vector2(120, 0)
	
	# PV
	$Content/VBox/HPRow/HPGroup/HPInputs/HPCurrent.min_value = 0
	$Content/VBox/HPRow/HPGroup/HPInputs/HPCurrent.max_value = 999
	$Content/VBox/HPRow/HPGroup/HPInputs/HPCurrent.value = 10
	$Content/VBox/HPRow/HPGroup/HPInputs/HPMax.min_value = 1
	$Content/VBox/HPRow/HPGroup/HPInputs/HPMax.max_value = 999
	$Content/VBox/HPRow/HPGroup/HPInputs/HPMax.value = 10
	$Content/VBox/HPRow/HPGroup/HPInputs/HPSeparator.add_theme_font_size_override("font_size", 24)
	
	# Niveau
	$Content/VBox/IdentityRow/LevelGroup/LevelSpin.min_value = 1
	$Content/VBox/IdentityRow/LevelGroup/LevelSpin.max_value = 20
	$Content/VBox/IdentityRow/LevelGroup/LevelSpin.value = 1
	
	# Navigation
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)
	
	# Initialiser les modificateurs
	for stat in stat_names:
		_update_modifier(stat, 10)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_stat_changed(value, stat):
	_update_modifier(stat, value)

func _update_modifier(stat, value):
	var mod = int(floor((value - 10) / 2.0))
	var mod_text = "+" + str(mod) if mod >= 0 else str(mod)
	$Content/VBox/StatsGrid.get_node("Mod" + stat).text = mod_text

func _on_roll_stat(stat):
	var stat_spin = $Content/VBox/StatsGrid.get_node("Stat" + stat)
	var mod = int(floor((stat_spin.value - 10) / 2.0))
	var roll = randi_range(1, 20)
	var total = roll + mod
	var mod_text = "+" + str(mod) if mod >= 0 else str(mod)
	
	var result_text = stat + " : 1d20(" + str(roll) + ") " + mod_text + " = " + str(total)
	print(result_text)

func get_all_children(node):
	var children = []
	for child in node.get_children():
		children.append(child)
		children.append_array(get_all_children(child))
	return children
