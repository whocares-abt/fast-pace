extends Ability

func _ready() -> void:
	load_stats("res://Resources/Combat/bullet_time.tres")
	activate = activate_knife_throw()

func activate_knife_throw():
	pass
