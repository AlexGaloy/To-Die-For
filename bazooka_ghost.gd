extends CharacterBody2D

var shooting = false
var health = 3
@export var invincibility = false
var dead = false
@export var target = position
var cooldown = 1

func hurt(damage):
	if invincibility == false and dead == false and Engine.time_scale != 0:
		health -= damage
		print("bazooka:",health)
		invincibility = true
		$AnimatedSprite2D.set_self_modulate(Color(1,1,1,.75))
		$"../Player/Scythe/AnimatedSprite2D".frame = 1
		Engine.time_scale = 0
		await get_tree().create_timer(.1,true,false,true).timeout
		Engine.time_scale = 1
		$AnimatedSprite2D.set_self_modulate(Color(1,1,1,.5))
		var slash = $slash.duplicate()
		get_parent().add_child(slash)
		if $"../Player/Scythe/AnimatedSprite2D".animation == "back":
			slash.flip_v = true
			slash.rotation = $"../Player".position.angle_to_point(position)
			slash.position = position
			slash.play(str(randi_range(1,2)))
		elif $"../Player/Scythe/AnimatedSprite2D".animation == "forewards" or $"../Player/Scythe/AnimatedSprite2D".animation == "spin":
			slash.rotation = $"../Player".position.angle_to_point(position)
			slash.position = position
			slash.play(str(randi_range(1,2)))
		elif $"../Player/Scythe/AnimatedSprite2D".animation == "spear":
			slash.rotation = $"../Player".global_position.angle_to_point(get_global_mouse_position()) + PI/2
			slash.position = position
			slash.play("forwards")
			slash.flip_h = randi_range(0,1)
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

func face(direction):
	if direction == "right":
		$AnimatedSprite2D.flip_h = false
		$hitbox.position.x = -2
	elif direction == "left":
		$AnimatedSprite2D.flip_h = true
		$hitbox.position.x = 2

func _ready() -> void:
	$Timer.start(5)
	dead = !visible
	$AnimatedSprite2D.animation = "idle"
	await get_tree().create_timer(2.0).timeout

func _process(_delta: float) -> void:
	if dead == false and get_node_or_null("../Player") != null:
		if position.x > $"../Player".position.x:
			face("left")
		else:
			face("right")
		if position.distance_to($"../Player".position) > 5 and shooting == false:
			if target.distance_to(position) > 5 and $Timer.time_left > 0:
				position.x = move_toward(position.x,target.x,.25)
				position.y = move_toward(position.y,target.y,.25)
				if position.y >= $"../Player".position.y:
					$AnimatedSprite2D.play("back walk")
				else:
					$AnimatedSprite2D.play("walk")
			else:
				target = Vector2(position.x + randi_range(-75,75),position.y + randi_range(-75,75))
				$Timer.start(5)
				cooldown -= 1
				if cooldown == 0:
					shoot()
					cooldown = 2

func _on_scythe_body_entered(body: Node2D) -> void:
	var player = get_parent().find_child("Player")
	if player != null:
		if player.attacking and body.name.contains(name):
			body.hurt(1)

func shoot():
	shooting = true
	if position.y >= $"../Player".position.y:
		$AnimatedSprite2D.play("back shoot")
	else:
		$AnimatedSprite2D.play("shoot")
	

func _on_player_tear_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(1)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "shoot" or $AnimatedSprite2D.animation == "back shoot" and get_node_or_null("../Bomb") != null:
		var Bomb = $"../Bomb".duplicate()
		$"..".add_child(Bomb)
		Bomb.show()
		shooting = false


func _on_node_deathray() -> void:
	dead = true

func _on_explosion_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(2)

func _on_hitbox_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(1)
