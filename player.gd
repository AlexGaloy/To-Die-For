extends CharacterBody2D

var max_health = 12
var health = max_health
var invincible = false
@export var SPEED = 200 #default 100
signal reroom(room: Node)
@export var attacking = false
signal damaged(old_health,new_health)

func death():
	get_tree().reload_current_scene()

func hurt(damage):
	invincible = true
	$"../../UI/bottom/coffee cup/cup holders".frame = health
	damaged.emit(health,health-damage)
	health -= damage
	if health < 0:
		death()
	else:
		$Camera.shake(randf_range(-1,1),randf_range(-1,1),15)
		$Sprite.set_modulate(Color(1,.5,.5,.5))
		await get_tree().create_timer(.25).timeout
		$Sprite.set_modulate(Color(1,1,1,1))
		await get_tree().create_timer(.25).timeout
		$Sprite.set_modulate(Color(1,.5,.5,.5))
		await get_tree().create_timer(.125).timeout
		$Sprite.set_modulate(Color(1,1,1,1))
		await get_tree().create_timer(.125).timeout
		$Sprite.set_modulate(Color(1,.5,.5,.5))
		await get_tree().create_timer(.125).timeout
		$Sprite.set_modulate(Color(1,1,1,1))
		await get_tree().create_timer(.125).timeout
		$Sprite.set_modulate(Color(1,.5,.5,.5))
		invincible = false
		$Sprite.set_modulate(Color(1,1,1,1))

func _ready() -> void:
	$"../../UI/bottom/coffee cup/cup holders".frame = health

func _physics_process(_delta: float) -> void:
	if $"../..".current_room != get_parent():
		reroom.emit(get_parent())
	if Input.is_action_pressed("up"):
		velocity.y = -SPEED
		if $Scythe/AnimatedSprite2D.animation == "idle":
			$Scythe.z_index = 0
		else:
			$Scythe.z_index = -1
		if velocity.x == 0:
			$Sprite.animation = "back"
		else:
			$Sprite.animation = "back tilt"
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
		if $Scythe/AnimatedSprite2D.animation == "idle":
			$Scythe.z_index = -1
		else:
			$Scythe.z_index = 0
		if velocity.x == 0:
			$Sprite.animation = "front"
		else:
			$Sprite.animation = "front tilt"
	else:
		velocity.y = velocity.y/1.5
		if abs(velocity.y) <= 1:
			velocity.y = 0
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprite.flip_h = true
		if $Sprite.animation == "front":
			$Sprite.animation = "front tilt"
		elif $Sprite.animation == "back":
			$Sprite.animation = "back tilt"
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprite.flip_h = false
		if $Sprite.animation == "front":
			$Sprite.animation = "front tilt"
		elif $Sprite.animation == "back":
			$Sprite.animation = "back tilt"
	else:
		velocity.x = velocity.x/1.5
		if abs(velocity.x) <= 1:
			velocity.x = 0
	move_and_slide()

func _on_hammer_body_entered(body: Node2D) -> void:
	if body == $"." and $"../Hammer Ghost/hammer/hurtbox".disabled == false and invincible == false:
		hurt(2)

func _on_tear_body_entered(body: Node2D) -> void:
	if body == $"." and invincible == false and $Scythe/AnimatedSprite2D.animation != "parry":
		hurt(1)

func _on_explosion_body_entered(body: Node2D) -> void:
	if body == $"." and invincible == false and $"../Bomb".modulate != Color(.75,0,1,1):
		hurt(2)

func _on_fence_detection_body_entered(body: Node2D) -> void:
	if get_node_or_null("../Fences") != null:
		if body == $"../Fences0" or body.name.contains("Gate"):
			$Collision.scale.y = 0.2
			$Collision.position.y = 8

func _on_fence_detection_body_exited(body: Node2D) -> void:
	if body == $"../Fences" or body.name.contains("Gate"):
		var still = false
		if $"fence detection".overlaps_body($"../Fences0"):
			still = true
		for gate in $"../..".find_children("Gate*"):
			if $"fence detection".overlaps_body(gate):
				still = true
		if !still:
			$Collision.scale.y = 1
			$Collision.position.y = 0

func _on_detection_zone_body_entered(body: Node2D) -> void:
	pass
