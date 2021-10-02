extends Maze

#const DIRECTIONS: = ["N", "E", "S", "W"]
#const OPPOSITE_DIRECTIONS: = {"N": "S", "E": "W", "S": "N", "W": "E"}
#const DIRECTION_POSITIONS: = {"N": Vector2.UP, "E": Vector2.RIGHT, "S": Vector2.DOWN, "W": Vector2.LEFT}
const DIRECTIONS: = [0, 1, 2, 3]
const OPPOSITE_DIRECTIONS: = [2, 3, 0, 1]
const DIRECTION_POSITIONS: = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]
const TILEMAP_TILE_INDEX: = 0

onready var tile_map: = $TileMap as TileMap

#   BUILT-IN   #

#func _ready() -> void:
#	generate_maze()

#   FUNCTIONS   #

func generate_maze() -> void:
	# Create grid
	for x in size.x:
		grid.append([])
		for y in size.y:
			var cell: = Cell.new(4)
			cell.position = Vector2(x, y)
			grid[x].append(cell)
			cells.append(cell)
	
	# Maze generation
	var unchecked_cells: = cells.duplicate()
	
	while unchecked_cells.size() > 0:
		var cell: Cell = unchecked_cells.back()
		cell.visited = true
		
		# Search for non-visited neighbors
		var neighbors: = []
		for direction in DIRECTIONS:
			var other_cell: Cell = get_cell(cell.position + DIRECTION_POSITIONS[direction])
			
			if other_cell and not other_cell.visited:
				neighbors.append({"direction": direction, "cell": other_cell})
		
		if neighbors.size() > 0:
			var neighbor: Dictionary = neighbors[rng.randi() % neighbors.size()]
			var neighbor_direction: int = neighbor.direction
			var neighbor_cell: Cell = neighbor.cell
			
			# Delete side between cells
			cell.sides[neighbor_direction] = false
			neighbor_cell.sides[OPPOSITE_DIRECTIONS[neighbor_direction]] = false
			
			unchecked_cells.append(neighbor_cell)
			cell.dead_end = false
		else:
			unchecked_cells.remove(unchecked_cells.size() - 1)
			
			if cell.dead_end:
				dead_end_cells.append(cell)
	
	# TileMap
	for x in size.x * 2 + 1:
		for y in size.y * 2 + 1:
			tile_map.set_cell(x, y, TILEMAP_TILE_INDEX)
	for v in cells:
		var cell: Cell = v
		var tile_position: = cell.position * 2 + Vector2.ONE
		tile_map.set_cellv(tile_position, -1)
		
		for direction in DIRECTIONS:
			if cell.sides[direction] == false:
				tile_map.set_cellv(tile_position + DIRECTION_POSITIONS[direction], -1)
