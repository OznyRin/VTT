extends Control

var zoom_speed := 0.1
var min_zoom := 0.2
var max_zoom := 3.0
var is_panning := false
var right_click_world_pos := Vector2.ZERO
var token_scene := preload("res://scripts/token.gd")
var token_count := 0
var right_click_token = null
var fog_mode := false

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
	$NavBar/HBoxContainer/BtnHome.add_theme_font_size_override("font_size", 20)
	
	$NavBar/HBoxContainer/TableName.add_theme_color_override("font_color", Color("#F0EDE8"))
	$NavBar/HBoxContainer/TableName.add_theme_font_size_override("font_size", 18)
	
	# Chat Panel
	var chat_style = StyleBoxFlat.new()
	chat_style.bg_color = Color("#252525")
	chat_style.border_color = Color("#3A3A3A")
	chat_style.border_width_left = 1
	$ChatPanel.add_theme_stylebox_override("panel", chat_style)
	
	$ChatPanel/ChatVBox/ChatTitle.add_theme_color_override("font_color", Color("#F0EDE8"))
	$ChatPanel/ChatVBox/ChatTitle.add_theme_font_size_override("font_size", 18)
	
	var input_style = StyleBoxFlat.new()
	input_style.bg_color = Color("#383838")
	input_style.border_color = Color("#4A4A4A")
	input_style.border_width_top = 1
	input_style.border_width_bottom = 1
	input_style.border_width_left = 1
	input_style.border_width_right = 1
	$ChatPanel/ChatVBox/ChatInput.add_theme_stylebox_override("panel", input_style)
	
	# Toolbar
	var toolbar_style = StyleBoxFlat.new()
	toolbar_style.bg_color = Color("#1A1A1A")
	toolbar_style.border_color = Color("#3A3A3A")
	toolbar_style.border_width_top = 1
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
	
	# Positionner le fog of war comme la grille
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.position = -map_size / 2
	
	# Navigation
	$NavBar/HBoxContainer/BtnHome.pressed.connect(_on_home_pressed)
	
	# Menu contextuel
	$MapContextMenu.add_item("Ajouter un token", 0)
	$MapContextMenu.id_pressed.connect(_on_context_menu_pressed)
	
	# Style Chat Input
	var input_stylebox = StyleBoxFlat.new()
	input_stylebox.bg_color = Color("#383838")
	input_stylebox.border_color = Color("#4A4A4A")
	input_stylebox.border_width_top = 1
	input_stylebox.border_width_bottom = 1
	input_stylebox.border_width_left = 1
	input_stylebox.border_width_right = 1
	$ChatPanel/ChatVBox/ChatInput/ChatLineEdit.add_theme_stylebox_override("normal", input_stylebox)
	$ChatPanel/ChatVBox/ChatInput/ChatLineEdit.add_theme_color_override("font_color", Color("#F0EDE8"))
	$ChatPanel/ChatVBox/ChatInput/ChatLineEdit.add_theme_color_override("font_placeholder_color", Color("#8A8680"))
	$ChatPanel/ChatVBox/ChatInput/ChatLineEdit.add_theme_font_size_override("font_size", 14)
	
	# Style Chat Log
	$ChatPanel/ChatVBox/ChatLog.add_theme_color_override("default_color", Color("#F0EDE8"))
	$ChatPanel/ChatVBox/ChatLog.add_theme_font_size_override("normal_font_size", 14)
	$ChatPanel/ChatVBox/ChatLog.bbcode_enabled = true
	
	# Fond du ChatLog
	var chatlog_style = StyleBoxFlat.new()
	chatlog_style.bg_color = Color("#2F2F2F")
	chatlog_style.border_color = Color("#3A3A3A")
	chatlog_style.border_width_left = 1
	$ChatPanel/ChatVBox/ChatLog.add_theme_stylebox_override("normal", chatlog_style)
	
	# Connecter le chat
	$ChatPanel/ChatVBox/ChatInput/ChatLineEdit.text_submitted.connect(_on_chat_submitted)
	
	# FileDialog pour la map
	$MapFileDialog.file_selected.connect(_on_map_file_selected)

func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _input(event):
	# Fog of War - clic gauche pour révéler/masquer
	if fog_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cam = $MapArea/MapViewportContainer/MapViewport/Camera
		var vp = $MapArea/MapViewportContainer/MapViewport
		var mpos = event.position
		var vp_size = vp.get_visible_rect().size
		var wpos = cam.get_screen_center_position() + (mpos - vp_size / 2) / cam.zoom
		if event.shift_pressed:
			$MapArea/MapViewportContainer/MapViewport/FogOfWar.cover_cell(wpos)
			if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
				_sync_fog_cover.rpc(wpos)
		else:
			$MapArea/MapViewportContainer/MapViewport/FogOfWar.reveal_cell(wpos)
			if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
				_sync_fog_reveal.rpc(wpos)
		return
	
	# Clic droit menu contextuel
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var camera = $MapArea/MapViewportContainer/MapViewport/Camera
		var viewport = $MapArea/MapViewportContainer/MapViewport
		var mouse_pos = event.position
		var viewport_size = viewport.get_visible_rect().size
		right_click_world_pos = camera.get_screen_center_position() + (mouse_pos - viewport_size / 2) / camera.zoom
		
		# Détecter si un token est sous la souris
		right_click_token = null
		for child in viewport.get_children():
			if child is Sprite2D and child.texture and child.name.begins_with("Token"):
				if right_click_world_pos.distance_to(child.position) < 35:
					right_click_token = child
					break
		
		# Construire le menu selon le contexte
		$MapContextMenu.clear()
		if right_click_token:
			$MapContextMenu.add_item("Supprimer le token", 1)
			$MapContextMenu.add_item("Changer la couleur", 2)
		else:
			$MapContextMenu.add_item("Ajouter un token", 0)
			if fog_mode:
				$MapContextMenu.add_item("Désactiver Fog of War", 4)
			else:
				$MapContextMenu.add_item("Activer Fog of War", 3)
			$MapContextMenu.add_item("Tout révéler", 5)
			$MapContextMenu.add_item("Tout masquer", 6)
			$MapContextMenu.add_item("Changer la carte", 7)
		
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
	elif id == 1:
		if right_click_token:
			var token_name = right_click_token.name
			right_click_token.queue_free()
			right_click_token = null
			if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
				_sync_delete_token.rpc(str(token_name))
	elif id == 2:
		if right_click_token:
			change_token_color(right_click_token)
	elif id == 3:
		fog_mode = true
		add_chat_message("Système", "Fog of War activé — Clic gauche pour révéler, Shift+Clic pour masquer")
	elif id == 4:
		fog_mode = false
		add_chat_message("Système", "Fog of War désactivé")
	elif id == 5:
		$MapArea/MapViewportContainer/MapViewport/FogOfWar.reveal_all()
		add_chat_message("Système", "Toute la carte est révélée")
		if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
			_sync_fog_reveal_all.rpc()
	elif id == 6:
		$MapArea/MapViewportContainer/MapViewport/FogOfWar.cover_all()
		add_chat_message("Système", "Toute la carte est masquée")
		if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
			_sync_fog_cover_all.rpc()
	elif id == 7:
		$MapFileDialog.popup_centered()

@rpc("any_peer", "call_remote", "reliable")
func _sync_delete_token(token_name):
	var token = $MapArea/MapViewportContainer/MapViewport.get_node_or_null(NodePath(token_name))
	if token:
		token.queue_free()

func spawn_token(world_pos):
	token_count += 1
	var token_name = "Token" + str(multiplayer.get_unique_id()) + "_" + str(token_count)
	_do_spawn_token(token_name, world_pos)
	
	if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		_sync_spawn_token.rpc(token_name, world_pos)

@rpc("any_peer", "call_remote", "reliable")
func _sync_spawn_token(token_name, world_pos):
	_do_spawn_token(token_name, world_pos)

func _do_spawn_token(token_name, world_pos):
	var token = Sprite2D.new()
	token.name = token_name
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

func change_token_color(token):
	var colors = [
		Color("#F5A623"),  # orange
		Color("#4CAF50"),  # vert
		Color("#D94444"),  # rouge
		Color("#4A90D9"),  # bleu
		Color("#9B59B6"),  # violet
		Color("#F0EDE8"),  # blanc
	]
	
	var img = token.texture.get_image()
	var current_color = img.get_pixel(30, 30)
	var next_index = 0
	for i in range(colors.size()):
		if current_color.is_equal_approx(colors[i]):
			next_index = (i + 1) % colors.size()
			break
	
	var new_img = Image.create(60, 60, false, Image.FORMAT_RGBA8)
	new_img.fill(colors[next_index])
	var center = Vector2(30, 30)
	for x in range(60):
		for y in range(60):
			if Vector2(x, y).distance_to(center) > 28:
				new_img.set_pixel(x, y, Color(0, 0, 0, 0))
	token.texture = ImageTexture.create_from_image(new_img)

func _on_chat_submitted(text):
	if text.strip_edges() == "":
		return
	
	$ChatPanel/ChatVBox/ChatInput/ChatLineEdit.text = ""
	
	if text.begins_with("/roll ") or text.begins_with("/r "):
		var formula = text.split(" ", true, 1)[1]
		roll_dice(formula)
	else:
		add_chat_message("Vous", text)

func add_chat_message(sender, text):
	$ChatPanel/ChatVBox/ChatLog.append_text("[color=#F5A623]" + sender + ":[/color] " + text + "\n")
	
	# Envoyer aux autres joueurs si en réseau
	if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		_sync_chat_message.rpc(sender, text)

@rpc("any_peer", "call_remote", "reliable")
func _sync_chat_message(sender, text):
	$ChatPanel/ChatVBox/ChatLog.append_text("[color=#F5A623]" + sender + ":[/color] " + text + "\n")

func roll_dice(formula):
	var result = parse_dice_formula(formula)
	if result.has("error"):
		add_chat_message("Système", "[color=#D94444]" + result["error"] + "[/color]")
	else:
		var detail = formula + " = "
		var parts = []
		for roll in result["rolls"]:
			parts.append("[color=#F5A623]" + str(roll) + "[/color]")
		detail += "[" + ", ".join(parts) + "]"
		if result["modifier"] != 0:
			var mod_sign = "+" if result["modifier"] > 0 else ""
			detail += " " + mod_sign + str(result["modifier"])
		detail += " = [color=#F5A623][b]" + str(result["total"]) + "[/b][/color]"
		add_chat_message("Dés", detail)

func parse_dice_formula(formula: String) -> Dictionary:
	formula = formula.strip_edges().to_lower()
	
	var d_pos = formula.find("d")
	if d_pos == -1:
		return {"error": "Formule invalide. Utilisez le format XdY+Z (ex: 2d6+3)"}
	
	var num_dice_str = formula.substr(0, d_pos)
	var num_dice = 1
	if num_dice_str != "":
		if num_dice_str.is_valid_int():
			num_dice = int(num_dice_str)
		else:
			return {"error": "Nombre de dés invalide"}
	
	var after_d = formula.substr(d_pos + 1)
	var modifier = 0
	var faces_str = after_d
	
	var plus_pos = after_d.find("+")
	var minus_pos = after_d.find("-")
	var mod_pos = -1
	
	if plus_pos != -1 and (minus_pos == -1 or plus_pos < minus_pos):
		mod_pos = plus_pos
	elif minus_pos != -1:
		mod_pos = minus_pos
	
	if mod_pos != -1:
		faces_str = after_d.substr(0, mod_pos)
		var mod_str = after_d.substr(mod_pos)
		if mod_str.is_valid_int():
			modifier = int(mod_str)
		else:
			return {"error": "Modificateur invalide"}
	
	if not faces_str.is_valid_int():
		return {"error": "Nombre de faces invalide"}
	
	var faces = int(faces_str)
	
	if num_dice < 1 or num_dice > 100:
		return {"error": "Nombre de dés entre 1 et 100"}
	if faces < 2 or faces > 1000:
		return {"error": "Nombre de faces entre 2 et 1000"}
	
	var rolls = []
	var total = 0
	for i in range(num_dice):
		var roll = randi_range(1, faces)
		rolls.append(roll)
		total += roll
	total += modifier
	
	return {"rolls": rolls, "total": total, "modifier": modifier}

@rpc("any_peer", "call_remote", "reliable")
func _sync_fog_reveal(wpos):
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.reveal_cell(wpos)

@rpc("any_peer", "call_remote", "reliable")
func _sync_fog_cover(wpos):
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.cover_cell(wpos)

@rpc("any_peer", "call_remote", "reliable")
func _sync_fog_reveal_all():
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.reveal_all()

@rpc("any_peer", "call_remote", "reliable")
func _sync_fog_cover_all():
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.cover_all()

func _on_map_file_selected(path):
	var image = Image.load_from_file(path)
	if image == null:
		add_chat_message("Système", "[color=#D94444]Erreur : impossible de charger l'image[/color]")
		return
	
	var texture = ImageTexture.create_from_image(image)
	$MapArea/MapViewportContainer/MapViewport/MapSprite.texture = texture
	
	# Repositionner la grille et le fog
	var map_size = texture.get_size()
	$MapArea/MapViewportContainer/MapViewport/GridOverlay.position = -map_size / 2
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.position = -map_size / 2
	
	# Recentrer la caméra
	$MapArea/MapViewportContainer/MapViewport/Camera.position = Vector2.ZERO
	$MapArea/MapViewportContainer/MapViewport/Camera.zoom = Vector2(1, 1)
	
	# Reset le fog
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.cover_all()
	
	add_chat_message("Système", "Nouvelle carte chargée")
	
	# Synchroniser avec les autres joueurs
	if multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		var img_data = image.save_png_to_buffer()
		_sync_map_change.rpc(img_data)

@rpc("any_peer", "call_remote", "reliable")
func _sync_map_change(img_data):
	var image = Image.new()
	image.load_png_from_buffer(img_data)
	var texture = ImageTexture.create_from_image(image)
	$MapArea/MapViewportContainer/MapViewport/MapSprite.texture = texture
	
	var map_size = texture.get_size()
	$MapArea/MapViewportContainer/MapViewport/GridOverlay.position = -map_size / 2
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.position = -map_size / 2
	$MapArea/MapViewportContainer/MapViewport/Camera.position = Vector2.ZERO
	$MapArea/MapViewportContainer/MapViewport/Camera.zoom = Vector2(1, 1)
	$MapArea/MapViewportContainer/MapViewport/FogOfWar.cover_all()
	
	add_chat_message("Système", "Nouvelle carte chargée par le MJ")
