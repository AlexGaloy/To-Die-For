extends Camera2D

var zoomed = true
var min = 100 #default 100
var max = 500 #default 500

func shake(x,y,intensity):
	var angle = Vector2(x,y).angle_to_point(global_position)
	position += Vector2(intensity*cos(angle),intensity*sin(angle))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !position.is_equal_approx(Vector2(0,10)):
		position = position.move_toward(Vector2(0,10),1)
	if Input.is_action_just_released("zoom in"):
		zoomed = !zoomed
	if $"../../..".current_room.name == "Room 1":
		zoom = Vector2(1,1)
	else:
		if zoomed == true:
			#$"..".SPEED = min
			zoom = Vector2(2,2)
		else:
			#$"..".SPEED = max
			zoom = Vector2(.2,.2)

func _on_bomb_shake(x: Variant, y: Variant, intensity: Variant) -> void:
	shake(x,y,intensity)

func _on_hammer_ghost_shake(x: Variant, y: Variant, intensity: Variant) -> void:
	shake(x,y,intensity)
