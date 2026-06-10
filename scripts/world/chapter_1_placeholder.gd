extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var riri_antagonist: CharacterBody3D = $Enemy_Floor_1/RiriAntagonist
@onready var enemy_patrol_chase_component: EnemyPatrolChaseComponent = $Enemy_Floor_1/EnemyPatrolChaseComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.activate_cam(true)
	enemy_patrol_chase_component.player_captured.connect(_on_player_captured)

func _on_player_captured() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SignalBus.main_menu_requested.emit()
