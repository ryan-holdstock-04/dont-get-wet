extends Node2D

@onready var spawn_timer = $spawn_timer
@export var enemy_scene : PackedScene
@export var upgrade_scene : PackedScene
@onready var player = $"../player"
@onready var water = $"../water"
@onready var break_timer = $"../break_timer"
@onready var day_text = $"../ui/day_text"
@onready var break_timer_text = $"../ui/break_timer_text"
@onready var player_boundary = $player_boundary
@onready var upgrade_timer: Timer = $upgrade_timer
@onready var daylight_player = $"../ui/daylight_player"
var daylight_played = false
var damage_ups = 0
var enemy_base_speed = 60
var enemy_base_health = 100
var enemy
var upgrade
var wave = "wave_1"
var enemy_count = 4
var spawn_enemies = 4
var wave1_enemies = 4
var wave2_enemies = 6
var wave3_enemies = 8
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
var damage_mult = 0
var leveledup = false

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
	day_text.text = "Day: " + str(day+1)
	if enemy != null:
		enemy.max_health = enemy_base_health
	if day > -1:
		player.pounce_unlocked = true
	if day > 0 and !leveledup:
		player.missile_unlocked = true
		leveledup = true
		player.levelup_sound.play()
	if day == 5:
		get_tree().change_scene_to_file('res://scenes/win.tscn')
	match wave:
		"wave_1":
			daylight_played = false
			spawn_timer.wait_time = 3.0 - 0.5 * day
			#spawn_enemies = wave1_enemies MOVE THIS TO BREAK 3 EXPIRING
			break_timer_text.text = "Enemies Left: " + str(enemy_count)
			enemy_base_speed = 60 + 5 * day
			enemy_base_health = 100 + 5 * day
			move_water(new_day_shore, wave1_line, wave1_limit, new_day_water, wave1_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				wave = "break_1"
				t = 0
				upgrade_timer.stop()
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
				upgrade_timer.start()
				t = 0
		"wave_2":
			enemy_base_health = 100 + 10 * day
			spawn_timer.wait_time = 2.5 - 0.5 * day
			enemy_base_speed = 70 + 5 * day
			break_timer_text.text = "Enemies Left: " + str(enemy_count)
			move_water(break_line, wave2_line, wave2_limit, break_water, wave2_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				upgrade_timer.stop()
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
				upgrade_timer.start()
				t = 0
			pass
		"wave_3":
			spawn_timer.wait_time = 2.0 - 0.5 * day
			enemy_base_speed = 80 + 10 * day
			enemy_base_health = 100 + 20 * day
			break_timer_text.text = "Enemies Left: " + str(enemy_count)
			move_water(break_line, wave3_line, wave3_limit, break_water, wave3_water, delta)
			if(enemy_count == 0):
				spawn_timer.stop()
				upgrade_timer.stop()
				wave = "break_3"
				t = 0
				day += 1
			pass
		"break_3":
			move_water(wave3_line, new_day_water, new_day_shore, wave3_water, new_day_water, delta)
			if(break_timer.is_stopped() and !GONEXT):
				break_timer.start()
			break_timer_text.text = "Next Wave: " + str(int(break_timer.time_left))
			if(!daylight_player.is_playing() and !daylight_played):
				daylight_player.play("daylight")
				daylight_played = true
			if(GONEXT):
				wave = "wave_1"
				GONEXT = false
				spawn_enemies = wave1_enemies
				enemy_count = wave1_enemies
				spawn_timer.start()
				upgrade_timer.start()
				t = 0
				wave1_enemies = wave1_enemies + (day+1) * 4
				wave2_enemies = wave2_enemies + (day+1) * 6
				wave3_enemies = wave3_enemies + (day+1) * 8
			pass
			
func _on_spawn_timer_timeout():
	if(spawn_enemies > 0):
		enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.position.x = 1350
		enemy.position.y = randi() % 721
		enemy.speed = randi() % 100 + enemy_base_speed
		spawn_enemies -= 1
		enemy.health = enemy_base_health
		enemy.health_bar.max_value = enemy_base_health
		enemy.damage_mult = 2.5 * damage_ups

func upgrades():
	var upgrades = ["attack_speed", "heal", "attack_damage", "speed", "dash_timer", "rocket_timer"]
	var rand : int
	var pos : int
	if(day == 0):
		rand = randi() % 4
	elif(day == 1):
		rand = randi() % 5
	elif(day >= 2):
		rand = randi() % 6
	if(wave == "wave_1"):
		pos = wave1_line+100
	elif(wave == "wave_2"):
		pos = wave2_line+100
	elif(wave == "wave_3"):
		pos = wave3_line+100
	else:
		pos = 99999
	upgrade = upgrade_scene.instantiate()
	get_parent().add_child(upgrade)
	upgrade.up_type = upgrades[rand]
	var num = (randi() % (break_line-pos)) + pos
	upgrade.position.x = num
	upgrade.position.y = randi() % 621 + 50
	if(upgrade.up_type == "attack_speed"):
		upgrade.target_sprite.visible = false
		upgrade.ammo_sprite.visible = true
		upgrade.heal_sprite.visible = false
		upgrade.speed_sprite.visible = false
		upgrade.dash_sprite.visible = false
		upgrade.missile_sprite.visible = false
	elif(upgrade.up_type == "attack_damage"):
		upgrade.target_sprite.visible = true
		upgrade.ammo_sprite.visible = false
		upgrade.heal_sprite.visible = false
		upgrade.speed_sprite.visible = false
		upgrade.dash_sprite.visible = false
		upgrade.missile_sprite.visible = false
	elif(upgrade.up_type == "heal"):
		upgrade.target_sprite.visible = false
		upgrade.ammo_sprite.visible = false
		upgrade.heal_sprite.visible = true
		upgrade.speed_sprite.visible = false
		upgrade.dash_sprite.visible = false
		upgrade.missile_sprite.visible = false
	elif(upgrade.up_type == "speed"):
		upgrade.target_sprite.visible = false
		upgrade.ammo_sprite.visible = false
		upgrade.heal_sprite.visible = false
		upgrade.speed_sprite.visible = true
		upgrade.dash_sprite.visible = false
		upgrade.missile_sprite.visible = false
	elif(upgrade.up_type == "dash_timer"):
		upgrade.target_sprite.visible = false
		upgrade.ammo_sprite.visible = false
		upgrade.heal_sprite.visible = false
		upgrade.speed_sprite.visible = false
		upgrade.dash_sprite.visible = true
		upgrade.missile_sprite.visible = false
	elif(upgrade.up_type == "rocket_timer"):
		upgrade.target_sprite.visible = false
		upgrade.ammo_sprite.visible = false
		upgrade.heal_sprite.visible = false
		upgrade.speed_sprite.visible = false
		upgrade.dash_sprite.visible = false
		upgrade.missile_sprite.visible = true

func _on_break_timer_timeout():
	GONEXT = true

func _on_upgrade_timer_timeout() -> void:
	upgrades()
