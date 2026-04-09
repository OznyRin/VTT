extends Control

var zoom_speed := 0.1
var min_zoom := 0.2
var max_zoom := 3.0
var is_panning := false
var right_click_world_pos := Vector2.ZERO
var token_scene := preload("res://scripts/token.gd")
var token_count := 0

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
	
	# Charger la map
	var map_texture = load("res://assets/map.jpg")
	$MapArea/MapViewportContainer/MapViewport/MapSprite.texture = map_texture
	
	# Centrer la grille sur la map
	var map_size = map_texture.get_size()
	$MapArea/MapViewportContainer/MapViewport/GridOverlay.position = -map_size / 2
	
	# Navigation
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)
	
	# Menu contextuel
	$MapContextMenu.add_item("Ajouter un token", 0)
	$MapContextMenu.id_pressed.connect(_on_context_menu_pressed)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	# Clic droit menu contextuel
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var camera = $MapArea/MapViewportContainer/MapViewport/Camera
		var viewport = $MapArea/MapViewportContainer/MapViewport
		var mouse_pos = event.position
		var viewport_size = viewport.get_visible_rect().size
		right_click_world_pos = camera.get_screen_center_position() + (mouse_pos - viewport_size / 2) / camera.zoom
		$MapContextMenu.position = Vector2i(int(event.global_position.x), int(event.global_position.y))
		$MapContextMenu.popup()
	
	var camera = $MapArea/MapViewportContainer/MapViewport/Camera
	
	# Zoom avec la molette
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var new_zoom = min(camera.zoom.x + zoom_speed, max_zoom)
			camera.zoom = Vector2(new_zoom, new_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = max(camera.zoom.x - zoom_speed, min_zoom)
			camera.zoom = Vector2(new_zoom, new_zoom)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
	
	# Pan avec clic molette
	if event is InputEventMouseMotion and is_panning:
		camera.position -= event.relative / camera.zoom

func _on_context_menu_pressed(id):
	if id == 0:
		spawn_token(right_click_world_pos)

func spawn_token(world_pos):
	token_count += 1
	var token = Sprite2D.new()
	token.name = "Token" + str(token_count)
	token.set_script(token_scene)
	
	var grid_origin = $MapArea/MapViewportContainer/MapViewport/GridOverlay.position
	var relative_pos = world_pos - grid_origin
	var cell_size = 70
	var snapped = Vector2(
		round(relative_pos.x / cell_size) * cell_size + cell_size / 2,
		round(relative_pos.y / cell_size) * cell_size + cell_size / 2
	)
	token.position = snapped + grid_origin
	
	$MapArea/MapViewportContainer/MapViewport.add_child(token)
