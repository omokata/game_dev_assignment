extends Node
class_name PlayerController

var actor: Controllable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor = get_parent() as Controllable
	if not actor:
		push_error("PlayerController need to be a child of Controllable")

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var move_direction = (actor.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var wants_to_jump = Input.is_action_just_pressed("space")
	var is_sprinting = Input.is_action_pressed("shift")
	actor.move_actor(move_direction, false, is_sprinting, delta)
	
	var pressed = Input.is_action_pressed("interact")
	var just_pressed = Input.is_action_just_pressed("interact")
	var just_released = Input.is_action_just_released("interact")
	
	actor.handle_interaction(
		pressed,
		just_pressed,
		just_released
	)
