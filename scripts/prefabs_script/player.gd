extends Controllable

@export var MAX_SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.0
const WALK_FACTOR = 0.4

var walk_speed: float
var current_speed: float

@onready var interaction_component: InteractionComponent = $InteractionComponent
@onready var player_hud: PlayerHUD = $CanvasLayer/PlayerHud
@onready var inventory_component: InventoryComponent = $InventoryComponent
@onready var item_socket_component: ItemSocketComponent = $ItemSocketComponent
@onready var footstep_sound: AudioStreamPlayer3D = $FootstepSound


func _ready() -> void:
	interaction_component.prompt_updated.connect(player_hud.update_prompt)
	interaction_component.progress_updated.connect(player_hud.update_interaction_progress_bar)
	walk_speed = MAX_SPEED * WALK_FACTOR
	current_speed = walk_speed

func move_actor(direction: Vector3, wants_to_jump: bool, is_sprinting: bool, delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if wants_to_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if is_sprinting:
		current_speed = MAX_SPEED
		footstep_sound.pitch_scale = 1.0
	else:
		current_speed = walk_speed
		footstep_sound.pitch_scale = 0.8
	
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed
	move_and_slide()
	
	if is_on_floor() and direction.length() > 0.1:
		if not footstep_sound.playing:
			footstep_sound.play()
	else:
		if footstep_sound.playing:
			footstep_sound.stop()
	
	# DEBUGGING PURPOSES
	if Input.is_action_just_pressed("debug"):
		SignalBus.change_scene_requested.emit(
			"res://scenes/world/chapter_1_placeholder.tscn",
			SignalBus.SCENE_TYPE.WORLD,
			SignalBus.SCENE_TYPE.WORLD
		)

@export var cam: Camera3D
@export var min_pitch: float = -89.0
@export var max_pitch: float = 89.0

func rotate_actor(mouse_delta: Vector2):
	if not cam:
		return
	cam.rotate_x(-mouse_delta.y * SettingsManager.mouse_sens)
	cam.rotation_degrees.x = clampf(cam.rotation_degrees.x, min_pitch, max_pitch)
	rotate_y(-mouse_delta.x * SettingsManager.mouse_sens)

func activate_cam(is_active: bool):
	if not cam:
		return
	if is_active:
		cam.make_current()
	else:
		cam.current = false

func attach_item(item_to_attach: StaticBody3D):
	item_socket_component.deattach_current_item()
	item_socket_component.attached_item(item_to_attach)

func handle_interaction(_is_holding: bool, _just_pressed: bool, _just_released: bool) -> void:
	var check_inventory_callable = func(item_name: String) -> bool:
		if item_name.is_empty(): return true
		return inventory_component.has_item(item_name)
	
	interaction_component.process_interaction(
		_is_holding,
		_just_pressed,
		_just_released,
		check_inventory_callable,
		get_physics_process_delta_time()
	)

func add_to_inventory(item_name: String):
	inventory_component.add_item(item_name, 1)
