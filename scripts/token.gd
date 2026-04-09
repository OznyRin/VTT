extends Sprite2D

var is_dragging := false
var cell_size := 70
var drag_offset := Vector2.ZERO

func _ready():
	var img = Image.create(60, 60, false, Image.FORMAT_RGBA8)
	img.fill(Color("#F5A623"))
	
	var center = Vector2(30, 30)
	for x in range(60):
		for y in range(60):
			if Vector2(x, y).distance_to(center) > 28:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
	
	texture = ImageTexture.create_from_image(img)

func _process(_delta):
	if is_dragging:
		var mouse_pos = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_2d()
		var world_pos = camera.get_screen_center_position() + (mouse_pos - get_viewport().get_visible_rect().size / 2) / camera.zoom
		position = world_pos + drag_offset

func _unhandled_input(event):
	var camera = get_viewport().get_camera_2d()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var mouse_pos = event.position
			var world_pos = camera.get_screen_center_position() + (mouse_pos - get_viewport().get_visible_rect().size / 2) / camera.zoom
			if world_pos.distance_to(position) < 35:
				is_dragging = true
				drag_offset = position - world_pos
		else:
			if is_dragging:
				is_dragging = false
				snap_to_grid()

func snap_to_grid():
	var grid_origin = get_parent().get_node("GridOverlay").position
	var relative_pos = position - grid_origin
	var snapped = Vector2(
		round(relative_pos.x / cell_size) * cell_size + cell_size / 2,
		round(relative_pos.y / cell_size) * cell_size + cell_size / 2
	)
	position = snapped + grid_origin
