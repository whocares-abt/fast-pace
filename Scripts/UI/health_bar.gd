extends TextureProgressBar

func update_health(new_health : float, max_health : float):
	value = (new_health/max_health) * max_value
