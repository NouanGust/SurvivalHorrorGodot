extends Area3D

var in_trigger: bool = false



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_trigger = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		in_trigger = false


func _process(_delta: float) -> void:
	if in_trigger and get_parent().current != true:
		get_parent().current = true
