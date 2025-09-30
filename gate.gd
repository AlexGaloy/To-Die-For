extends StaticBody2D

var locked = false
var open = false
var enemies = 0
@export var used = false
@onready var side = ("R" if $AnimatedSprite2D.flip_h == true else "L") if $AnimatedSprite2D.animation == "side" else ("T" if $AnimatedSprite2D.animation == "back" else "B")

func disable(room):
	room.set_process(false)
	room.visible = false
	#for child in room.find_children("CollisionShape2D*"):
		#child.disabled = true
	room.find_child("Fences*").collision_enabled = false

func enable(room):
	room.set_process(true)
	room.visible = true
	#for child in room.find_children("CollisionShape2D*"):
		#child.disabled = false
	room.find_child("Fences*").collision_enabled = true

func fence():
	var letter = get_parent().name.erase(0,5)
	var path = "../Fences" + letter
	var Fences = get_node(path)
	var cell1 #top or left cell
	var cell2 #bottom or right cell
	if side in ["L", "R"]:
		Fences.set_cell(Fences.local_to_map(Fences.to_local(global_position + Vector2(0,32))),1,Vector2i(1,1))
		Fences.set_cell(Fences.local_to_map(Fences.to_local(global_position - Vector2(0,0))),1,Vector2i(1,1))
	else:
		Fences.set_cell(Fences.local_to_map(Fences.to_local(global_position + Vector2(16,0))),1,Vector2i(0,0))
		Fences.set_cell(Fences.local_to_map(Fences.to_local(global_position - Vector2(16,0))),1,Vector2i(0,0))
	queue_free()

func check_all(room):
	if room != null:
		for gate in room.find_children("Gate*"):
			if !gate.used:
				if !$"../..".rooms.is_empty():
					check_all(gate.generate())
				elif !$"../..".finished:
					$"../..".rooms.append($"../../Room 1")
				else:
					$"../..".rooms.append($"../../Room S")

func build_room(room):
	var parameter = "Gate?"+side
	var gate = room.find_child(parameter)
	if gate != null:
		var disp = gate.global_position - room.global_position
		if side == "B" or side == "T":
			disp.y += (1 if side=="B" else -1)*192 + 0 #2nd number should change to length of path
		elif side == "L" or side == "R":
			disp.x += (1 if side=="R" else -1)*192 + 0 #2nd number should change to length of path
		room.global_position = global_position - disp
		enable(room)
		gate.used = true
		used = true
		var letter = get_parent().name.erase(0,5)
		var path = "../Fences" + letter
		var Fences = get_node(path)
		var midpoint = Fences.local_to_map(Fences.to_local((global_position + gate.global_position) * 0.5))
		var Other_Fences = room.get_node("Fences" + room.name.erase(0,5))
		print(Other_Fences)
		if side == "T":
			for i in range(-2,3):
				Fences.set_cell(midpoint + Vector2i(-4,i),1,Vector2(1,1))
				Fences.set_cell(midpoint + Vector2i(2,i),1,Vector2(1,1))
			Fences.set_cell(midpoint + Vector2i(-4,3),0,Vector2(0,0))
			Fences.set_cell(midpoint + Vector2i(2,3),0,Vector2(0,0))
			Fences.set_cell(midpoint + Vector2i(-4,-3),0,Vector2(1,1))
			Fences.set_cell(midpoint + Vector2i(2,-3),0,Vector2(1,1))
		elif side == "B":
			for i in range(-2,3):
				Fences.set_cell(midpoint + Vector2i(-4,i),1,Vector2(1,1))
				Fences.set_cell(midpoint + Vector2i(2,i),1,Vector2(1,1))
			Fences.set_cell(midpoint + Vector2i(-4,3),0,Vector2(0,0))
			Fences.set_cell(midpoint + Vector2i(2,3),0,Vector2(0,0))
			Fences.set_cell(midpoint + Vector2i(-4,-3),0,Vector2(1,1))
			Fences.set_cell(midpoint + Vector2i(2,-3),0,Vector2(1,1))
			Other_Fences.set_cell(Other_Fences.local_to_map(Other_Fences.to_local((global_position + gate.global_position) * 0.5)) + Vector2i(-4,-3),0,Vector2(-1,-1))
			Other_Fences.set_cell(Other_Fences.local_to_map(Other_Fences.to_local((global_position + gate.global_position) * 0.5)) + Vector2i(2,-3),0,Vector2(-1,-1))
		elif side == "R":
			for i in range(-2,3):
				Fences.set_cell(midpoint + Vector2i(i,-2),1,Vector2(0,0))
				Fences.set_cell(midpoint + Vector2i(i,3),1,Vector2(0,0))
			Fences.set_cell(midpoint + Vector2i(-3,-2),0,Vector2(0,1))
			Fences.set_cell(midpoint + Vector2i(-3,3),0,Vector2(0,1))
			Fences.set_cell(midpoint + Vector2i(3,-2),0,Vector2(1,0))
			Fences.set_cell(midpoint + Vector2i(3,3),0,Vector2(1,0))
		elif side == "L":
			for i in range(-2,3):
				Fences.set_cell(midpoint + Vector2i(i,-2),1,Vector2(0,0))
				Fences.set_cell(midpoint + Vector2i(i,3),1,Vector2(0,0))
			Fences.set_cell(midpoint + Vector2i(-3,-2),0,Vector2(0,1))
			Fences.set_cell(midpoint + Vector2i(-3,3),0,Vector2(0,1))
			Fences.set_cell(midpoint + Vector2i(3,-2),0,Vector2(1,0))
			Fences.set_cell(midpoint + Vector2i(3,3),0,Vector2(1,0))
		if room.name == "Room 1":
			$"../..".finished = true
		if room.name == "Room S":
			$"../..".done = true
			$"../../Room S".used_gate = gate
		return true
	else:
		return false


func generate():
	var index = randi_range(1,$"../..".rooms.size())-1
	var choice = $"../..".rooms[index]
	if !build_room(choice):
		#print(name, " couldnt generate ", choice.name)
		var built = false
		for i in $"../..".rooms:
			if !built:
				index = 0 if index >= $"../..".rooms.size()-1 else index+1
				built = build_room($"../..".rooms[index])
		if built == false:
			return null
	var next_room = $"../..".rooms[index]
	$"../..".rooms.erase(next_room)
	print(name, " generated ", next_room.name)
	return next_room


func _ready() -> void:
	#print(name, side)
	if locked == false:
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0
	if $AnimatedSprite2D.animation == "side":
		$AnimatedSprite2D.position = Vector2(-31,1)
		$AnimatedSprite2D.flip_h = false
		$CollisionShape2D.position = Vector2(0,29.5)
		$CollisionShape2D.scale = Vector2(0.075,13)
		$AnimatedSprite2D2.show()
		$"side top".disabled = false
		$"side bottom".disabled = false
	else:
		$AnimatedSprite2D.position = Vector2(0,0)
		$AnimatedSprite2D.flip_h = false
		$CollisionShape2D.position = Vector2(0,29.5)
		$CollisionShape2D.scale = Vector2(1,1)
		$AnimatedSprite2D2.hide()
		$"side top".disabled = true
		$"side bottom".disabled = true
	$AnimatedSprite2D2.frame = 0
		


func _process(_delta: float) -> void:
	if $".".get_parent().find_child("Player") != null:
		if $AnimatedSprite2D.global_position.y+4 > $"../Player".global_position.y:
			$AnimatedSprite2D.z_index = $"../Player".z_index +6
		else:
			$AnimatedSprite2D.z_index = $"../Player".z_index -4
		if $AnimatedSprite2D2.global_position.y+4 > $"../Player".global_position.y:
			$AnimatedSprite2D2.z_index = $"../Player".z_index +6
		else:
			$AnimatedSprite2D2.z_index = $"../Player".z_index -4
		if open == true:
			$CollisionShape2D.disabled = true
		else:
			$CollisionShape2D.disabled = false
		if $AnimatedSprite2D.frame == 1 and locked == false and open == false:
			$AnimatedSprite2D.pause()
		$AnimatedSprite2D2.frame = $AnimatedSprite2D.frame
		enemies = 0
		for child in $".".get_parent().get_children():
			if child.is_in_group("enemies"):
				enemies += 1
		if enemies == 0:
			locked = false

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if locked == false:
		if body.is_in_group("player"):
			if body.get_parent() != $".".get_parent():
				body.call_deferred("reparent",$".".get_parent())
			open = true
			$AnimatedSprite2D.play()

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if get_node_or_null("../Player") != null:
		if body == $"../Player" and locked == false:
			if (side == "L" and body.position.x < position.x) or (side == "R" and body.position.x > position.x) or (side == "T" and body.position.y < position.y) or (side == "B" and body.position.y > position.y):
				for gate in get_parent().find_children("Gate*"):
					gate.locked = true
			if name.contains("1") and ((side == "R" and body.position.x < position.x) or (side == "L" and body.position.x > position.x) or (side == "T" and body.position.y < position.y) or (side == "B" and body.position.y > position.y)):
				for gate in get_parent().find_children("Gate*"):
					gate.locked = true
			else:
				for gate in get_parent().find_children("Gate*"):
					gate.locked = false
			open = false
			$AnimatedSprite2D.play_backwards()

func _on_main_ready() -> void:
	for room in $"../..".find_children("Room *"):
		if room.name != $"../..".current_room.name:
			disable(room)
	var next_room
	for gate in $"..".find_children("Gate*"):
			if !gate.used  and !$"../..".rooms.is_empty():
				next_room = generate()
	check_all(next_room)
