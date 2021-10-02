extends Maze

const DIRECTIONS: = [0, 1, 2, 3, 4, 5]
const OPPOSITE_DIRECTIONS: = [3, 4, 5, 0, 1, 2]
#const DIRECTION_POSITIONS: = {"N": Vector2.UP, "E": Vector2.RIGHT, "S": Vector2.DOWN, "W": Vector2.LEFT}
const DIRECTION_POSITIONS_EVEN: = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(-1, -1)]
const DIRECTION_POSITIONS_ODD: = [Vector2(0, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0)]
#const TILEMAP_TILE_INDEX: = 0
const HEXAGON_SIZE: = Vector2(8, 9) #Vector2(6.5, 8)

#onready var tile_map: = $TileMap as TileMap
onready var hexagons: = $Hexagons as Node2D
onready var hexagon_template: = $Hexagon as Node2D

#   BUILT-IN   #

func _ready() -> void:
	hexagon_template.visible = false

#   FUNCTIONS   #

func generate_maze() -> void:
	# Create grid
	for x in size.x:
		grid.append([])
		for y in size.y:
			var cell: = Cell.new(6)
			cell.position = Vector2(x, y)
			grid[x].append(cell)
			cells.append(cell)
	
	# Maze generation
	var unchecked_cells: = cells.duplicate()
	
	while unchecked_cells.size() > 0:
		var cell: Cell = unchecked_cells.back()
		cell.visited = true
		
		var direction_positions: Array
		if int(cell.position.x) % 2 == 0:
			direction_positions = DIRECTION_POSITIONS_EVEN
		else:
			direction_positions = DIRECTION_POSITIONS_ODD
		
		# Search for non-visited neighbors
		var neighbors: = []
		for direction in DIRECTIONS:
			var other_cell: Cell = get_cell(cell.position + direction_positions[direction])
			
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
#	for x in size.x * 2 + 1:
#		for y in size.y * 2 + 1 + int(x % 2 == 0):
#			tile_map.set_cell(x, y, TILEMAP_TILE_INDEX)
	for v in cells:
		var cell: Cell = v
		
		var hexagon: = hexagon_template.duplicate()
		hexagon.visible = true
		hexagon.position = cell.position * HEXAGON_SIZE
		if int(cell.position.x) % 2 == 1:
			hexagon.position.y += HEXAGON_SIZE.y / 2
		
		for direction in DIRECTIONS:
			if cell.sides[direction] == false:
				hexagon.get_node(String(direction)).visible = false
		
		hexagons.add_child(hexagon)
