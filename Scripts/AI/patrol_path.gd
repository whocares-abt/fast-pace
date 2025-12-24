extends Path2D

@onready var test_sprite = $Sprite2D
@onready var test_sprite_2 = $Sprite2D2

var path_follow_dict : Dictionary[PathFollow2D, float]
# Maps pathfollow2D to patrol speed

@export var patrol_start : Transform2D

func _ready() -> void:
	add_new_patroller(test_sprite, 500)
	add_new_patroller(test_sprite_2, 1000)

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
