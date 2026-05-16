extends Node2D

@onready var spawn_timer = $spawn_timer
@export var enemy_scene : PackedScene
@onready var player = $"../player"
@onready var water = $"../water"
@onready var break_timer = $"../break_timer"
var enemy
var wave = "wave_1"
var enemy_count = 1
var spawn_enemies = 1
var wave1_enemies = 8
var wave2_enemies = 16
var wave3_enemies = 24
var break_line = 975
var break_water = 1500
var day = 0
var new_day_water = 1875
var new_day_shore = 1280
var wave1_line = 475
var wave1_limit = 200
var wave1_water = 975
var wave2_line = 400
var wave2_limit = 175
var wave2_water = 900
var wave3_line = 350
var wave3_limit = 150
var wave3_water = 850
var water_position = 975
var t = 0.0
var GONEXT = false

func move_water(old_shore, new_shore, new_limit, old_water, new_water, delta):
	old_shore = old_shore - day * 25
	new_shore = new_shore - day * 25
	player.shoreline = clamp(player.shoreline, new_limit, new_shore)
	t += delta * .5
	var new_t = (1 - cos(PI * t)) / 2
	player.shoreline = old_shore + (new_shore - old_shore) * new_t
	water.position.x = old_water + (new_water - old_water) * new_t
	t = clamp(t, 0, 1)
	
func _physics_process(delta):
	match wave:
		"wave_1":
			#spawn_enemies = wave1_enemies
			move_water(new_day_shore, wave1_line, wave1_limit, new_day_water, wave1_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_1"
				t = 0
			pass
		"break_1":
			move_water(wave1_line, break_line, break_line, wave1_water, break_water, delta)
			if(break_timer.is_stopped()):
				break_timer.start()
			print(break_timer.time_left)
			if(GONEXT):
				wave = "wave_2"
				GONEXT = false
		"wave_2":
			spawn_enemies = wave2_enemies
			print("wave2")
			move_water(break_line, wave2_line, wave2_limit, break_water, wave2_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_2"
			pass
		"break_2":
			player.shoreline = break_line
			pass
		"wave_3":
			spawn_enemies = wave3_enemies
			player.shoreline = wave3_line - day * 25
			player.shoreline = clamp(player.shoreline, 150, wave3_line)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_3"
			pass
		"break_3":
			player.shoreline = break_line
			pass
			
func _on_spawn_timer_timeout():
	if(spawn_enemies > 0):
		enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.position.x = 1350
		enemy.position.y = randi() % 721
		spawn_enemies -= 1
		print(spawn_enemies)



func _on_break_timer_timeout():
	GONEXT = true
	print("GONEXT")
