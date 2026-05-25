extends Node

enum SCENE_TYPE {
	WORLD,
	GUI
}

# Global game loops
signal play_game_triggered
signal main_menu_requested
signal quit_game_requested
signal pause_game_requested
signal resume_game_requested
signal change_scene_requested(path: String,
	scene_to_unload_type: SCENE_TYPE, 
	scene_to_load_type: SCENE_TYPE
)
signal objective_finished
