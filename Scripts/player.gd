extends CharacterBody3D


@export var speed := 3.5
@export var rotation_speed := 2.5
@export var walk_footsteps: Array[AudioStream]
var rng:RandomNumberGenerator

@onready var interaction_area = $Interaction_area
var current_interactable = null

@onready var debug_panel =  $DebugPanel

func _ready() -> void:
	
	debug_panel.visible = false
	
	rng = RandomNumberGenerator.new()
	interaction_area.connect("area_entered", _on_area_entered)
	interaction_area.connect("area_exited", _on_area_exited)

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

func _on_area_entered(area: Area3D) -> void:
	if area.has_method("interact"):
		current_interactable = area
		print("Pode interagir com: %s" %[str(area.name)])
	debug_panel.set_interactable(area.name)

func _on_area_exited(area: Area3D) -> void:
	if current_interactable == area:
		current_interactable = null
		print("Saiu da area de interação com: %s" % [area.name])
		debug_panel.clear_interactable()


func _input(event: InputEvent) -> void:
	
	# Ativar painel de debug
	if event.is_action_pressed("debug"):
		if !debug_panel.visible:
			debug_panel.visible = true
		else:
			debug_panel.visible = false
	
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()
