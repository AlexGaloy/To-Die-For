extends Area2D

@export var speed = 1
@export var angle: float

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if get_node_or_null("../Player") != null:
		position.x += speed*cos(angle)
		position.y += speed*sin(angle)
	

func _on_body_entered(body: Node2D) -> void:
	if get_node_or_null("../Player") != null:
		if body == $"../Player" and $"../Player/Scythe/parry".disabled == true:
			queue_free()
		if body == $"../Player" and $"../Player/Scythe/parry".disabled == false:
			var ptear = $"../Player Tear".duplicate()
			$"..".add_child(ptear)
			ptear.position = $"../Player".position
			ptear.show()
			queue_free()
