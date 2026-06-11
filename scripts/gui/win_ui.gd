extends Control

@onready var win_text: TextureRect = $WinText
@onready var lose_text: TextureRect = $LoseText

func _ready() -> void:
	win_text.visible = false
	lose_text.visible = false

func show_win_UI():
	win_text.visible = true

func show_lose_UI():
	lose_text.visible = true
