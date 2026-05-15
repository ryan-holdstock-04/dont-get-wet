extends CharacterBody2D


const speed = 300.0
@onready var indicator = $indicator
@export var bullet_scene : PackedScene
var mouse_norm;

func _input(event):
	# bullet firing
	if event.is_action_pressed("click"):
		fire()

func _physics_process(delta: float) -> void:
	
	# basic movement
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction.normalized() * speed
	
	var mouse_mag = [get_global_mouse_position().x - position.x, get_global_mouse_position().y - position.y]
	var total = abs(mouse_mag[0]) + abs(mouse_mag[1])
	mouse_norm = [mouse_mag[0]/total, mouse_mag[1]/total]

	move_and_slide()

func fire():
	var bullet = bullet_scene.instantiate()
	owner.add_child(bullet)
	bullet.position = position
	bullet.direction = mouse_norm;
