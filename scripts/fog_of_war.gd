extends Node2D

var cell_size := 70
var grid_size := Vector2(50, 50)
var fog_color := Color(0, 0, 0, 0.85)
var revealed := {}  # Dictionary de Vector2i -> bool

func _ready():
	# Tout est couvert par défaut
	queue_redraw()

func _draw():
	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			var cell = Vector2i(x, y)
			if not revealed.has(cell):
				var rect = Rect2(x * cell_size, y * cell_size, cell_size, cell_size)
				draw_rect(rect, fog_color)

func reveal_cell(world_pos: Vector2):
	var local_pos = world_pos - position
	var cell = Vector2i(int(local_pos.x / cell_size), int(local_pos.y / cell_size))
	if cell.x >= 0 and cell.x < grid_size.x and cell.y >= 0 and cell.y < grid_size.y:
		# Révéler la case et ses voisines (rayon de 2)
		for dx in range(-2, 3):
			for dy in range(-2, 3):
				var neighbor = Vector2i(cell.x + dx, cell.y + dy)
				if neighbor.x >= 0 and neighbor.x < grid_size.x and neighbor.y >= 0 and neighbor.y < grid_size.y:
					revealed[neighbor] = true
		queue_redraw()

func cover_cell(world_pos: Vector2):
	var local_pos = world_pos - position
	var cell = Vector2i(int(local_pos.x / cell_size), int(local_pos.y / cell_size))
	if cell.x >= 0 and cell.x < grid_size.x and cell.y >= 0 and cell.y < grid_size.y:
		for dx in range(-2, 3):
			for dy in range(-2, 3):
				var neighbor = Vector2i(cell.x + dx, cell.y + dy)
				if revealed.has(neighbor):
					revealed.erase(neighbor)
		queue_redraw()

func reveal_all():
	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			revealed[Vector2i(x, y)] = true
	queue_redraw()

func cover_all():
	revealed.clear()
	queue_redraw()
