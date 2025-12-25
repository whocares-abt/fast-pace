extends Node2D

@onready var enemies_node = $Enemies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NavigationSignalBus.connect("leaving_patrol", put_enemy_in_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func put_enemy_in_scene(node : Node2D):
	node.reparent(self)
