extends Camera2D

var zoom_speed := 0.1
var min_zoom := 0.2
var max_zoom := 3.0
var is_panning := false

func _ready():
	zoom = Vector2(1, 1)

func _unhandled_input(event):
	# Zoom avec la molette
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var new_zoom = min(zoom.x + zoom_speed, max_zoom)
			zoom = Vector2(new_zoom, new_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var new_zoom = max(zoom.x - zoom_speed, min_zoom)
			zoom = Vector2(new_zoom, new_zoom)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
	
	# Pan avec clic molette
	if event is InputEventMouseMotion and is_panning:
		position -= event.relative / zoom

func _process(_delta):
	pass
