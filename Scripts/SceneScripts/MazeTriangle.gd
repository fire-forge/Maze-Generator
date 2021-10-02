extends Maze

const OPPOSITE_DIRECTIONS: = [2, 1, 0] # Opposite directions are the same for flipped and non-flipped triangles
const DIRECTION_POSITIONS_DEFAULT: = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]
const DIRECTION_POSITIONS_FLIPPED: = [Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]
const CELL_SIDES: = 3

onready var triangles: = $Triangles as Node2D
onready var triangle_template: = $Triangle as Node2D

#   BUILT-IN   #

func _ready() -> void:
	tile_size = Vector2(7, 14)
	
	triangle_template.visible = false

#   OVERRIDE FUNCTIONS   #

func create_entrance_and_exit() -> void:
	grid[0][0].side_walls[2] = false # Entrance
	grid.back().back().side_walls[0] = false # Exit

func get_direction_positions(cell: Cell) -> Array:
	if is_triangle_flipped(cell.position):
		return DIRECTION_POSITIONS_FLIPPED
	else:
		return DIRECTION_POSITIONS_DEFAULT

func get_opposite_directions(_cell: Cell) -> Array:
	return OPPOSITE_DIRECTIONS

func visualize_maze() -> void:
	# Create triangles
	for v in cells:
		var cell: Cell = v
		
		var triangle: = triangle_template.duplicate()
		triangle.visible = true
		triangle.position = cell.position * tile_size
		if is_triangle_flipped(cell.position):
			triangle.scale.y = -1
		
		for direction in cell.sides:
			triangle.get_node(String(direction)).visible = cell.side_walls[direction]
		
		triangles.add_child(triangle)

#   FUNCTIONS   #

func is_triangle_flipped(position: Vector2) -> bool:
	var x: = int(position.x)
	var y: = int(position.y)
	
	if x % 2 == 0:
		return y % 2 != 0
	else:
		return y % 2 == 0
