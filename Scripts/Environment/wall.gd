extends Node2D

@onready var polygon = $Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationSignalBus.emit_signal("polygon_added", polygon, transform)
