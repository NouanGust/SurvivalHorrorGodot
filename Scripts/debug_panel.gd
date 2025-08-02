extends CanvasLayer

@onready var fps_label: Label = $VBoxContainer/FPS_label
@onready var interactive_label: Label = $VBoxContainer/Interactive_label
@onready var current_scene_label: Label = $VBoxContainer/current_scene_label

var current_interactable_name = ""


func _process(_delta: float) -> void:
	# Mostrar FPS
	fps_label.text = "FPS: %s" % Engine.get_frames_per_second()
	
	# Pegar e mostrar nome do objeto interativo
	interactive_label.text = "Objeto interativo: %s" %(current_interactable_name if current_interactable_name != "" else "-")
	
	# Pegar e mostrar nome da cena
	current_scene_label.text = "Cena atual: %s" % get_tree().current_scene.name
func set_interactable(name: String) -> void:
	current_interactable_name = name

func clear_interactable() -> void:
	current_interactable_name = ""
