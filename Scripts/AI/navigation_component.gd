extends NavigationAgent2D

var goal : Node2D
@export var time : float = 1
@export var path_recalc_threshold = 10

@onready var nav_timer = $NavTimer

func _ready() -> void:
	debug_enabled = false

func set_goal(new_goal):
	goal = new_goal
	if (goal != null):
		target_position = goal.global_position
	nav_timer.start(time)

func _on_nav_timer_timeout() -> void:
	if (goal == null):
		nav_timer.stop()
		return

	#if (target_position - goal.global_position).length() > path_recalc_threshold:
	target_position = goal.global_position
