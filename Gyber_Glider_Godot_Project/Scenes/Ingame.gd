extends Control

export (PackedScene) var Platform

var fallspeed = 200
var falloffset = 0

#offsets for the grid; y_offset is variable (platforms fall), thats why we need
#to remember the initial y offset
var x_offset = 140
var y_offset = 20

#-------------------------------------------------------------------------------
func _ready():
	randomize()

func _process(delta):
	falloffset += fallspeed*delta
	if falloffset > 200:
		falloffset -= 200
		spawn_platforms()

func spawn_platforms():
	var spawn = "SpawnPos" + String(randi()%5)
	var platform = Platform.instance()
	platform.position = $SpawnPositions.get_node(spawn).position
	$Platforms.add_child(platform)

func get_y_offset():
	return y_offset + falloffset
