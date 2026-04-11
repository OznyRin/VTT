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
	
	# Style contenu
	$Content/Title.add_theme_font_size_override("font_size", 36)
	$Content/Title.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	$Content/IPRow/IPLabel.add_theme_color_override("font_color", Color("#F0EDE8"))
	$Content/PortRow/PortLabel.add_theme_color_override("font_color", Color("#F0EDE8"))
	
	var edit_style = StyleBoxFlat.new()
	edit_style.bg_color = Color("#2F2F2F")
	edit_style.border_color = Color("#4A4A4A")
	edit_style.border_width_bottom = 1
	edit_style.corner_radius_top_left = 6
	edit_style.corner_radius_top_right = 6
	edit_style.corner_radius_bottom_left = 6
	edit_style.corner_radius_bottom_right = 6
	$Content/IPRow/IPEdit.add_theme_stylebox_override("normal", edit_style)
	$Content/IPRow/IPEdit.add_theme_color_override("font_color", Color("#F0EDE8"))
	$Content/IPRow/IPEdit.add_theme_color_override("font_placeholder_color", Color("#8A8680"))
	$Content/IPRow/IPEdit.custom_minimum_size = Vector2(250, 40)
	
	$Content/PortRow/PortSpin.value = 9050
	$Content/PortRow/PortSpin.min_value = 1024
	$Content/PortRow/PortSpin.max_value = 65535
	
	$Content/Status.add_theme_font_size_override("font_size", 18)
	
	# Bouton
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = Color("#F5A623")
	btn_style.corner_radius_top_left = 8
	btn_style.corner_radius_top_right = 8
	btn_style.corner_radius_bottom_left = 8
	btn_style.corner_radius_bottom_right = 8
	var btn_hover = btn_style.duplicate()
	btn_hover.bg_color = Color("#E8932A")
	$Content/BtnJoin.add_theme_stylebox_override("normal", btn_style)
	$Content/BtnJoin.add_theme_stylebox_override("hover", btn_hover)
	$Content/BtnJoin.add_theme_stylebox_override("pressed", btn_hover)
	$Content/BtnJoin.add_theme_color_override("font_color", Color("#1A1A1A"))
	$Content/BtnJoin.custom_minimum_size = Vector2(250, 50)
	
	$Content/BtnJoin.pressed.connect(_on_join_pressed)
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_join_pressed():
	var ip = $Content/IPRow/IPEdit.text.strip_edges()
	if ip == "":
		$Content/Status.text = "Entrez une adresse IP"
		$Content/Status.add_theme_color_override("font_color", Color("#D94444"))
		return
	
	var port = int($Content/PortRow/PortSpin.value)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, port)
	
	if error != OK:
		$Content/Status.text = "Erreur de connexion"
		$Content/Status.add_theme_color_override("font_color", Color("#D94444"))
		return
	
	multiplayer.multiplayer_peer = peer
	$Content/Status.text = "Connexion en cours..."
	$Content/Status.add_theme_color_override("font_color", Color("#F5A623"))
	$Content/BtnJoin.disabled = true
	
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_connected():
	$Content/Status.text = "Connecté ! Lancement de la table..."
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_table.tscn")

func _on_connection_failed():
	$Content/Status.text = "Connexion échouée — vérifiez l'IP et le port"
	$Content/Status.add_theme_color_override("font_color", Color("#D94444"))
	$Content/BtnJoin.disabled = false
