extends CharacterBody3D
class_name Controllable
	
func move_actor(direction: Vector3, wants_to_jump: bool, is_sprinting: bool, delta: float):
	pass
	
func rotate_actor(mouse_delta: Vector2):
	pass

func handle_interaction(_is_holding: bool, _just_pressed: bool, _just_released: bool) -> void:
	pass
