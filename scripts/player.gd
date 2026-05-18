extends CharacterBody2D


var speed = 300.0
@onready var indicator = $indicator
@onready var fire_timer = $fire_timer
@onready var sprite = $sprite
@onready var pounce_timer = $pounce_timer
@onready var can_pounce_timer = $can_pounce_timer
@onready var fire_speed = 1.0
@export var bullet_scene : PackedScene
@export var missile_scene : PackedScene
@onready var hurt_anim = $hurt_anim
@export var shoreline = 475
@onready var i_frames: Timer = $i_frames
@onready var missile_timer: Timer = $missile_timer
@onready var shoot_sound = $shoot_sound
@onready var levelup_sound = $levelup_sound
var damage_mult = 1.0
@onready var dead_sprite = $dead_sprite

var mouse_norm
var health = 100
var max_health = 100
var can_fire = true
var pouncing = false
var pounced = false
var can_pounce = true
var can_missile = true
var missile_wait = 5.0
var pounce_wait = 3.0
var player_hit = false
var pounce_unlocked = false
var missile_unlocked = false
var hiss_played = false
var gameover = false
var not_gameover_sound = false
func _input(event):
	# bullet firing
	fire_timer.wait_time = fire_speed
	if event.is_action_pressed("click") and can_fire:
		shoot_sound.play()
		fire()
		can_fire = false
		fire_timer.start()
	can_pounce_timer.wait_time = pounce_wait
	if event.is_action_pressed("pounce") and can_pounce and pounce_unlocked:
		pouncing = true
		can_pounce = false
		can_pounce_timer.start()
	missile_timer.wait_time = missile_wait
	if event.is_action_pressed("missile") and can_missile and missile_unlocked:
		missile_timer.start()
		can_missile = false
		var missile = missile_scene.instantiate()
		owner.add_child(missile)
		missile.position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	
	if(player_hit):
		if !hiss_played:
			$hiss_sound.play()
			hiss_played = true
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		if(i_frames.is_stopped()):
			i_frames.start(0.8)
	health = clamp(health, 0, max_health)
	if health <= 0:
		gameover = true
		sprite.visible = false
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		dead_sprite.visible = true
		can_fire = false
		if(!not_gameover_sound):
			$game_over_sound.play()
			not_gameover_sound = true
	fire_speed = clamp(fire_speed, 0.1, 1)
	# basic movement
	if !gameover:
		var direction = Input.get_vector("left","right","up","down")
		velocity = direction.normalized() * speed
		animate()
		shoreline = clamp(shoreline, 0, 1280)
		position.x = clamp(position.x,0 + 6*8,shoreline)
		position.y = clamp(position.y,0 + 25,720-25)
		if(pouncing == true):
			velocity.x *= 5
			velocity.y *= 5
			set_collision_layer_value(1, false)
			set_collision_mask_value(1, false)
			i_frames.start(0.4)
			if(!pounced):
				pounce_timer.start()
				pounced = true
	
	# gets mouse direction and normalizes it
	var mouse_mag = [get_global_mouse_position().x - position.x, get_global_mouse_position().y - position.y]
	var total = abs(mouse_mag[0]) + abs(mouse_mag[1])
	mouse_norm = [mouse_mag[0]/total, mouse_mag[1]/total]

	move_and_slide()

func fire():
	var bullet = bullet_scene.instantiate()
	owner.add_child(bullet)
	bullet.position = position
	bullet.direction = mouse_norm;

func animate():
	if(velocity[0] > 0):
		sprite.play("side_movement")
		sprite.flip_h = false
		sprite.flip_v = false
	elif(velocity[0] < 0):
		sprite.play("side_movement")
		sprite.flip_h = true
		sprite.flip_v = false
	elif(velocity[1] > 0):
		sprite.play("top_movement")
		sprite.flip_v = true
	elif(velocity[1] < 0):
		sprite.play("top_movement")
		sprite.flip_v = false
	else:
		sprite.play("side_idle")
		sprite.flip_v = false

func _on_timer_timeout():
	can_fire = true

func _on_pounce_timer_timeout():
	velocity.x *= (1/5)
	velocity.y *= (1/5)
	pounced = false
	pouncing = false

func _on_can_pounce_timer_timeout():
	can_pounce = true


func _on_i_frames_timeout() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	player_hit = false
	hiss_played = false


func _on_missile_timer_timeout() -> void:
	can_missile = true
