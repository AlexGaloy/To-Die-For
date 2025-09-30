extends RigidBody2D

var timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.hide()
	position = $"../Player".position
	$CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_node_or_null("../Player") != null:
		if $AnimatedSprite2D.visible:
			if position.distance_to($"../Player".position) > 50:
				$hitbox/CollisionShape2D.disabled = false
			var angle = get_angle_to($"../Player".global_position)
			if timer.time_left == 0:
				linear_velocity = Vector2(0,0)
				apply_central_impulse(Vector2(500*cos(angle),500*sin(angle)))
				timer = get_tree().create_timer(2)
			else:
				apply_central_force(Vector2(200*cos(angle),200*sin(angle)))
		else:
			$hitbox/CollisionShape2D.disabled = true
			sleeping = true
			$CollisionShape2D.disabled = true
			position = $"../Player".position
			if (Input.is_action_just_pressed("special1") and $"../..".special1 == "boomerang") or (Input.is_action_just_pressed("special2") and $"../..".special2 == "boomerang"):
				timer = get_tree().create_timer(4)
				var theta = get_angle_to(get_global_mouse_position())
				apply_impulse(Vector2(500*cos(theta),500*sin(theta)))
				$AnimatedSprite2D.show()
	else:
		print($"../..".current_room)
		reparent($"../..".current_room)
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body == $"../Player":
		$AnimatedSprite2D.hide()
		position = $"../Player".position
		$CollisionShape2D.disabled = true
