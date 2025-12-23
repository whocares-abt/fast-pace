extends Control

@onready var health_bar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatSignalBus.connect("player_health_updated", update_health)

func update_health(new_health, max_health):
	health_bar.update_health(new_health, max_health)
