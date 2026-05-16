extends Node2D

@onready var spawn_timer = $spawn_timer
@export var enemy_scene : PackedScene
@onready var player = $"../player"
@onready var water = $"../water"
@onready var break_timer = $"../break_timer"
@onready var day_text = $"../ui/day_text"
@onready var break_timer_text = $"../ui/break_timer_text"
@onready var player_boundary = $player_boundary
var enemy_base_speed = 60
var enemy
var wave = "wave_1"
var enemy_count = 8
var spawn_enemies = 8
var wave1_enemies = 8
var wave2_enemies = 12
var wave3_enemies = 16
var break_line = 975
var break_water = 1500
var day = 0
var new_day_water = 1875
var new_day_shore = 1280
var wave1_line = 475
var wave1_limit = 100
var wave1_water = 975
var wave2_line = 375
var wave2_limit = 100
var wave2_water = 875
var wave3_line = 300
var wave3_limit = 100
var wave3_water = 800
var water_position = 975
var t = 0.0
var GONEXT = false

func move_water(old_shore, new_shore, new_limit, old_water, new_water, delta):
	old_shore = old_shore - day * 50
	new_shore = new_shore - day * 50
	player.shoreline = clamp(player.shoreline, new_limit, new_shore)
	t += delta * .5
	var new_t = (1 - cos(PI * t)) / 2
	player.shoreline = old_shore + (new_shore - old_shore) * new_t
	water.position.x = old_water + (new_water - old_water) * new_t
	t = clamp(t, 0, 1)
	
func _physics_process(delta):
	player.shoreline = clamp(player.shoreline, 0, 1280)
	player_boundary.set_point_position(0, Vector2(player.shoreline, 0))
	player_boundary.set_point_position(1, Vector2(player.shoreline, 720))
	day_text.text = "Day: " + str(day)
	match wave:
		"wave_1":
			spawn_timer.wait_time = 3.0 - 0.5 * day
			#spawn_enemies = wave1_enemies MOVE THIS TO BREAK 3 EXPIRING
			break_timer_text.text = "Enemies Left: " + str(enemy_count)
			enemy_base_speed = 60 + 20 * day
			move_water(new_day_shore, wave1_line, wave1_limit, new_day_water, wave1_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_1"
				t = 0
			pass
		"break_1":
			move_water(wave1_line, break_line, break_line, wave1_water, break_water, delta)
			if(break_timer.is_stopped() and !GONEXT):
				break_timer.start()
			break_timer_text.text = "Next Wave: " + str(int(break_timer.time_left))
			if(GONEXT):
				wave = "wave_2"
				GONEXT = false
				spawn_enemies = wave2_enemies
				enemy_count = wave2_enemies
				spawn_timer.start()
				t = 0
		"wave_2":
			spawn_timer.wait_time = 2.5 - 0.5 * day
			enemy_base_speed = 70 + 20 * day
			break_timer_text.text = "Enemies Left: " + str(enemy_count)
			move_water(break_line, wave2_line, wave2_limit, break_water, wave2_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_2"
				t = 0
			pass
		"break_2":
			move_water(wave2_line, break_line, break_line, wave2_water, break_water, delta)
			if(break_timer.is_stopped() and !GONEXT):
				break_timer.start()
			break_timer_text.text = "Next Wave: " + str(int(break_timer.time_left))
			if(GONEXT):
				wave = "wave_3"
				GONEXT = false
				spawn_enemies = wave3_enemies
				enemy_count = wave3_enemies
				spawn_timer.start()
				t = 0
			pass
		"wave_3":
			spawn_timer.wait_time = 2.0 - 0.5 * day
			enemy_base_speed = 80 + 20 * day
			break_timer_text.text = "Enemies Left: " + str(enemy_count)
			move_water(break_line, wave3_line, wave3_limit, break_water, wave3_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_3"
				t = 0
			pass
		"break_3":
			move_water(wave3_line, new_day_water, new_day_shore, wave3_water, new_day_water, delta)
			if(break_timer.is_stopped() and !GONEXT):
				break_timer.start()
			break_timer_text.text = "Next Wave: " + str(int(break_timer.time_left))
			if(GONEXT):
				wave = "wave_1"
				GONEXT = false
				spawn_enemies = wave1_enemies
				enemy_count = wave1_enemies
				spawn_timer.start()
				t = 0
				day += 1
			pass
			
func _on_spawn_timer_timeout():
	if(spawn_enemies > 0):
		enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.position.x = 1350
		enemy.position.y = randi() % 721
		enemy.speed = randi() % 100 + enemy_base_speed
		spawn_enemies -= 1



func _on_break_timer_timeout():
	GONEXT = true
