extends Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $Player
@onready var light_anim_player: AnimationPlayer = $Lights/Flicker_light/AnimationPlayer
@onready var light_timer: Timer = $Lights/Flicker_light/Timer


func _ready() -> void:
	player.set_physics_process(false)

func _on_play_btn_pressed() -> void:
	anim_player.play("fade_menu")
	await anim_player.animation_finished
	light_timer.stop()
	light_anim_player.play("light_up")
	anim_player.play("start_game")
	await anim_player.animation_finished
	player.set_physics_process(true)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
