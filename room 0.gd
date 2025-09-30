extends Node
signal deathray()
var fences

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(15):
		var grave = $Grave.duplicate()
		add_child(grave)
	# TEMPORARY INSTA KILL ALL #
	#deathray.emit()
	var fences = find_child("Fences*")

func _process(_delta: float) -> void:
	if get_node_or_null("Player") != null:
		if $Player.position.y > $Fences0.position.y:
			$Fences0.z_index = $Player.z_index+10
		else:
			$Fences0.z_index = $Player.z_index-10

func _on_sad_ghost_tear(_ID: Variant) -> void:
	var tear = $"Sad Ghost/Tear".duplicate()
	tear.position = $"Sad Ghost".position
	add_child(tear)
	tear.show()
