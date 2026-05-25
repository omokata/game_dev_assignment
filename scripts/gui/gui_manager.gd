extends CanvasLayer
class_name GUIManager

@onready var fade_effect_rect: ColorRect = $FadeEffectRect
var current_menu: Control = null

func reset_fade():
	fade_effect_rect.color.a = 1.0

func fade(target_alpha: float, duration: float = 1.0):
	var tween: Tween = create_tween()
	tween.tween_property(fade_effect_rect, "color:a", target_alpha, duration)
	return tween

func fade_out(duration: float = 1.0):
	await fade(1.0, duration).finished

func fade_in(duration: float = 1.0):
	await fade(0.0, duration).finished

func load_menu(scene_path: String) -> void:
	var menu_resource = load(scene_path)
	if menu_resource:
		current_menu = menu_resource.instantiate()
		add_child(current_menu)

func unload_current_menu() -> void:
	if is_instance_valid(current_menu):
		current_menu.queue_free()
	current_menu = null
