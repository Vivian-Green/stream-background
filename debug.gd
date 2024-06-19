extends Node2D

var last = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Engine.get_frames_per_second() != last:
		last = Engine.get_frames_per_second()
		print(str(Engine.get_frames_per_second()) + " fps")
