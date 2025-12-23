extends Ability

func _ready() -> void:
	load_stats("res://Resources/Combat/bullet_time.tres")
	activate = activate_bullet_time()

func activate_bullet_time():
	pass
