extends StaticBody2D

var velocity = Vector2(0,0)
var signs = Vector2(0,0)
var exploding = false
signal shake(x,y,intensity)

func explode():
	if visible == true:
		exploding = true
		shake.emit(global_position.x,global_position.y,50)
		scale = Vector2(1,1)
		modulate = Color(1,1,1,1)
		velocity = Vector2(0,0)
		$AnimatedSprite2D.pause()
		$explosion/AnimatedSprite2D.show()
		$explosion/AnimatedSprite2D.play("default")
		$AnimatedSprite2D.hide()
		$explosion/CollisionShape2D.disabled = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_node_or_null("../Player") != null:
		$explosion/CollisionShape2D.disabled = true
		$explosion/AnimatedSprite2D.hide()
		$AnimatedSprite2D.play("animation")
		position = $"../Bazooka Ghost".position
		velocity = Vector2(1 if ($"../Player".position.x-position.x)/253 > 1 else ($"../Player".position.x-position.x)/253, 1 if ($"../Player".position.y-position.y)/253 > 1 else ($"../Player".position.y-position.y)/253)
		signs = Vector2(sign(velocity.x), sign(velocity.y))
		if visible == false:
			$CollisionShape2D.disabled = true
	else:
		reparent($"../..".current_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_node_or_null("../Player") != null:
		if $AnimatedSprite2D.frame == 9 or $AnimatedSprite2D.frame == 17:
			if position.distance_to($"../Player".position) < 20 and exploding == false:
				if $"../Player/Scythe/parry".disabled == false:
					velocity = Vector2(-signs.x*abs(velocity.x),-signs.y*abs(velocity.y))
					modulate = Color(.75,0,1,1)
				else:
					explode()
		elif $AnimatedSprite2D.frame < 23:
			move_and_collide(velocity)
	else:
		reparent($"../..".current_room)


func _on_animated_sprite_2d_animation_finished() -> void:
	explode()

func _on_animated_sprite_2d_animation_finished_2() -> void:
	queue_free()
