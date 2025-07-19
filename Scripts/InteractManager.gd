extends Node

@onready var interaction_prompt:= preload("res://Scenes/UI/interaction_prompt.tscn").instantiate()
var current_interactable = null
var current_interactable_body:Node3D  = null

func _ready() -> void:
	get_tree().root.add_child(interaction_prompt)
	interaction_prompt.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if current_interactable:
			current_interactable.interact()

func set_current_interactable(interactable_node:, prompt_text: String):
	if current_interactable == interactable_node:
		return
	current_interactable = interactable_node
	if current_interactable:
		interaction_prompt.text = prompt_text
		interaction_prompt.show()
	else:
		interaction_prompt.hide()

func clear_current_interactable():
	current_interactable = null
	interaction_prompt.hide()
