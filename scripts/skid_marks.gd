extends Line2D

var queue : Array = []
var MAX_LENGTH : int = 50

func _process(delta):
	mouse_control()
	
func mouse_control():
	var pos = get_global_mouse_position()
	
	queue.push_front(pos)
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)
