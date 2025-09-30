extends StaticBody2D

var range = 300

func _ready() -> void:
	position = Vector2((randi_range(-range,range)/20),randi_range(-range,range))
	$AnimatedSprite2D.frame = randi_range(0,4)

func _process(_delta: float) -> void:
	if get_node_or_null("../Player") != null:
		if $"../Player".position.y > position.y:
			z_index = $"../Player".z_index - 1
			$CollisionShape2D.position.y = -8.5
		else:
			z_index = $"../Player".z_index + 1
			$CollisionShape2D.position.y = 8.5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if get_node_or_null("../Player") != null and $"Grave Timer".is_stopped():
		if body == $".":
			position = Vector2((randi_range(-range,range)),randi_range(-range,range))
		if body == $"../Gate":
			queue_free()

func _on_collision_detection_body_entered(body: Node2D) -> void:
	if get_node_or_null("../Player") != null and $"Grave Timer".is_stopped():
		if body == $"../Fences0":
			position = Vector2((randi_range(-range,range)),randi_range(-range,range))
