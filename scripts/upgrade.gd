extends Area2D

var upgrades = ["attack_speed", "heal", "attack_damage", "speed", "dash_timer", "rocket_timer"]
@onready var heal_sprite: AnimatedSprite2D = $heal_sprite
@onready var ammo_sprite: AnimatedSprite2D = $ammo_sprite
@onready var target_sprite: AnimatedSprite2D = $target_sprite
@onready var speed_sprite = $speed_sprite
@onready var dash_sprite = $dash_sprite
@onready var missile_sprite = $missile_sprite
@export var up_type = "attack_speed"
var shrink = false
@onready var shrink_timer = $shrink_timer
var picked_up = false
var mult = false
@onready var pickup_sound = $pickup_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemy_spawner = get_tree().get_nodes_in_group("enemy_spawner")
	if mult:
		enemy_spawner[0].damage_ups += 1
		mult = false
	if shrink:
		scale *= .95

func _on_body_entered(body: Node2D) -> void:
	if !picked_up:
		pickup_sound.play()
		picked_up = true
		match(up_type):
			"attack_speed":
				body.fire_speed -= 0.1
				shrink = true
				shrink_timer.start()
			"heal":
				body.health += 20
				body.max_health += 10
				shrink = true
				shrink_timer.start()
			"attack_damage":
				body.damage_mult += .125
				mult = true
				shrink = true
				shrink_timer.start()
			"speed":
				body.speed += 25.0
				shrink = true
				shrink_timer.start()
			"dash_timer":
				body.pounce_wait -= .25
				shrink = true
				shrink_timer.start()
			"rocket_timer":
				body.missile_wait -= .25
				shrink = true
				shrink_timer.start()


func _on_shrink_timer_timeout():
	queue_free()
