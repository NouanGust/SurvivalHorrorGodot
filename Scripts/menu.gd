extends Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $Player


func _ready() -> void:
	player.set_physics_process(false)

func _on_play_btn_pressed() -> void:
	anim_player.play("fade_menu")
	await anim_player.animation_finished
	anim_player.play("start_game")
	await anim_player.animation_finished
	player.set_physics_process(true)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
