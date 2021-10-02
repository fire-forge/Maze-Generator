extends Maze

const OPPOSITE_DIRECTIONS_OCTAGON: = [2, 5, 3, 7, 0, 1, 1, 3]
const OPPOSITE_DIRECTIONS_SQUARE: = [4, 6, 0, 2]
const DIRECTION_POSITIONS_OCTAGON: = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]
const DIRECTION_POSITIONS_SQUARE: = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]

onready var shapes: = $Shapes as Node2D
onready var octagon_template: = $Octagon as Node2D
onready var square_template: = $Square as Node2D

#   BUILT-IN   #

func _ready() -> void:
	tile_size = Vector2(10, 10)
	
	octagon_template.visible = false
	square_template.visible = false

#   OVERRIDE FUNCTIONS   #

func create_entrance_and_exit() -> void:
	grid[0][0].side_walls[0] = false # Entrance
	
	var exit_cell: Cell = grid.back().back()
	if exit_cell.sides == 8:
		exit_cell.side_walls[4] = false
	else:
		exit_cell.side_walls[2] = false

func get_direction_positions(cell: Cell) -> Array:
	if cell.sides == 8:
		return DIRECTION_POSITIONS_OCTAGON
	else:
		return DIRECTION_POSITIONS_SQUARE

func get_opposite_directions(cell: Cell) -> Array:
	if cell.sides == 8:
		return OPPOSITE_DIRECTIONS_OCTAGON
	else:
		return OPPOSITE_DIRECTIONS_SQUARE

func get_cell_sides(position: Vector2) -> int:
	if is_cell_octagon(position):
		return 8
	else:
		return 4

func visualize_maze() -> void:
	for v in cells:
		var cell: Cell = v
		
		var shape: Node2D
		if cell.sides == 8:
			shape = octagon_template.duplicate()
		else:
			shape = square_template.duplicate()
		shape.visible = true
		shape.position = cell.position * tile_size
		
		for direction in cell.sides:
			shape.get_node(String(direction)).visible = cell.side_walls[direction]
		
		shape.name = String(cell.position)
		shapes.add_child(shape)

#   FUNCTIONS   #

func is_cell_octagon(position: Vector2) -> bool:
	var x: = int(position.x)
	var y: = int(position.y)
	
	if x % 2 == 0:
		return y % 2 != 0
	else:
		return y % 2 == 0
