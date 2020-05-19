extends Control

export (PackedScene) var Platform

var fallspeed = 150
var falloffset = 0

#offsets for the grid; y_offset is variable (platforms fall), thats why we need
#to remember the initial y offset
var x_offset = 140
var y_offset = 20

#-------------------------------------------------------------------------------
func _ready(): #randomize platform spawns
	randomize()


func _draw(): #provisory line to show where tapping zone ends
	draw_line(Vector2(0, 1820), Vector2(1080, 1820), Color(0, 0, 0))


func _process(delta): 
	falloffset += fallspeed*delta #move platforms at fallspeed
	if falloffset > 200: #move grid to platform movement modulo 200
		falloffset -= 200
		spawn_platforms() #spawn new platforms


func platform_dragged(node): #draw snap indicator
	$SnapIndicator.position = node.nearest_snap(node.position)
	


func spawn_platforms():
	var spawn = "SpawnPos" + String(randi()%5)
	var platform = Platform.instance()
	platform.position = $SpawnPositions.get_node(spawn).position
	$Platforms.add_child(platform)


func get_y_offset(): #function for platform object to call
	return y_offset + falloffset
