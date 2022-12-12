extends Area2D

var speed = 750
onready  var player = get_node("/root/world/player")

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
		player.score_add()
	queue_free()
	if body.is_in_group("tiles"):
		queue_free()
