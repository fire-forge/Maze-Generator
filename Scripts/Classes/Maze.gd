extends Node
class_name Maze

var cells: = []
var grid: = []
var dead_end_cells: = []
var rng: RandomNumberGenerator

var size: = Vector2(15, 15)
var sides: = 0
var generation_seed: int

#   CLASSES   #

class Cell:
	var position: Vector2
#	var sides_amount: int setget set_sides_amount
	var sides: = []
	var visited: = false
	var dead_end: = true
	
	func _init(sides_amount: int) -> void:
		for i in sides_amount:
			sides.append(true)

#   BUILT-IN   #

func _ready() -> void:
	# Seed and RandomNumberGenerator
	if generation_seed == 0:
		generation_seed = randi()
	rng = RandomNumberGenerator.new()
	rng.seed = generation_seed

#   FUNCTIONS   #

func get_cell(pos: Vector2) -> Cell:
	if pos.x < 0 or pos.x >= size.x or pos.y < 0 or pos.y >= size.y:
		return null
	else:
		return grid[pos.x][pos.y]
