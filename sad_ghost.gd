extends CharacterBody2D

@export var x = 1
var dry = true
@export var health = 2
@export var invincibility = false
@export var dead = false
@export var dist = 75
@onready var slash = $slash
signal spec(amount)

func hurt(damage):
	if invincibility == false and dead == false:
		health -= damage
		print("sad:",health)
		invincibility = true
		$AnimatedSprite2D.set_self_modulate(Color(1,1,1,.75))
		$"../Player/Scythe/AnimatedSprite2D".frame = 1
		Engine.time_scale = 0
		await get_tree().create_timer(.1*damage,true,false,true).timeout
		Engine.time_scale = 1
		$AnimatedSprite2D.set_self_modulate(Color(1,1,1,.5))
		slash = $slash.duplicate()
		get_parent().add_child(slash)
		if $"../Player/Scythe/AnimatedSprite2D".animation == "back":
			slash.flip_v = true
			slash.rotation = $"../Player".position.angle_to_point(position)
			slash.play(str(randi_range(1,2)))
		elif $"../Player/Scythe/AnimatedSprite2D".animation == "forewards" or $"../Player/Scythe/AnimatedSprite2D".animation == "spin":
			slash.rotation = $"../Player".position.angle_to_point(position)
			slash.play(str(randi_range(1,2)))
		elif $"../Player/Scythe/AnimatedSprite2D".animation == "spear":
			slash.rotation = $"../Player".global_position.angle_to_point(get_global_mouse_position()) + PI/2
			slash.play("forwards")
			slash.flip_h = randi_range(0,1)
		slash.position = position
		slash.z_index = z_index - 1
		if health <= 0:
			dead = true
			slash = $slash.duplicate()
			get_parent().add_child(slash)
			slash.position = position
			slash.play("death " + str(randi_range(1,3)))
			queue_free()
		await get_tree().create_timer(1.0).timeout
		invincibility = false
		$AnimatedSprite2D.set_self_modulate(Color(1,1,1,1))

func _ready() -> void:
	dead = !visible
	$AnimatedSprite2D.animation = "idle"
	$Tear.hide()
	await get_tree().create_timer(randf_range(1,4)).timeout
	dry = false

func _process(_delta: float) -> void:
	if dead == false and get_node_or_null("../Player") != null and Engine.time_scale != 0:
		if position.distance_to($"../Player".position) <= dist:
			if position.x >= $"../Player".position.x:
				position.x += 0.4 * x
				$AnimatedSprite2D.flip_h = true
			elif position.x <= $"../Player".position.x:
				position.x -= 0.4 * x
				$AnimatedSprite2D.flip_h = false
			if position.y >= $"../Player".position.y:
				position.y += 0.4 * x
				$AnimatedSprite2D.animation = "front tilt"
			elif position.y <= $"../Player".position.y:
				position.y -= 0.4 * x
				$AnimatedSprite2D.animation = "back tilt"
		elif dry == false:
			cry()
		else:
			if $AnimatedSprite2D.animation == "back attack" or $AnimatedSprite2D.animation == "front attack":
				if $AnimatedSprite2D.frame == 2:
					if position.x >= $"../Player".position.x:
						$AnimatedSprite2D.flip_h = false
					else:
						$AnimatedSprite2D.flip_h = true
					if position.y >= $"../Player".position.y:
						$AnimatedSprite2D.animation = "back tilt"
					else:
						$AnimatedSprite2D.animation = "front tilt"
			else:
				if position.x >= $"../Player".position.x:
					$AnimatedSprite2D.flip_h = false
				else:
					$AnimatedSprite2D.flip_h = true
				if position.y >= $"../Player".position.y:
					$AnimatedSprite2D.animation = "back tilt"
				else:
					$AnimatedSprite2D.animation = "front tilt"

func _on_scythe_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if player.attacking and body.name.contains(name):
			body.hurt(1)

func cry() -> void:
	if position.y >= $"../Player".position.y:
		$AnimatedSprite2D.play("back attack")
	else:
		$AnimatedSprite2D.play("front attack")
	var tear = $Tear.duplicate()
	get_parent().add_child(tear)
	tear.position = position
	tear.angle = global_position.angle_to_point($"../Player".global_position)
	tear.scale = scale
	tear.speed = x
	tear.show()
	#emit_signal("tear",tear)
	dry = true
	await get_tree().create_timer(randf_range(2,5)/x).timeout
	dry = false

func _on_player_tear_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(1)

func _on_node_deathray() -> void:
	dead = true


func _on_explosion_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(2)

func _on_hitbox_body_entered(body: Node2D) -> void:
	print(body)
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(1)
