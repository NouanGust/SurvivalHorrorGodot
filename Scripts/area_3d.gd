extends Area3D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func interact() -> void:
	print("Porta!")
	animation_player.play("door_open_left")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
