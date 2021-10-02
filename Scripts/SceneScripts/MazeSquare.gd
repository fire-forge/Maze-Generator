extends Maze

const OPPOSITE_DIRECTIONS: = [2, 3, 0, 1]
const DIRECTION_POSITIONS: = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]
const TILEMAP_TILE_INDEX: = 0
const CELL_SIDES: = 4

onready var tile_map: = $TileMap as TileMap

#   BUILT-IN   #

func _ready() -> void:
	tile_size = Vector2(16, 16)

#   OVERRIDE FUNCTIONS   #

func create_entrance_and_exit() -> void:
	grid[0][0].side_walls[0] = false # Entrance
	grid.back().back().side_walls[2] = false # Exit

func get_direction_positions(_cell: Cell) -> Array:
	return DIRECTION_POSITIONS

func get_opposite_directions(_cell: Cell) -> Array:
	return OPPOSITE_DIRECTIONS

func visualize_maze() -> void:
	# TileMap
	for x in size.x * 2 + 1:
		for y in size.y * 2 + 1:
			tile_map.set_cell(x, y, TILEMAP_TILE_INDEX)
	
	for v in cells:
		var cell: Cell = v
		var tile_position: = cell.position * 2 + Vector2.ONE
		tile_map.set_cellv(tile_position, -1)
		
		for direction in cell.sides:
			if cell.side_walls[direction] == false:
				tile_map.set_cellv(tile_position + DIRECTION_POSITIONS[direction], -1)

func get_extents() -> Vector2:
	return size * tile_size + tile_size / 2
