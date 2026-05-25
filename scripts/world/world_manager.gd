extends Node3D
class_name WorldManager

var current_scene: Node = null

func load_world_scene(scene_path: String) -> void:
	var scene_resource = load(scene_path)
	if scene_resource:
		current_scene = scene_resource.instantiate()
		add_child(current_scene)

func unload_current_world() -> void:
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	current_scene = null

func pause_world() -> void:
	get_tree().paused = true

func resume_world() -> void:
	get_tree().paused = false
