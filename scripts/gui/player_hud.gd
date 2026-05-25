extends Control
class_name PlayerHUD

@onready var interaction_progress_bar: ProgressBar = $InteractionProgressBar
@onready var interaction_prompt_label: Label = $InteractionPromptLabel
@onready var crosshair_rect: TextureRect = $CrosshairRect

func _ready() -> void:
	SignalBus.pause_game_requested.connect(_on_game_paused)
	SignalBus.resume_game_requested.connect(_on_game_resumed)
	interaction_progress_bar.visible = false
	interaction_prompt_label.visible = false

func update_prompt(text: String, visible: bool):
	interaction_prompt_label.set_text(text)
	interaction_prompt_label.visible = visible

func update_interaction_progress_bar(value: float, visible: bool):
	interaction_progress_bar.value = value
	interaction_progress_bar.visible = visible

func set_selected_element_visibility(is_visible: bool):
	# Kat sini just hardcode stuff that you want to
	# be visible and invisible when pause or resume
	crosshair_rect.visible = is_visible
	interaction_prompt_label.visible = is_visible
	if interaction_progress_bar.visible:
		interaction_progress_bar.visible = is_visible

func _on_game_paused() -> void:
	# We don't want everything to be visible here
	# Because if we do, on paused, objectives and
	# other will be invisible
	set_selected_element_visibility(false)

func _on_game_resumed() -> void:
	set_selected_element_visibility(true)
