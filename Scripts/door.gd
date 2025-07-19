# door.gd
extends Node3D

@onready var anim_player := $AnimationPlayer
@onready var detection_area := $Area3D # Seu nó Area3D para detecção do jogador
@onready var hinge := $hinge # Referência ao seu nó hinge

var is_open = false


func _on_area_3d_body_entered(body: CharacterBody3D): # Use CharacterBody3D, como no seu print
	if body.is_in_group("player"): # Assuma que seu jogador está no grupo "player"
		_determine_and_open_door(body)

func _on_area_3d_body_exited(body: CharacterBody3D):
	if body.is_in_group("player"):
		close_door()

func _determine_and_open_door(player: CharacterBody3D):
	if is_open:
		return

	# Calcule a posição do jogador em relação ao centro da porta
	# A posição da porta será a GlobalPosition do nó pai 'Door'.
	# Você pode querer usar a posição do hinge para um cálculo mais preciso,
	# mas a GlobalPosition do 'Door' geralmente funciona como um bom centro de referência.
	var door_center_position = global_transform.origin # A posição do nó "Door"

	# Obtenha o vetor do centro da porta para o jogador
	var to_player_vector = (player.global_transform.origin - door_center_position).normalized()

	# Obtenha o vetor 'direito' da porta no espaço global.
	# Como sua porta gira em torno de Y e está alinhada com Z (parece que Z é a profundidade),
	# o vetor "direito" é o eixo X local da porta.
	var door_right_global_vector = global_transform.basis.x # O vetor 'x' da própria porta

	# Use o produto escalar para determinar se o jogador está à esquerda ou à direita
	# da "frente" da porta.
	# Isso nos dirá qual lado da porta o jogador está.
	var dot_product_with_door_right = door_right_global_vector.dot(to_player_vector)

	# Lógica para determinar qual animação tocar:
	# Pense na porta como tendo um lado "esquerdo" e um "direito" em relação à sua face.
	# Se o jogador está mais para o lado direito da porta (olhando para a porta de frente),
	# a porta deve abrir para a sua "esquerda" (longe do jogador).
	# Se o jogador está mais para o lado esquerdo da porta,
	# a porta deve abrir para a sua "direita".

	# A direção de abertura dependerá de como você criou suas animações "door_open_left" e "door_open_right".
	# Vamos assumir:
	# - "door_open_left" faz a porta girar no sentido anti-horário (ex: Y de 0 para -90).
	# - "door_open_right" faz a porta girar no sentido horário (ex: Y de 0 para 90).

	if dot_product_with_door_right > 0:
		# O jogador está mais para o lado DIREITO da porta (em relação ao vetor 'right' da porta).
		# A porta deve se abrir para a "esquerda" do jogador, ou seja,
		# a borda livre da porta deve ir para o lado esquerdo do jogador.
		# Isso geralmente significa girar no sentido anti-horário (ex: para -90 graus Y).
		anim_player.play("door_open_left")
		print("Abrindo porta para a esquerda (anti-horário)") # Para debug
	else:
		# O jogador está mais para o lado ESQUERDO da porta.
		# A porta deve se abrir para a "direita" do jogador, ou seja,
		# a borda livre da porta deve ir para o lado direito do jogador.
		# Isso geralmente significa girar no sentido horário (ex: para +90 graus Y).
		anim_player.play("door_open_right")
		print("Abrindo porta para a direita (horário)") # Para debug

	is_open = true

func close_door():
	if is_open:
		is_open = false
		anim_player.play("door_closing")
