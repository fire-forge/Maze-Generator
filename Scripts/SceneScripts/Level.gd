extends Node2D

func _ready() -> void:
	var maze: Maze
	if $MazeSquare.visible:
		maze = $MazeSquare
	elif $MazeHexagon.visible:
		maze = $MazeHexagon
	elif $MazeTriangle.visible:
		maze = $MazeTriangle
	elif $MazeOctagon.visible:
		maze = $MazeOctagon
	
	if maze:
		maze.generate_maze()
		$Camera.position = maze.get_extents() / 2
