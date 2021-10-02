extends Node2D

func _ready() -> void:
	var maze: Node2D
	if $MazeSquare.visible:
		maze = $MazeSquare
	elif $MazeHexagon.visible:
		maze = $MazeHexagon
	
	if maze:
		maze.generate_maze()
#		$Camera.position = (maze.size * 2 + Vector2.ONE) * maze.get_node("TileMap").cell_size / 2
