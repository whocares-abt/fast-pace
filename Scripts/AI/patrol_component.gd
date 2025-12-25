extends Node2D

var patrol_speed
@onready var patrol_start = $PatrolStart

var initial_transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_transform = global_transform

func _process(_delta: float) -> void:
	patrol_start.global_transform = initial_transform

func get_patrol_start():
	return patrol_start
