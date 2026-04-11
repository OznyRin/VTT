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
	
	$Content/Info.add_theme_color_override("font_color", Color("#8A8680"))
	$Content/Info.add_theme_font_size_override("font_size", 16)
	
	$Content/IPLabel.add_theme_color_override("font_color", Color("#F5A623"))
	$Content/IPLabel.add_theme_font_size_override("font_size", 20)
	
	$Content/PortRow/PortLabel.add_theme_color_override("font_color", Color("#F0EDE8"))
	$Content/PortRow/PortSpin.value = 9050
	$Content/PortRow/PortSpin.min_value = 1024
	$Content/PortRow/PortSpin.max_value = 65535
	
	$Content/Status.add_theme_color_override("font_color", Color("#4CAF50"))
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
	$Content/BtnHost.add_theme_stylebox_override("normal", btn_style)
	$Content/BtnHost.add_theme_stylebox_override("hover", btn_hover)
	$Content/BtnHost.add_theme_stylebox_override("pressed", btn_hover)
	$Content/BtnHost.add_theme_color_override("font_color", Color("#1A1A1A"))
	$Content/BtnHost.custom_minimum_size = Vector2(250, 50)
	
	$Content/BtnHost.pressed.connect(_on_host_pressed)
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_host_pressed():
	var port = int($Content/PortRow/PortSpin.value)
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	
	if error != OK:
		$Content/Status.text = "Erreur : impossible de créer le serveur"
		$Content/Status.add_theme_color_override("font_color", Color("#D94444"))
		return
	
	multiplayer.multiplayer_peer = peer
	$Content/Status.text = "Serveur lancé sur le port " + str(port) + " — En attente de joueurs..."
	$Content/Status.add_theme_color_override("font_color", Color("#4CAF50"))
	$Content/BtnHost.disabled = true
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(id):
	$Content/Status.text = "Joueur connecté ! (ID: " + str(id) + ")"

func _on_peer_disconnected(id):
	$Content/Status.text = "Joueur déconnecté (ID: " + str(id) + ")"
