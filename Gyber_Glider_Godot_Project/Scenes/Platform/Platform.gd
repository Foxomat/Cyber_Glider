extends KinematicBody2D

#this bit is necessary for correcting the mouse pos for different resolutions
#because we are using a control node as root node
onready var screensize = get_viewport().get_size_override()
onready var xover = (screensize.x - 1080)/2
onready var yover = screensize.y - 1920

var tween_duration = 0.02
var platform_move_multi = 20

#offsets for the grid; y_offset is variable (platforms fall), thats why we need
#to remember the initial y offset
onready var x_offset = $"/root/Ingame".x_offset
var y_offset = 20

#if true, this platform is being dragged around at the moment
onready var dragging: bool = false

#for snap indicator
signal being_dragged
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
		var raw_mousepos = get_global_mouse_position()
		var mousepos = Vector2(raw_mousepos.x - xover, raw_mousepos.y - yover)
		var snap = nearest_snap(mousepos)
		emit_signal("being_dragged", self)
				#move the platform
		move_and_slide(platform_move_multi*(mousepos - position))


#transforming coordinates to the nearest position to snap to (snap to grid)
func nearest_snap(pos):
	var y_offset = $"/root/Ingame".get_y_offset()
	var snap = Vector2()
	snap.x = round((pos.x - x_offset)/200) * 200  + x_offset
	snap.y = round((pos.y - y_offset)/200) * 200  + y_offset
	return snap


#enter dragging mode if finger is placed on platform
func _platform_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			connect("being_dragged", get_node("/root/Ingame"), "platform_dragged")
			get_node("/root/Ingame/SnapIndicator").visible = true
			dragging = true


#exit dragging mode if finger is released and snap to the grid
func _input(event):
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			dragging = false
			if is_connected("being_dragged", get_node("/root/Ingame"), "platform_dragged"):
				disconnect("being_dragged", get_node("/root/Ingame"), "platform_dragged")
			get_node("/root/Ingame/SnapIndicator").visible = false
			$tween.interpolate_property(self, "position", position, 
					nearest_snap(position), tween_duration, Tween.TRANS_LINEAR)
			$tween.start()


func _screen_exited():
	queue_free()
