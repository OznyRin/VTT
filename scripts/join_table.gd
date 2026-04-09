extends Control

func _ready():
	var nav_style = StyleBoxFlat.new()
	nav_style.bg_color = Color("#252525")
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
	
	$PageTitle.add_theme_font_size_override("font_size", 28)
	$PageTitle.add_theme_color_override("font_color", Color("#8A8680"))
	
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
