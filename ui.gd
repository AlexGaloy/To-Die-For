extends CanvasLayer


var spin = load("res://spin icon.png")
var spear = load("res://spear icon.png")
var whip = load("res://whip icon.png")
var lightning = load("res://lightning icon.png")
var boomerang = load("res://boomerang icon.png")
@onready var flier = $"bottom/coffee cup/cup holders"
var stayer
var health = 12

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var file1 = "res://" + $"..".special1 + " icon.png"
	if $"bottom/special 1/special 1 icon".texture != load(file1):
		$"bottom/special 1/special 1 icon".show()
		$"bottom/special 1/special 1 icon".set_texture(load(file1))
		if $"..".special1.is_empty():
			$"bottom/special 1/special 1 icon".hide()
	var file2 = "res://" + $"..".special2 + " icon.png"
	if $"bottom/special 2/special 2 icon".texture != load(file2):
		$"bottom/special 2/special 2 icon".show()
		$"bottom/special 2/special 2 icon".set_texture(load(file2))
		if $"..".special2.is_empty():
			$"bottom/special 2/special 2 icon".hide()
	if Engine.time_scale == 0:
		$"bottom/special 1/Q key".show()
		$"bottom/special 2/E key".show()
	else:
		$"bottom/special 1/Q key".hide()
		$"bottom/special 2/E key".hide()

func _on_player_damaged(old_health: Variant, new_health: Variant) -> void:
	if new_health%2 == 0 or old_health-new_health >= 2:
		print("starting")
		stayer = flier.duplicate()
		stayer.frame = new_health
		$"bottom/coffee cup".add_child(stayer)
		stayer.position = flier.position
		flier.frame = old_health
		stayer.z_index = flier.z_index - 1
		$bottom/AnimationPlayer.play("fly")
		print(old_health,new_health,flier.frame,stayer.frame)
	else:
		flier.frame = new_health
	health = new_health

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fly":
		$bottom/AnimationPlayer.play("RESET")
		stayer.queue_free()
		flier.frame = health
