extends Maze

const OPPOSITE_DIRECTIONS: = [3, 4, 5, 0, 1, 2]
const DIRECTION_POSITIONS_EVEN: = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(-1, -1)]
const DIRECTION_POSITIONS_ODD: = [Vector2(0, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0)]
const CELL_SIDES: = 6

onready var hexagons: = $Hexagons as Node2D
onready var hexagon_template: = $Hexagon as Node2D

#   BUILT-IN   #

func _ready() -> void:
	tile_size = Vector2(11, 14)
	
	hexagon_template.visible = false

#   OVERRIDE FUNCTIONS   #

func create_entrance_and_exit() -> void:
	grid[0][0].side_walls[0] = false # Entrance
	grid.back().back().side_walls[3] = false # Exit

func get_direction_positions(cell: Cell) -> Array:
	if int(cell.position.x) % 2 == 0:
		return DIRECTION_POSITIONS_EVEN
	else:
		return DIRECTION_POSITIONS_ODD

func get_opposite_directions(_cell: Cell) -> Array:
	return OPPOSITE_DIRECTIONS

func visualize_maze() -> void:
	for v in cells:
		var cell: Cell = v
		
		var hexagon: = hexagon_template.duplicate()
		hexagon.visible = true
		hexagon.position = cell.position * tile_size
		if int(cell.position.x) % 2 == 1:
			hexagon.position.y += tile_size.y / 2
		
		for direction in cell.sides:
			hexagon.get_node(String(direction)).visible = cell.side_walls[direction]
		
		hexagons.add_child(hexagon)
