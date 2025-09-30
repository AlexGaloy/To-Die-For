extends CharacterBody2D

var health = 4
@export var invincibility = false
var dead = false
var attacking = false
var dry = false
var rand = (2*randi_range(0,1))-1
var shook = false
signal shake(x,y,intensity)
signal spec(amount)

func hurt(damage):
	if invincibility == false and dead == false:
		spec.emit(1)
		health -= damage
		print("hammer:",health)
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
			spec.emit(5)
			queue_free()
		await get_tree().create_timer(1.0).timeout
		invincibility = false
		$AnimatedSprite2D.set_self_modulate(Color(1,1,1,1))
		
func face(direction):
	if direction == "right":
		$AnimatedSprite2D.flip_h = true
		$hitbox.position.x = -3
		$hammer/hurtbox.rotation_degrees = -16.5
		$hammer/hurtbox.position.x = 10
	elif direction == "left":
		$AnimatedSprite2D.flip_h = false
		$hitbox.position.x = 3
		$hammer/hurtbox.rotation_degrees = 16.5
		$hammer/hurtbox.position.x = -10

func charge(speed) -> void:
	if abs(position.x -$"../Player".position.x) < 20 and abs(position.x -$"../Player".position.x) > 20:
		position.x += rand*.4
	else:
		if position.x > $"../Player".position.x+15:
			position.x -= speed
			face("left")
		elif position.x < $"../Player".position.x-15:
			position.x += speed
			face("right")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead = !visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dead == false and get_node_or_null("../Player") != null and Engine.time_scale != 0:
		if position.distance_to($"../Player".position) >= 20 and $AnimatedSprite2D.animation != "attack":
			if abs(position.y-$"../Player".position.y) < 10:
				charge(1.2)
				$AnimatedSprite2D.animation = "charge"
			else:
				if position.y >= $"../Player".position.y:
					position.y -= 0.2
					charge(.2)
					$AnimatedSprite2D.animation = "walking"
				elif position.y <= $"../Player".position.y:
					position.y += 0.2
					charge(.2)
					$AnimatedSprite2D.animation = "walking"
			$AnimatedSprite2D.play()
		elif dry == false:
			$AnimatedSprite2D.animation = "attack"
			$AnimatedSprite2D.play()
			dry = true

func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 4 or $AnimatedSprite2D.frame == 5:
			$hammer/hurtbox.disabled = false
			if !shook:
				shake.emit(global_position.x,global_position.y,25)
				shook = true
		else:
			$hammer/hurtbox.disabled = true
		

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		shook = false
		$AnimatedSprite2D.animation = "idle"
		dry = false

func _on_scythe_body_entered(body: Node2D) -> void:
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if player.attacking and body.name.contains(name):
			body.hurt(1)

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
	var player = $".".get_parent().find_child("Player")
	if player != null:
		if body.name.contains(name):
			body.hurt(1)
