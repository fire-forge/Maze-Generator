extends Node
class_name Maze

var cells: = []
var grid: = []
var dead_end_cells: = []
var rng: RandomNumberGenerator

export var size: = Vector2(15, 15)
export var generation_seed: int

# Override variables
var tile_size: = Vector2.ZERO

#   CLASSES   #

class Cell:
	var position: Vector2
	var sides: int
	var side_walls: = []
	var visited: = false
	var dead_end: = true
	
	func _init(sides_amount: int) -> void:
		sides = sides_amount
		for i in sides:
			side_walls.append(true)

#   BUILT-IN   #

func _ready() -> void:
	# Seed and RandomNumberGenerator
	if generation_seed == 0:
		generation_seed = randi()
	rng = RandomNumberGenerator.new()
	rng.seed = generation_seed

#   FUNCTIONS   #

func generate_maze() -> void:
	create_cell_grid()
	
	# Maze generation
	var unchecked_cells: = cells.duplicate()
	while unchecked_cells.size() > 0:
		var cell: Cell = unchecked_cells.back()
		cell.visited = true
		
		var direction_positions: = get_direction_positions(cell)
		var opposite_directions: = get_opposite_directions(cell)
		
		# Search for non-visited neighbors
		var neighbors: = []
		for direction in cell.sides:
			var other_cell: Cell = get_cell(cell.position + direction_positions[direction])
			
			if other_cell and not other_cell.visited:
				neighbors.append({"direction": direction, "cell": other_cell})
		
		if neighbors.size() > 0:
			var neighbor: Dictionary = neighbors[rng.randi() % neighbors.size()]
			var neighbor_direction: int = neighbor.direction
			var neighbor_cell: Cell = neighbor.cell
			
			# Delete side between cells
			cell.side_walls[neighbor_direction] = false
			neighbor_cell.side_walls[opposite_directions[neighbor_direction]] = false
			
			unchecked_cells.append(neighbor_cell)
			cell.dead_end = false
		else:
			unchecked_cells.remove(unchecked_cells.size() - 1)
			
			if cell.dead_end:
				dead_end_cells.append(cell)
	
	create_entrance_and_exit()
	visualize_maze()

#   OVERRIDE FUNCTIONS   #

func create_entrance_and_exit() -> void:
	pass

func get_direction_positions(cell: Cell) -> Array:
	return [cell]

func get_opposite_directions(cell: Cell) -> Array:
	return [cell]

func visualize_maze() -> void:
	pass

#   OVERRIDE FUNCTIONS WITH DEFAULTS   #

func create_cell_grid() -> void:
	for x in size.x:
		grid.append([])
		for y in size.y:
			var position: = Vector2(x, y)
			var cell: = Cell.new(get_cell_sides(position))
			cell.position = position
			grid[x].append(cell)
			cells.append(cell)

# warning-ignore:unused_argument
func get_cell_sides(position: Vector2) -> int:
	if "CELL_SIDES" in self:
		return self.CELL_SIDES
	else:
		return 0

func get_cell(position: Vector2) -> Cell:
	if position.x < 0 or position.x >= size.x or position.y < 0 or position.y >= size.y:
		return null
	else:
		return grid[position.x][position.y]

func get_extents() -> Vector2:
	return size * tile_size
