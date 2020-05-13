extends Area2D

#this bit is necessary for correcting the mouse pos for different resolutions
#because we are using a control node as root node
onready var screensize = get_viewport().get_size_override()
onready var xover = (screensize.x - 1080)/2
onready var yover = screensize.y - 1920
var raw_mousepos
var mousepos

var tween_duration = 0.05

#offsets for the grid; y_offset is variable (platforms fall), thats why we need
#to remember the initial y offset
var x_offset = 140
var y_offset = 20

#if true, this platform is being dragged around at the moment
onready var dragging: bool = false

#-------------------------------------------------------------------------------

func _process(delta):
	#move platform at fallspeed
	position.y += $"/root/Ingame".fallspeed*delta
	
	if dragging:
			#uncomment 3 lines bellow for testing with resizing while the game 
			#is running
		#screensize = get_viewport().get_size_override()
		#xover = (screensize.x - 1080)/2
		#yover = screensize.y - 1920 
		
		#correct mouse position
		raw_mousepos = get_global_mouse_position()
		mousepos = Vector2(raw_mousepos.x - xover, raw_mousepos.y - yover)
		var snap = nearest_snap(mousepos)
		
		position = mousepos


#transforming coordinates to the nearest position to snap to (snap to grid)
func nearest_snap(pos):
	var y_tmp_offset = y_offset + $"/root/Ingame".falloffset
	var snap = Vector2()
	snap.x = round((pos.x - x_offset)/200) * 200  + x_offset
	snap.y = round((pos.y - y_tmp_offset)/200) * 200  + y_tmp_offset
	return snap


#enter dragging mode if finger is placed on platform
func _platform_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			dragging = true


#exit dragging mode if finger is released and snap to the grid
func _input(event):
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			dragging = false
			$tween.interpolate_property(self, "position", position, 
					nearest_snap(position), tween_duration, Tween.TRANS_LINEAR)
			$tween.start()


func _screen_exited():
	queue_free()
