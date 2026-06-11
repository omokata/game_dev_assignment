extends Node3D
class_name InteractionComponent

signal prompt_updated(message: String, is_visible: bool)
signal progress_updated(percent: float, is_visible: bool)

@export var cam_3d : Camera3D
@export var RAY_LENGTH : float = 3.0
@export var desired_layer : int = 2

var exclude_array : Array[RID]
var hold_timer: float = 0.0

func _ready() -> void:
	var parent_body = get_parent()
	if parent_body is CollisionObject3D:
		exclude_array.append(parent_body.get_rid())

func process_interaction(is_holding: bool, just_pressed: bool, just_released: bool, has_required_item: Callable, delta: float) -> void:
	var ray_result: Dictionary = cast_ray()
	
	if ray_result.is_empty():
		_clear_ui()
		return

	var hit = ray_result.collider
	if not hit is Interactable:
		_clear_ui()
		return
		
	var can_interact: bool = has_required_item.call(hit.required_item)
	if not can_interact:
		var blocked_message: String = hit.blocked_prompt_message
		if blocked_message.is_empty():
			blocked_message = "Requires %s" % hit.required_item
		prompt_updated.emit(blocked_message, true)
		progress_updated.emit(0.0, false)
		if just_pressed:
			hit.block_interaction(get_parent())
		return

	prompt_updated.emit(hit.prompt_message, true)

	if not hit.is_hold_interaction and just_pressed:
		hit.interact(get_parent())

	if hit.is_hold_interaction and is_holding:
		hold_timer += delta
		var percentage = (hold_timer / hit.hold_time) * 100.0
		progress_updated.emit(percentage, true)
		
		if hold_timer >= hit.hold_time:
			hit.interact(get_parent())
			progress_updated.emit(0.0, false)
			hold_timer = 0.0

	if just_released:
		hold_timer = 0.0
		progress_updated.emit(0.0, false)

func cast_ray() -> Dictionary:
	var space = get_viewport().world_3d.direct_space_state
	var ray_start = cam_3d.global_position
	var ray_end = ray_start + (-cam_3d.global_transform.basis.z * RAY_LENGTH)
	var target_layer = 1 << (desired_layer - 1)
	
	var params := PhysicsRayQueryParameters3D.create(ray_start, ray_end, target_layer, exclude_array)
	params.collide_with_areas = true
	params.collide_with_bodies = false
	return space.intersect_ray(params)

func _clear_ui() -> void:
	hold_timer = 0.0
	prompt_updated.emit("", false)
	progress_updated.emit(0.0, false)
