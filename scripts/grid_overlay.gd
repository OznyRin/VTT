extends Node2D

var cell_size := 70  # taille d'une case en pixels
var grid_color := Color("#F5A623", 0.15)  # orange très transparent
var grid_size := Vector2(50, 50)  # nombre de cases

func _draw():
	for x in range(int(grid_size.x) + 1):
		var from = Vector2(x * cell_size, 0)
		var to = Vector2(x * cell_size, grid_size.y * cell_size)
		draw_line(from, to, grid_color, 1.0)
	
	for y in range(int(grid_size.y) + 1):
		var from = Vector2(0, y * cell_size)
		var to = Vector2(grid_size.x * cell_size, y * cell_size)
		draw_line(from, to, grid_color, 1.0)
