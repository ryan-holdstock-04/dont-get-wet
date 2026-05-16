extends CharacterBody2D


const speed = 300.0
@onready var indicator = $indicator
@onready var fire_timer = $fire_timer
@onready var sprite = $sprite
@onready var pounce_timer = $pounce_timer
@onready var can_pounce_timer = $can_pounce_timer
@export var fire_speed = 1.0
@export var bullet_scene : PackedScene
@onready var hurt_anim = $hurt_anim
var mouse_norm
var health = 100
var can_fire = true
var pouncing = false
var pounced = false
var can_pounce = true

func _ready():
	fire_timer.wait_time = fire_speed

func _input(event):
	# bullet firing
	if event.is_action_pressed("click") and can_fire:
		fire()
		can_fire = false
		fire_timer.wait_time = fire_speed
		fire_timer.start()
	if event.is_action_pressed("pounce") and can_pounce:
		pouncing = true
		can_pounce = false
		can_pounce_timer.start()

func _physics_process(delta: float) -> void:
	
	# basic movement
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction.normalized() * speed
	animate()
	position.x = clamp(position.x,0 + 6*8,1280)
	position.y = clamp(position.y,0 + 25,720-25)
	if(pouncing == true):
		velocity.x *= 5
		velocity.y *= 5
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
	velocity.x *= (1/3)
	velocity.y *= (1/3)
	pounced = false
	pouncing = false

func _on_can_pounce_timer_timeout():
	can_pounce = true
