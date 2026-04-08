extends Control

func _ready():
	# Style bouton principal (Créer une table)
	var primary_style = StyleBoxFlat.new()
	primary_style.bg_color = Color("#F5A623")
	primary_style.corner_radius_top_left = 12
	primary_style.corner_radius_top_right = 12
	primary_style.corner_radius_bottom_left = 12
	primary_style.corner_radius_bottom_right = 12
	
	var primary_hover = primary_style.duplicate()
	primary_hover.bg_color = Color("#E8932A")
	
	$CenterContainer/BtnCreate.add_theme_stylebox_override("normal", primary_style)
	$CenterContainer/BtnCreate.add_theme_stylebox_override("hover", primary_hover)
	$CenterContainer/BtnCreate.add_theme_stylebox_override("pressed", primary_hover)
	$CenterContainer/BtnCreate.add_theme_color_override("font_color", Color("#1A1A1A"))
	$CenterContainer/BtnCreate.add_theme_color_override("font_hover_color", Color("#1A1A1A"))
	
	# Style boutons secondaires
	var secondary_style = StyleBoxFlat.new()
	secondary_style.bg_color = Color("#252525")
	secondary_style.border_color = Color("#F5A623")
	secondary_style.border_width_top = 1
	secondary_style.border_width_bottom = 1
	secondary_style.border_width_left = 1
	secondary_style.border_width_right = 1
	secondary_style.corner_radius_top_left = 12
	secondary_style.corner_radius_top_right = 12
	secondary_style.corner_radius_bottom_left = 12
	secondary_style.corner_radius_bottom_right = 12
	
	var secondary_hover = secondary_style.duplicate()
	secondary_hover.bg_color = Color("#2F2F2F")
	
	for btn_name in ["BtnJoin", "BtnMyTables", "BtnMyCharacters", "BtnSettings"]:
		var btn = $CenterContainer.get_node(btn_name)
		btn.add_theme_stylebox_override("normal", secondary_style)
		btn.add_theme_stylebox_override("hover", secondary_hover)
		btn.add_theme_stylebox_override("pressed", secondary_hover)
		btn.add_theme_color_override("font_color", Color("#F0EDE8"))
		btn.add_theme_color_override("font_hover_color", Color("#F5A623"))
	
	$CenterContainer/BtnMyTables.pressed.connect(_on_my_tables_pressed)

func _on_my_tables_pressed():
	get_tree().change_scene_to_file("res://scenes/my_tables.tscn")
