extends Control

export (PackedScene) var Platform

var fallspeed = 200
var falloffset = 0

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
	platform.position = get_node(spawn).position
	$Platforms.add_child(platform)
