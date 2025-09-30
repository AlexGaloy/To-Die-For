extends Node2D

var fences: Node2D
@onready var ones = [$"../Sad Ghost"]
@onready var twos = [$"../Hammer Ghost",$"../Bazooka Ghost"]
@onready var pool = ones

func _ready() -> void:
	fences = find_child("Fences*")
	for enemy in pool:
		var dupe = enemy.duplicate()
		add_child(dupe)
		dupe.show()
		dupe.position.x = randf_range(-150,150)
		dupe.position.y = randf_range(-150,150)
		dupe.name = enemy.name
		dupe.scale = Vector2(5,5)
		dupe.dist = 250
		dupe.health = 8
		dupe.x = 3

func _process(delta: float) -> void:
	#if get_node_or_null("Player") != null:
		#print_tree_pretty()
	for enemy in get_children():
		if enemy.is_in_group("enemies"):
			if fences in enemy.get_node_or_null("Area2D").get_overlapping_bodies():
				enemy.position.x = randf_range(-150,150)
				enemy.position.y = randf_range(-150,150)
				if enemy == $"Bazooka Ghost":
					enemy.target = Vector2(enemy.position.x + randi_range(-50,50),enemy.position.y + randi_range(-50,50))
