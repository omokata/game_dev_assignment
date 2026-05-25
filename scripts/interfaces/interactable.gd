extends Area3D
class_name Interactable

signal interacted(actor: Node, interactable: Interactable)

@export var prompt_message := "Interact"
@export var is_hold_interaction := false
@export var hold_time := 2.0
@export var required_item: String

func _ready() -> void:
	monitoring = false
	monitorable = true
	collision_layer = 1 << (2 - 1)
	collision_mask = 0

func interact(actor: Node) -> void:
	interacted.emit(actor, self)
