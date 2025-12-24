extends Path2D

var path_follow_dict : Dictionary[PathFollow2D, float]
# Maps pathfollow2D to patrol speed

@export var patrol_start : Vector2

func _ready() -> void:
	update_patrol_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for path_follow in path_follow_dict:
		var speed = path_follow_dict[path_follow]
		path_follow.progress += speed * delta

func add_new_patroller(node : Node2D, patrol_speed : float):
	var new_path_follow = create_new_path_follow(patrol_speed)
	node.transform = new_path_follow.transform
	node.reparent(new_path_follow)

func create_new_path_follow(patrol_speed : float):
	var path_follow = PathFollow2D.new()
	add_child(path_follow)
	
	path_follow_dict[path_follow] = patrol_speed
	return path_follow

func remove_patrol_path(patrol_path : PathFollow2D):
	# Remove patrol path if they have no child
	remove_child(patrol_path)

func get_start_point():
	return patrol_start

func update_patrol_start():
	if (curve == null):
		printerr("No patrol path")
		return
		
	patrol_start = curve.get_closest_point(Vector2.ZERO)
