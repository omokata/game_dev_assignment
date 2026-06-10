extends Node3D

@onready var interactable: Interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable.interacted.connect(_on_interactable_interacted)

func _on_interactable_interacted(actor: Node, interactable: Interactable):
	print("Remove planks")
	queue_free()
