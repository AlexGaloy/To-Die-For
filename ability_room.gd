extends Node2D

var ability
var spin = "spin"
var spear = "spear"
var whip = "whip"
var lightning = "lightning"
var boomerang = "boomerang"
@onready var special1 = $"..".special1
@onready var special2 = $"..".special2
var pool = [spin, spear, boomerang]
@export var used_gate: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pool.erase(special1)
	pool.erase(special2)
	ability = pool.pick_random()
	$"big grave/ability".texture = load("res://" + ability + " icon.png")
	$"../CanvasModulate".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_node_or_null("Player") != null:
		if Engine.time_scale == 0:
			if Input.is_action_just_pressed("special1"):
				$"..".special1 = ability
				ability = special1
				special1 = $"..".special1
				Engine.time_scale = 1
				$Player.set_process(true)
				$"../CanvasModulate".hide()
				$"big grave/ability".texture = load("res://" + ability + " icon.png")
			if Input.is_action_just_pressed("special2"):
				$"..".special2 = ability
				ability = special2
				special2 = $"..".special2
				Engine.time_scale = 1
				$Player.set_process(true)
				$"../CanvasModulate".hide()
				$"big grave/ability".texture = load("res://" + ability + " icon.png")
		if $Player.position.y > $"big grave".position.y:
			$"big grave".set_z_index($Player.get_z_index() - 1)
			$"big grave/CollisionShape2D".position.y = -15
		else:
			$"big grave".set_z_index($Player.get_z_index() + 1)
			$"big grave/CollisionShape2D".position.y = -0.5
		if $Player.position.y > $sign.position.y:
			$sign.set_z_index($Player.get_z_index() - 1)
			$"sign/CollisionShape2D".position.y = -6
		else:
			$sign.set_z_index($Player.get_z_index() + 1)
			$"sign/CollisionShape2D".position.y = 9
	if $"..".done:
		print(used_gate)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if $sign/Sprite2D.frame == 0 and area.name == "Scythe" and area.find_child("AnimatedSprite2D").animation != "parry" and area.find_child("AnimatedSprite2D").animation != "idle":
		$sign/Sprite2D.play()

func _on_grave_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Scythe" and area.find_child("AnimatedSprite2D").animation != "parry" and area.find_child("AnimatedSprite2D").animation != "idle":
		$"../CanvasModulate".show()
		Engine.time_scale = 0
		$Player.set_process(false)
		
