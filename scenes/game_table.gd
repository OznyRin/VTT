extends Control

func _ready():
	# NavBar
	var nav_style = StyleBoxFlat.new()
	nav_style.bg_color = Color("#252525")
	$NavBar.add_theme_stylebox_override("panel", nav_style)
	
	var home_style = StyleBoxEmpty.new()
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("normal", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("hover", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_stylebox_override("pressed", home_style)
	$NavBar/HBoxContainer/BtnHome.add_theme_color_override("font_color", Color("#F5A623"))
	$NavBar/HBoxContainer/BtnHome.add_theme_color_override("font_hover_color", Color("#E8932A"))
	$NavBar/HBoxContainer/BtnHome.add_theme_font_size_override("font_size", 20)
	
	$NavBar/HBoxContainer/TableName.add_theme_color_override("font_color", Color("#F0EDE8"))
	$NavBar/HBoxContainer/TableName.add_theme_font_size_override("font_size", 18)
	
	# Chat Panel
	var chat_style = StyleBoxFlat.new()
	chat_style.bg_color = Color("#252525")
	$ChatPanel.add_theme_stylebox_override("panel", chat_style)
	
	$ChatPanel/ChatVBox/ChatTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	$ChatPanel/ChatVBox/ChatTitle.add_theme_font_size_override("font_size", 18)
	
	var msg_style = StyleBoxFlat.new()
	msg_style.bg_color = Color("#2F2F2F")
	$ChatPanel/ChatVBox/ChatMessages.add_theme_stylebox_override("panel", msg_style)
	
	var input_style = StyleBoxFlat.new()
	input_style.bg_color = Color("#383838")
	input_style.border_color = Color("#4A4A4A")
	input_style.border_width_top = 1
	input_style.border_width_bottom = 1
	input_style.border_width_left = 1
	input_style.border_width_right = 1
	$ChatPanel/ChatVBox/ChatInput.add_theme_stylebox_override("panel", input_style)
	
	$ChatPanel/ChatVBox/ChatInput/ChatPlaceholder.add_theme_color_override("font_color", Color("#8A8680"))
	$ChatPanel/ChatVBox/ChatInput/ChatPlaceholder.add_theme_font_size_override("font_size", 14)
	
	# Toolbar
	var toolbar_style = StyleBoxFlat.new()
	toolbar_style.bg_color = Color("#252525")
	$Toolbar.add_theme_stylebox_override("panel", toolbar_style)
	
	var tool_style = StyleBoxFlat.new()
	tool_style.bg_color = Color("#2F2F2F")
	tool_style.corner_radius_top_left = 8
	tool_style.corner_radius_top_right = 8
	tool_style.corner_radius_bottom_left = 8
	tool_style.corner_radius_bottom_right = 8
	for i in range(1, 6):
		$Toolbar/ToolsHBox.get_node("Tool" + str(i)).add_theme_stylebox_override("panel", tool_style)
	
	# Map Area
	var map_style = StyleBoxFlat.new()
	map_style.bg_color = Color("#1E1E1E")
	$MapArea.add_theme_stylebox_override("panel", map_style)
	
	$MapArea/MapPlaceholder.add_theme_color_override("font_color", Color("#3A3A3A"))
	$MapArea/MapPlaceholder.add_theme_font_size_override("font_size", 24)
	
	# Navigation
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
