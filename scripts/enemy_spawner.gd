extends Node2D

@onready var spawn_timer = $spawn_timer
@export var enemy_scene : PackedScene
var enemy
var wave = "wave_1"
var enemy_count = 1

func _physics_process(delta):
	match wave:
		"wave_1":
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_1"
			pass
		"break_1":
			pass
		"wave_2":
			pass
		"break_2":
			pass
		"wave_3":
			pass
		"break_3":
			pass
			
func _on_spawn_timer_timeout():
	enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.position.x = 1350
	enemy.position.y = randi() % 721
	enemy_count -= 1
