extends Node2D

var fences: Node2D
@onready var ones = [$"../Sad Ghost"]
@onready var twos = [$"../Hammer Ghost",$"../Bazooka Ghost"]
var sum = 7
var pool = []

func _ready() -> void:
	fences = find_child("Fences*")
	while sum != 0:
		var addition = randi_range(1,2)
		sum -= addition
		if sum < 0:
			sum += addition
		else:
			if addition == 1:
				pool.append(ones.pick_random())
			if addition == 2:
				pool.append(twos.pick_random())
	for enemy in pool:
		var dupe = enemy.duplicate()
		add_child(dupe)
		dupe.show()
		dupe.position.x = randf_range(-150,150)
		dupe.position.y = randf_range(-150,150)
		dupe.name = enemy.name

func _process(delta: float) -> void:
	#if get_node_or_null("Player") != null:
		#print_tree_pretty()
	for enemy in get_children():
		if enemy.is_in_group("enemies"):
			if !enemy in $Boundries.get_overlapping_bodies():
				var new_pos = Vector2(randf_range(-200,200),randf_range(-200,200))
				var tween = create_tween()
				tween.set_trans(Tween.TRANS_SINE)
				enemy.modulate = Color(1,1,1,.3)
				tween.tween_property(enemy,"position",new_pos,.5)
				tween.tween_property(enemy,"modulate",Color(1,1,1,1),.25)
				if enemy.name.contains("Bazooka Ghost"):
					enemy.target = Vector2(enemy.position.x + randi_range(-50,50),enemy.position.y + randi_range(-50,50))
