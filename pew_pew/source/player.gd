extends KinematicBody2D

export (PackedScene) var bullet 

var speed = 150
var acceleration = 1000
var movement = Vector2()
var score = 1


onready var label = $hud/Label
onready var anim = $AnimationPlayer
onready var anim_fade = $AnimationPlayer2
onready var audio_shoot = $AudioStreamPlayer
onready var timer = $Timer

func _physics_process(delta):
	
	var axis = get_input()
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta)
	else:
		apply_movement(axis * acceleration * delta)
	movement = move_and_slide(movement)
	
	gun_rotation()
	
	if Input.is_action_just_pressed("click"):
		shoot()
		anim.play("shoot")
		audio_shoot.play()
		 
	label.text = String(score)
	
	if score == 0:
		play_fade_anim()
		score = 0

func get_input():
	var velocity = Vector2()
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return velocity.normalized()

func apply_friction(amount):
	if movement.length() > amount:
		movement -= movement.normalized() * amount
		
	else:
		movement = Vector2.ZERO
		anim.stop()

func apply_movement(acceleration):
	movement += acceleration
	movement = movement.clamped(speed)
	anim.play("walk")

func gun_rotation():
	$gun_axis.look_at(get_global_mouse_position())
	if $gun_axis.rotation_degrees < -90:
		$gun_axis/Sprite2.flip_v = true
	elif $gun_axis.rotation_degrees > 90:
		$gun_axis/Sprite2.flip_v = true
	else:
		$gun_axis/Sprite2.flip_v = false

func shoot():
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $gun_axis/position.global_transform

func score_add():
	score += 1
func score_subtract():
	score -= 1

func play_fade_anim():
	anim_fade.play("ded")

func _on_AnimationPlayer2_animation_finished(anim_name):
	get_tree().reload_current_scene()
