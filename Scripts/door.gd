extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func interact() -> void:
	print("Porta!")
	animation_player.play("door_open_right")
