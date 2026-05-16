extends Area2D

@export var health = 100
@export var speed = 120
@onready var hurt_anim = $hurt_anim
@onready var enemy_spawner = $"../enemy_spawner"
func _ready():
	pass
	
func _physics_process(delta):
	
	# dies if hp < 0
	if health <= 0:
		enemy_spawner.enemy_count -= 1
		queue_free()
		
	
	# moves towards the player
	var player = get_tree().get_nodes_in_group("player")
	var direction = [player[0].position.x,player[0].position.y]
	var mag = [direction[0] - position.x, direction[1] - position.y]
	var total = abs(mag[0]) + abs(mag[1])
	direction = [mag[0]/total, mag[1]/total]
	var x_velocity = direction[0] * speed * delta
	var y_velocity = direction[1] * speed * delta
		
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
	
	# player bullets colliding with enemy
	if(groups[0] == "player_bullet"):
		hurt_anim.play("hit")
		if(hurt_anim.is_animation_active()):
			hurt_anim.stop()
			hurt_anim.play()
		area.queue_free()
		health -= 20

func _on_body_entered(body):
	var groups = body.get_groups()
	
	# enemy colliding with player
	if(groups[0] == "player"):
		body.health -= 20
		body.hurt_anim.play("hit")
		print("player")
