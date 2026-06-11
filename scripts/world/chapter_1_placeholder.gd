extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var riri_antagonist: CharacterBody3D = $Enemy_Floor_1/RiriAntagonist
@onready var enemy_patrol_chase_component: EnemyPatrolChaseComponent = $Enemy_Floor_1/EnemyPatrolChaseComponent

var dialog: Dictionary = {
	"dialog_1": "Luckily I sneak into this 'dewan'. But I need to get out of here."
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.activate_cam(true)
	enemy_patrol_chase_component.player_captured.connect(_on_player_captured)
	_play_start_dialog()

func _on_player_captured() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.jumpscare_requested.emit()
	
	#SignalBus.main_menu_requested.emit()

func _play_start_dialog() -> void:
	await get_tree().create_timer(1.5).timeout
	if not is_inside_tree():
		return
	player.show_dialog(dialog["dialog_1"])
	await get_tree().create_timer(3.0).timeout
	if not is_inside_tree():
		return
	player.hide_dialog()
