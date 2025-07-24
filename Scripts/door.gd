# door.gd
extends Node3D

@onready var anim_player := $AnimationPlayer
@onready var detection_area := $Area3D # Seu nó Area3D para detecção do jogador
@onready var hinge := $hinge # Referência ao seu nó hinge

var is_open = false
var close_timer_active = false # Nova variável para controlar o timer de fechamento

func _on_area_3d_body_entered(body: CharacterBody3D):
	if body.is_in_group("player"):
		# Se o jogador entrar enquanto o timer de fechamento está ativo,
		# pare o timer para que a porta permaneça aberta.
		if close_timer_active:
			# Se você usasse um Timer explícito, faria: $CloseTimer.stop()
			# Com await, simplesmente não chamamos close_door() novamente.
			return # Não faça nada, a porta já está abrindo ou aberta

		_determine_and_open_door(body)

func _on_area_3d_body_exited(body: CharacterBody3D):
	if body.is_in_group("player"):
		# Inicia o processo de fechamento após um atraso.
		start_close_timer()

func _determine_and_open_door(player: CharacterBody3D):
	if is_open:
		return

	# Calcule a posição do jogador em relação ao centro da porta
	var door_center_position = global_transform.origin

	# Obtenha o vetor do centro da porta para o jogador
	var to_player_vector = (player.global_transform.origin - door_center_position).normalized()

	# Obtenha o vetor 'direito' da porta no espaço global.
	var door_right_global_vector = global_transform.basis.x

	# Use o produto escalar para determinar se o jogador está à esquerda ou à direita
	var dot_product_with_door_right = door_right_global_vector.dot(to_player_vector)

	if dot_product_with_door_right > 0:
		anim_player.play("door_open_left")
		print("Abrindo porta para a esquerda (anti-horário)")
	else:
		anim_player.play("door_open_right")
		print("Abrindo porta para a direita (horário)")

	is_open = true
	close_timer_active = false # Resetar ao abrir, caso o timer estivesse ativo por algum motivo

func start_close_timer():
	if not is_open or close_timer_active: # Só inicia se estiver aberta e o timer não estiver ativo
		return

	close_timer_active = true
	# Use await para esperar por um tempo antes de chamar close_door()
	# Isso é o equivalente a usar um Timer com 'one_shot'
	await get_tree().create_timer(1.0).timeout # Espera 1 segundo

	# Verifica novamente se a porta ainda deve fechar (o jogador pode ter reentrado na Area3D)
	if close_timer_active and not is_open: # Garante que só fecha se não tiver sido reaberta
		# A linha acima é redundante, pois close_timer_active já verifica se ninguém "interrompeu"
		# Mas para ser super seguro:
		# O ideal aqui é verificar se o jogador AINDA ESTÁ na área de colisão.
		# Se a porta foi reaberta (is_open = true), não queremos fechar.
		# Se o player reentrou, close_timer_active será definido como false em _determine_and_open_door.

		# O método _on_area_3d_body_entered já cuida de parar o timer.
		# Então, se chegamos aqui, significa que o jogador realmente saiu e ficou fora por 1s
		close_door()
	close_timer_active = false # O timer terminou sua execução

func close_door():
	if is_open:
		is_open = false
		anim_player.play("door_closing")
