extends KinematicBody2D

var velocity = Vector2()

onready  var player = get_node("/root/world/player")
onready var agent = $NavigationAgent2D
onready var timer = $Timer

func _ready():
	update_pathfinding()
	timer.start()

func _physics_process(delta):
	#velocity = position.direction_to(player.position) * speed
	if agent.is_navigation_finished():
		return
	var direction = global_position.direction_to(agent.get_next_location())
	var desired_velocity = direction * 110
	var steering = (desired_velocity - velocity) * delta * 4
	velocity += steering
	velocity = move_and_slide(velocity)

func update_pathfinding():
	agent.set_target_location(player.global_position)

func _on_Timer_timeout():
	update_pathfinding()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.score_subtract()
