extends CharacterBody3D


@export var speed := 3.5
@export var rotation_speed := 2.5
@export var walk_footsteps: Array[AudioStream]
var rng:RandomNumberGenerator

func _ready() -> void:
	rng = RandomNumberGenerator.new()


func _physics_process(delta: float) -> void:
	
	# Vector Zero para definir a direção
	var input_direction := Vector2.ZERO
	
	# Movimentação
	if Input.is_action_pressed("move_forward"):
		if !$Footsteps.playing:
			var num = rng.randi_range(0, walk_footsteps.size() -1)
			$Footsteps.stream = walk_footsteps[num]
			$Footsteps.play()
		input_direction.y = 1
	elif Input.is_action_pressed("move_backward"):
		input_direction.y = -1

	# Rotação
	if Input.is_action_pressed("turn_left"):
		rotate_y(deg_to_rad(rotation_speed * delta * 50))
	elif Input.is_action_pressed("turn_right"):
		rotate_y(deg_to_rad(rotation_speed * delta * -50))
	
	# Pega a direção "Para frente"
	var direction := transform.basis.z * input_direction.y 
	velocity = direction * speed
	
	move_and_slide()
