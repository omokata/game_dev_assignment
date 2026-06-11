extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var player_camera: Camera3D = $Player/Camera3D
@onready var riri_antagonist: CharacterBody3D = $Enemy_Floor_1/RiriAntagonist
@onready var enemy_patrol_chase_component: EnemyPatrolChaseComponent = $Enemy_Floor_1/EnemyPatrolChaseComponent
@onready var enemy_2_patrol_chase_component: EnemyPatrolChaseComponent = $Enemy2_Floor_1/EnemyPatrolChaseComponent
@onready var floor_2_enemy_patrol_chase_component: EnemyPatrolChaseComponent = $Enemy_Floor_2/EnemyPatrolChaseComponent
@onready var break_in_sound: AudioStreamPlayer3D = $Enemy_Floor_1/BreakInSound
@onready var locked_door_sound: AudioStreamPlayer = $LockedDoorSound
@onready var enemy_floor_1: Node3D = $Enemy_Floor_1
@onready var enemy_2_floor_1: Node3D = $Enemy2_Floor_1
@onready var enemy_floor_2: Node3D = $Enemy_Floor_2
@onready var crowbar_interactable: Interactable = $CrowbarProp/Interactable
@onready var crowbar_seen_target: CollisionShape3D = $CrowbarProp/Interactable/CollisionShape3D
@onready var key_interactable: Interactable = $key_prop/Interactable
@onready var exit_interactable: Interactable = $ExitDoor/Interactable
@onready var exit_seen_target: CollisionShape3D = $ExitDoor/Interactable/CollisionShape3D
@onready var crowbar_door_1_interactable: Interactable = $Doors/Crowbar_Door_1/Interactable
@onready var crowbar_door_2_interactable: Interactable = $Doors/Crowbar_Door2/Interactable

@export var exit_seen_distance := 120.0

const CROWBAR_DOOR_LOCK_ITEM := "__exit_first"

var dialog: Dictionary = {
	"dialog_1": "I managed to sneak into this 'dewan', but I need to get out of here.",
	"dialog_2": "What was that sound? Sounds like it's coming from the left.",
	"dialog_exit_seen": "I saw the exit! I need to go there",
	"dialog_exit_locked": "Uhh I need a key.",
	"dialog_enemy_guarding": "Why is he there? Is he guarding something? I need to check out that place.",
	"dialog_crowbar_seen": "Crowbar! Come to think of it, there are rooms with planks attached, maybe those rooms have keys.",
	"dialog_key_picked": "I can finally escape! I have to be careful just in case he's guarding the door.",
	"dialog_go_exit_first": "I can't waste time going in there, I need to go to the exit first."
}

var player_was_captured := false
var saw_exit := false
var tried_locked_exit := false
var saw_crowbar := false
var opening_dialog_finished := false
var dialog_token := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.activate_cam(true)
	player.set_can_move(false)
	_connect_enemy_capture(enemy_patrol_chase_component)
	_connect_enemy_capture(enemy_2_patrol_chase_component)
	_connect_enemy_capture(floor_2_enemy_patrol_chase_component)
	crowbar_interactable.interacted.connect(_on_crowbar_picked)
	key_interactable.interacted.connect(_on_key_picked)
	_set_crowbar_doors_locked(true)
	_set_enemy_group_active(enemy_2_floor_1, false)
	_set_enemy_group_active(enemy_floor_2, false)
	_play_start_dialog()

func _process(_delta: float) -> void:
	if not opening_dialog_finished:
		return
	_check_crowbar_door_blocked_attempt()
	if saw_exit:
		_check_locked_exit_attempt()
		_check_crowbar_seen()
	elif _can_player_see_exit():
		_on_exit_seen()

func _on_player_captured() -> void:
	if player_was_captured:
		return
	player_was_captured = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.jumpscare_requested.emit()
	
	#SignalBus.main_menu_requested.emit()

func _connect_enemy_capture(component: EnemyPatrolChaseComponent) -> void:
	if component and not component.player_captured.is_connected(_on_player_captured):
		component.player_captured.connect(_on_player_captured)

func _on_crowbar_picked(_actor: Node, _interactable: Interactable) -> void:
	if is_instance_valid(enemy_floor_1):
		enemy_floor_1.queue_free()
	if is_instance_valid(enemy_2_floor_1):
		enemy_2_floor_1.queue_free()

func _on_key_picked(_actor: Node, _interactable: Interactable) -> void:
	_set_enemy_group_active(enemy_floor_2, true)
	_play_key_picked_dialog()

func _on_exit_seen() -> void:
	saw_exit = true
	_play_exit_seen_dialog()

func _can_player_see_exit() -> bool:
	return _can_player_see_interactable(exit_seen_target, exit_interactable)

func _check_locked_exit_attempt() -> void:
	if tried_locked_exit:
		return
	if not Input.is_action_just_pressed("interact"):
		return
	if player.has_inventory_item("key"):
		return
	if _can_player_see_interactable(exit_seen_target, exit_interactable):
		_on_locked_exit_attempted()

func _check_crowbar_seen() -> void:
	if saw_crowbar or not tried_locked_exit:
		return
	if _can_player_see_interactable(crowbar_seen_target, crowbar_interactable):
		saw_crowbar = true
		_show_timed_dialog(dialog["dialog_crowbar_seen"], 4.0)

func _check_crowbar_door_blocked_attempt() -> void:
	if tried_locked_exit:
		return
	if not Input.is_action_just_pressed("interact"):
		return
	var hit := _get_camera_interactable_hit()
	if hit == crowbar_door_1_interactable or hit == crowbar_door_2_interactable:
		_show_timed_dialog(dialog["dialog_go_exit_first"], 3.0)

func _get_camera_interactable_hit() -> Interactable:
	var ray_start := player_camera.global_position
	var ray_end := ray_start + (-player_camera.global_transform.basis.z * 3.0)
	var exclude: Array[RID] = [player.get_rid()]
	var params := PhysicsRayQueryParameters3D.create(ray_start, ray_end, 0xFFFFFFFF, exclude)
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var result := get_viewport().world_3d.direct_space_state.intersect_ray(params)
	if result.is_empty() or not result.collider is Interactable:
		return null
	return result.collider

func _can_player_see_interactable(target_shape: CollisionShape3D, target_interactable: Interactable) -> bool:
	var target_pos := target_shape.global_position
	if player_camera.global_position.distance_to(target_pos) > exit_seen_distance:
		return false
	if not player_camera.is_position_in_frustum(target_pos):
		return false
	var exclude: Array[RID] = [player.get_rid()]
	var params := PhysicsRayQueryParameters3D.create(player_camera.global_position, target_pos, 0xFFFFFFFF, exclude)
	params.collide_with_areas = true
	params.collide_with_bodies = true
	var result := get_viewport().world_3d.direct_space_state.intersect_ray(params)
	if result.is_empty():
		return false
	return result.collider == target_interactable or result.collider == target_interactable.get_parent()

func _on_locked_exit_attempted() -> void:
	tried_locked_exit = true
	_set_crowbar_doors_locked(false)
	locked_door_sound.play()
	_play_locked_exit_sequence()

func _set_crowbar_doors_locked(is_locked: bool) -> void:
	var required_item := CROWBAR_DOOR_LOCK_ITEM if is_locked else ""
	crowbar_door_1_interactable.required_item = required_item
	crowbar_door_2_interactable.required_item = required_item

func _set_enemy_group_active(enemy_group: Node3D, is_active: bool) -> void:
	if not is_instance_valid(enemy_group):
		return
	enemy_group.visible = is_active
	enemy_group.process_mode = Node.PROCESS_MODE_INHERIT if is_active else Node.PROCESS_MODE_DISABLED
	_set_collision_shapes_disabled(enemy_group, not is_active)

func _set_collision_shapes_disabled(node: Node, is_disabled: bool) -> void:
	for child in node.get_children():
		if child is CollisionShape3D:
			child.disabled = is_disabled
		_set_collision_shapes_disabled(child, is_disabled)

func _play_exit_seen_dialog() -> void:
	_show_timed_dialog(dialog["dialog_exit_seen"], 2.5)

func _play_locked_exit_sequence() -> void:
	await _show_timed_dialog(dialog["dialog_exit_locked"], 2.0)
	if not is_inside_tree():
		return
	_set_enemy_group_active(enemy_2_floor_1, true)
	if is_instance_valid(enemy_floor_1):
		enemy_floor_1.queue_free()
	await _show_timed_dialog(dialog["dialog_enemy_guarding"], 4.0)

func _play_key_picked_dialog() -> void:
	_show_timed_dialog(dialog["dialog_key_picked"], 4.0)

func _show_timed_dialog(text: String, duration: float) -> void:
	dialog_token += 1
	var current_token := dialog_token
	player.show_dialog(text)
	await get_tree().create_timer(duration).timeout
	if not is_inside_tree() or current_token != dialog_token:
		return
	player.hide_dialog()

func _play_start_dialog() -> void:
	await get_tree().create_timer(1.5).timeout
	if not is_inside_tree():
		return
	player.show_dialog(dialog["dialog_1"])
	await get_tree().create_timer(3.0).timeout
	if not is_inside_tree():
		return
	player.hide_dialog()
	break_in_sound.play()
	await get_tree().create_timer(1.0).timeout
	if not is_inside_tree():
		return
	player.show_dialog(dialog["dialog_2"])
	await get_tree().create_timer(3.0).timeout
	if not is_inside_tree():
		return
	player.hide_dialog()
	opening_dialog_finished = true
	player.set_can_move(true)
