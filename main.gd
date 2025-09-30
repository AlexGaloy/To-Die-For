extends Node

@export var current_room: Node
@export var rooms = find_children("Room *")
@export var finished = false
@export var done = false
@export var special1 = "spin"
@export var special2 = "spear"
var checked = false

func disable(room):
	room.set_process(false)
	room.visible = false
	for child in room.find_children("CollisionShape2D*"):
		child.disabled = true
	room.find_child("Fences*").collision_enabled = false

func enable(room):
	room.set_process(true)
	room.visible = true
	for child in room.find_children("CollisionShape2D*"):
		child.disabled = false
	room.find_child("Fences*").collision_enabled = true

func _ready() -> void:
	current_room = $"Room 0"
	rooms = find_children("Room *")
	rooms.erase(current_room)
	rooms.erase($"Room 1")
	rooms.erase($"Room S")
	rooms.shuffle()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#if Input.is_action_just_released("zoom in"):
		#print("-------------------------")
		#for room in find_children("Room *"):
			#for gate in room.find_children("Gate*"):
				#print(gate.name, " ", "is used" if gate.used else "isnt used")

func _physics_process(_delta: float) -> void:
	if finished:
		checked = true
		for room in find_children("Room *"):
			var boundries = room.find_child("Boundries")
			for area in boundries.get_overlapping_areas():
				if area.name == "Boundries":
					checked = false
		if !checked:
			get_tree().reload_current_scene()
	if done:
		for gate in $"Room S".find_children("Gate*"):
			gate.used = false
		$"Room S".used_gate.used = true
		
		for room in find_children("Room *"):
			for gate in room.find_children("Gate*"):
				if !gate.used:
					gate.fence()
		done = false

func _on_player_reroom(room: Node) -> void:
	current_room = room
