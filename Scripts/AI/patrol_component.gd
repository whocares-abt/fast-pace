extends Path2D

var patrol_speed
@onready var patrol_start = $PatrolStart
@onready var path_follow = $PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	path_follow.progress += patrol_speed*delta

func start_patrol():
	path_follow.progress = 0

func add_patrollers(nodes):
	for node in nodes:
		node.transform = path_follow.transform
		node.reparent(path_follow)

func get_patrollers():
	var children = []
	for child in path_follow.get_children():
		children.append(child)
	return children

func get_position_in_patrol():
	return path_follow.transform

func update_patrol_path(new_path):
	curve = new_path
	update_patrol_start()

func update_patrol_speed(new_speed):
	patrol_speed = new_speed

func update_patrol_start():
	if (curve == null):
		printerr("No patrol path")
		return 

	patrol_start.position = curve.get_point_position(0)

func get_patrol_start():
	return patrol_start
