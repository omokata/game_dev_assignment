extends Node
class_name Main

@onready var world: WorldManager = $World
@onready var gui: GUIManager = $GUI

const main_menu_scene = "res://scenes/gui/MainMenu.tscn"
const first_scene = "res://scenes/cutscenes/cutscene_1.tscn"
#const first_scene = "res://scenes/world/test_world.tscn"
const player_menu = "res://scenes/gui/pause_menu.tscn"

func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.play_game_triggered.connect(_on_play_game_triggered)
	SignalBus.change_scene_requested.connect(_on_change_scene_requested)
	SignalBus.quit_game_requested.connect(_on_quit_game_requested)
	SignalBus.pause_game_requested.connect(_on_pause_game_requested)
	SignalBus.resume_game_requested.connect(_on_resume_game_requested)
	SignalBus.main_menu_requested.connect(_on_main_menu_requested)
	# Load main menu first
	gui.load_menu(main_menu_scene)

func _on_quit_game_requested():
	get_tree().quit()

func _on_change_scene_requested(path: String, scene_to_unload_type: SignalBus.SCENE_TYPE,
					scene_to_load_type: SignalBus.SCENE_TYPE):
	gui.reset_fade()
	gui.fade_out()
	if scene_to_unload_type == SignalBus.SCENE_TYPE.WORLD:
		world.unload_current_world()
	elif scene_to_unload_type == SignalBus.SCENE_TYPE.GUI:
		gui.unload_current_menu()
	if scene_to_load_type == SignalBus.SCENE_TYPE.WORLD:
		world.load_world_scene(path)
	elif scene_to_load_type == SignalBus.SCENE_TYPE.GUI:
		gui.load_menu(path)
	gui.fade_in()

func _on_play_game_triggered() -> void:
	gui.reset_fade()
	gui.fade_out()
	gui.unload_current_menu()
	world.load_world_scene(first_scene)
	gui.fade_in()

func _on_pause_game_requested() -> void:
	print("Paused!")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	world.pause_world()
	gui.unload_current_menu()
	gui.load_menu(player_menu)

func _on_resume_game_requested() -> void:
	print("Resume")
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	world.resume_world()
	gui.unload_current_menu()

func _on_main_menu_requested() -> void:
	world.resume_world()
	world.unload_current_world()
	#gui.unload_current_menu()
	gui.load_menu(main_menu_scene)
