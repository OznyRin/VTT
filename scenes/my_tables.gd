extends Control

func _ready():
	# Style NavBar
	var nav_style = StyleBoxFlat.new()
	nav_style.bg_color = Color("#252525")
	$NavBar.add_theme_stylebox_override("panel", nav_style)
	
	# Style bouton Home
	var home_style = StyleBoxEmpty.new()
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("normal", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("hover", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("pressed", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_color_override("font_color", Color("#F5A623"))
	$NavBar/HBoxContainer/BtnHome.add_theme_color_override("font_hover_color", Color("#E8932A"))
	$NavBar/HBoxContainer/BtnHome.add_theme_font_size_override("font_size", 24)
	
	# Style titre nav
	$NavBar/HBoxContainer/NavTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	$NavBar/HBoxContainer/NavTitle.add_theme_font_size_override("font_size", 20)
	
	# Style titre page
	$Content/VBox/Header/PageTitle.add_theme_font_size_override("font_size", 36)
	$Content/VBox/Header/PageTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	# Style bouton nouvelle table
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = Color("#F5A623")
	btn_style.corner_radius_top_left = 8
	btn_style.corner_radius_top_right = 8
	btn_style.corner_radius_bottom_left = 8
	btn_style.corner_radius_bottom_right = 8
	var btn_hover = btn_style.duplicate()
	btn_hover.bg_color = Color("#E8932A")
	$Content/VBox/Header/BtnNewTable.add_theme_stylebox_override("normal", btn_style)
	$Content/VBox/Header/BtnNewTable.add_theme_stylebox_override("hover", btn_hover)
	$Content/VBox/Header/BtnNewTable.add_theme_stylebox_override("pressed", btn_hover)
	$Content/VBox/Header/BtnNewTable.add_theme_color_override("font_color", Color("#1A1A1A"))
	$Content/VBox/Header/BtnNewTable.add_theme_color_override("font_hover_color", Color("#1A1A1A"))
	$Content/VBox/Header/BtnNewTable.custom_minimum_size = Vector2(180, 45)
	
	# Style cartes
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color("#2F2F2F")
	card_style.corner_radius_top_left = 12
	card_style.corner_radius_top_right = 12
	card_style.corner_radius_bottom_left = 12
	card_style.corner_radius_bottom_right = 12
	$Content/VBox/CardsGrid/Card1.add_theme_stylebox_override("panel", card_style)
	$Content/VBox/CardsGrid/Card2.add_theme_stylebox_override("panel", card_style)
	
	# Navigation retour
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
