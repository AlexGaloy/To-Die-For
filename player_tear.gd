extends Area2D

var speed = 1
var angle = 0

func _ready() -> void:
	angle = $"../Player".get_angle_to(get_global_mouse_position())
	if visible == true:
		$Timer.start()
	if get_parent().name == "Room 1":
		speed = 4
		scale = Vector2(5,5)
	else:
		speed = 1
		scale = Vector2(1,1)
		

func _process(_delta: float) -> void:
	if visible == true:
		position.x += speed*cos(angle)
		position.y += speed*sin(angle)
	if get_node_or_null("../Player") == null:
		reparent($"../..".current_room)

func _on_body_entered(body: Node2D) -> void:
	if visible == true and body != $"../Player/Scythe" and body != $"../Player":
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
