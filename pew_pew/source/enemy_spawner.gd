extends Node2D

var enemy_scene = preload("res://scenes/enemy.tscn")
onready var timer = $Timer

func _ready():
	timer.start()

func _on_Timer_timeout():
	var enemy = enemy_scene.instance()
	add_child(enemy)
