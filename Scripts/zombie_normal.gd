extends CharacterBody3D


const SPEED := 65.0
const CHASE_RANGE := 3.0

@export var target : CharacterBody3D
@onready var nav_agent: NavigationAgent3D = $nav_agent
@onready var animation_player: AnimationPlayer = $Zombie_normal/AnimationPlayer


func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	
	if global_position.distance_to(target.global_position) < CHASE_RANGE:
		nav_agent.set_target_position(target.global_transform.origin)
		var nex_nav_point := nav_agent.get_next_path_position()
		velocity = (nex_nav_point - global_transform.origin).normalized() * SPEED * delta
		look_at(Vector3(global_position.x, global_position.y, -target.global_position.z), Vector3.UP)
		animation_player.play("walking")
		move_and_slide()
