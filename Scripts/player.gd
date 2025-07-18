extends CharacterBody3D


@export var speed := 2.5
@export var rotation_speed := 1.3

#@onready var player_anim: AnimationPlayer = $AnimationLibrary_Godot_Standard/AnimationPlayer
@onready var player_anim_tree: AnimationTree = $AnimationLibrary_Godot_Standard/PlayerAnimTree


func _ready() -> void:
	player_anim_tree.active = true
	print("Animation ativo")

func _physics_process(delta: float) -> void:
	
	# Vector Zero para definir a direção
	var input_direction := Vector2.ZERO
	
	# Movimentação
	if Input.is_action_pressed("move_forward"):
		input_direction.y = 1
	elif Input.is_action_pressed("move_backward"):
		input_direction.y = -1

	# Rotação
	if Input.is_action_pressed("turn_left"):
		rotate_y(deg_to_rad(rotation_speed * delta * -50))
	elif Input.is_action_pressed("turn_right"):
		rotate_y(deg_to_rad(rotation_speed * delta * 50))
	
	# Pega a direção "Para frente"
	var direction := transform.basis.z * input_direction.y 
	velocity = direction * speed
	
	# Animações
	if input_direction.y != 0:
		if player_anim_tree.get("parameters/playback/travel") != "Walk":
			player_anim_tree.set("parameters/playback/travel", "Walk")
			print("Andando")
	else:
		if player_anim_tree.get("parameters/playback/travel") != "Idle":
			player_anim_tree.set("parameters/playback/travel", "Idle")
			print("Idle")
	move_and_slide()
