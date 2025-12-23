extends CharacterBody2D

@export var SPEED = 300.0

@onready var weapon = $Weapon

func _ready() -> void:
	weapon.add_hurtbox_owners(["Player"])
	weapon.equip_weapon("pistol")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("attack")):
		var mouse_pos = get_global_mouse_position()
		var mouse_to_player = mouse_pos - position

		weapon.attack(mouse_to_player.normalized())

func _physics_process(_delta: float) -> void:

	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _on_hitbox_hurtbox_entered(area: Variant) -> void:
	if ("Enemy" in area.hurtbox_owners):
		self.queue_free()
