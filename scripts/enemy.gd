extends Area2D

@export var health = 100
@export var speed = 120
@onready var hurt_anim = $hurt_anim
@onready var hurt_z = $hurt_z
@onready var enemy_spawner = $"../enemy_spawner"
@onready var bounce_timer: Timer = $bounce_timer
@onready var invert = 1
@onready var health_bar: ProgressBar = $health_bar
@onready var bullet_damage = 20
@onready var missile_damage = 50
@onready var knockback_timer = $knockback_timer
@onready var damage_mult
@onready var max_health = 100
@onready var death_sound = $death_sound
@onready var dead_sprite = $dead_sprite
@onready var sprite = $sprite
var died = false
var hurt_playing = false

func _ready():
	pass
	
func _physics_process(delta):
	health_bar.value = health
	health_bar.max_value = max_health
	var style_box: StyleBoxFlat = health_bar.get_theme_stylebox("fill")
	if(health < 80 and health > 30):
		style_box.bg_color = Color(255,206,0,255)
	elif(health <= 30):
		style_box.bg_color = Color(0.836, 0.0, 0.0, 1.0)
	
	# dies if hp < 0
	if health <= 0 and !died:
		enemy_spawner.enemy_count -= 1
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, false)
		sprite.visible = false
		dead_sprite.visible = true
		death_sound.play()
		died = true
		
	
	# moves towards the player
	if !died:
		var player = get_tree().get_nodes_in_group("player")
		var direction = [player[0].position.x,player[0].position.y]
		var mag = [direction[0] - position.x, direction[1] - position.y]
		var total = abs(mag[0]) + abs(mag[1])
		direction = [mag[0]/total, mag[1]/total]
		var x_velocity = direction[0] * invert * speed * delta
		var y_velocity = direction[1] * invert * speed * delta
			
		# accelerates the enemy based on diagonality
		# makes speed look more consistent
		var x_angular_scalar = abs(sin(direction[0]*PI))
		var y_angular_scalar = abs(sin(direction[1]*PI))
		x_velocity *= 1 + x_angular_scalar/3
		y_velocity *= 1 + y_angular_scalar/3

		position.x += x_velocity
		position.y += y_velocity

func _on_area_entered(area):
	var groups = area.get_groups()
	if(!hurt_playing and (groups[0] == "player_bullet" or groups[0] == "missile")):
		$crab_hurt.play()
		hurt_playing = true
	# player bullets colliding with enemy
	if(groups[0] == "player_bullet"):
		hurt_playing = false
		hurt_anim.play("hit")
		z_index = 3
		hurt_z.start()
		if(hurt_anim.is_animation_active()):
			hurt_anim.stop()
			hurt_anim.play()
		area.queue_free()
		health -= bullet_damage + damage_mult
	elif(groups[0] == "missile"):
		hurt_playing = false
		hurt_anim.play("hit")
		z_index = 3
		hurt_z.start()
		if(hurt_anim.is_animation_active()):
			hurt_anim.stop()
			hurt_anim.play()
		health -= missile_damage + damage_mult
		knockback_timer.start()
		if(area.position.x > position.x):
			invert = 3
		else:
			invert = -3

func _on_body_entered(body):
	var groups = body.get_groups()
	
	# enemy colliding with player
	if(groups[0] == "player"):
		body.health -= 10
		body.hurt_anim.play("hit")
		bounce_timer.start()
		invert = -5
		body.player_hit = true


func _on_hurt_z_timeout():
	z_index = 0

func _on_bounce_timer_timeout() -> void:
	invert = 1

func _on_knockback_timer_timeout():
	invert = 1


func _on_death_sound_finished():
	queue_free()
