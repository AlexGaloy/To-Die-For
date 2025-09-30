extends Node2D

var spec = 0
var cooldown = false
var busy = false
var stance = 1
var controller = false
var parrycoolingdown = false
@onready var tear = $"../../Sad Ghost/Tear"
@onready var sprite = $AnimatedSprite2D


# THE BANK OF SPECIAL ABILITIES

func spin():
	sprite.position = Vector2(0,0)

func spear():
	sprite.position = Vector2(2,1)
	sprite.rotation_degrees += 90

func boomerang():
	$AnimatedSprite2D.hide()
	
func lightning():
	sprite.play("lightning")
	$"..".set_physics_process(false)
	
# THE BANK OF SPECIAL ABILITIES

func changeSpec(amount):
	var oldSpec = spec
	spec += amount
	$"../../../UI/UI Scythe/AnimationPlayer".speed_scale = 3
	if sign(amount) == 1:
		$"../../../UI/UI Scythe/AnimationPlayer".play_section("charge",oldSpec,spec)
	else:
		$"../../../UI/UI Scythe/AnimationPlayer".play_section_backwards("charge",spec,oldSpec)

func _ready() -> void:
	allign(0)

func _process(_delta: float) -> void:
	var special1 = $"../../..".special1
	var special2 = $"../../..".special2
	var anim = $AnimatedSprite2D.animation
	if busy == false:
		$"..".attacking = false
		if Input.is_action_pressed("slash"):
			sprite.position = Vector2(13,-5)
			allign(-1)
			busy = true
			if stance == 1:
				$slash.rotation_degrees = 0
				sprite.play("forewards")
				$slash.disabled = false
			else:
				$slash.rotation_degrees = -25
				sprite.play("back")
				$slash.disabled = false
		elif Input.is_action_pressed("parry"):
			sprite.position = Vector2(13,-5)
			allign(-1)
			busy = true
			$parry.disabled = false
			sprite.play("parry")
		elif Input.is_action_pressed("special1"):   #SPECIAL 1
			if !special1.is_empty():
				if spec >= 1:
					changeSpec(-1)
					if special1 == "spin":
						spin()
					if special1 == "spear":
						spear()
					if special1 == "boomerang":
						boomerang()
					if special1 == "lightning":
						lightning()
					busy = true
					if special1 != "boomerang" and special1 != "lightning":
						find_child(special1).disabled = false
						sprite.play(special1)
		elif Input.is_action_pressed("special2"):   #SPECIAL 2
			if !special2.is_empty():
				if spec >= 1:
					changeSpec(-1)
					if special2 == "spin":
						spin()
					if special2 == "spear":
						spear()
					if special2 == "boomerang":
						boomerang()
					if special2 == "lightning":
						lightning()
					busy = true
					if special2 == "boomerang":
						$AnimatedSprite2D.hide()
					else:
						find_child(special2).disabled = false
						sprite.play(special2)
	else:
		$"..".attacking = anim != "idle" and anim != "parry"
	if anim == "idle":
		
		rotation_degrees = 0
	else:
		if controller == true:
			rotation = atan2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y),Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
		else:
			if rotation_degrees == 0:
				look_at(get_global_mouse_position())

func _on_animated_sprite_2d_animation_finished() -> void:
	var anim = $AnimatedSprite2D.animation
	if anim == "forewards" or $AnimatedSprite2D.animation == "back":
		$slash.disabled = true
		stance *= -1
	else:
		find_child(anim).disabled = true
		if anim == "spear":
			sprite.rotation_degrees -= 90
		$AnimatedSprite2D.animation = "idle"
		sprite.position = Vector2(13,-5)
		allign(0)
		modulate = Color(1,1,1,0.6)
		await get_tree().create_timer(.5).timeout
		modulate = Color(1,1,1,1)
	$AnimatedSprite2D.animation = "idle"
	sprite.position = Vector2(12,0)
	allign(0)
	busy = false
	

	
func allign(idle) -> void:
	if $"../Sprite".animation == "back" or $"../Sprite".animation == "back tilt":
		z_index = 0+idle
	else:
		z_index = -1-idle
	#0 for idle, -1 for everything else 


func _on_area_entered(area: Area2D) -> void:
	if area == tear and tear.visible == true and $parry.disabled == false:
		tear.queue_free()
		var ptear = $"../../Player Tear".duplicate()
		ptear.position = $"..".position
		$"../..".add_child(ptear)
		ptear.show()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if $AnimatedSprite2D.animation == "spear":
			pass #knockback
		if $AnimatedSprite2D.animation == "forewards" or $AnimatedSprite2D.animation == "back":
			if spec < 8:
				changeSpec(0.5)

func _on_hitbox_body_entered(body: Node2D) -> void:
	var sybau = false
	if body == $".." and busy and !sybau:
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.animation = "idle"
		sprite.position = Vector2(13,-5)
		allign(0)
		modulate = Color(1,1,1,0.6)
		sybau = true
		await get_tree().create_timer(.5).timeout
		modulate = Color(1,1,1,1)
		busy = false
