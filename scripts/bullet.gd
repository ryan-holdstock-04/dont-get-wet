extends Area2D

@onready var direction = [0,0]
@onready var sprite = $sprite

@export var bullet_speed = 750
var x_angular_scalar
var y_angular_scalar
var x_velocity
var y_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if direction != null:
		var x_velocity = direction[0] * bullet_speed * delta
		var y_velocity = direction[1] * bullet_speed * delta

		# accelerates the bullet based on diagonality
		# makes bullet speed look more consistent
		var x_angular_scalar = abs(sin(direction[0]*PI))
		var y_angular_scalar = abs(sin(direction[1]*PI))
		x_velocity *= 1 + x_angular_scalar/3
		y_velocity *= 1 + y_angular_scalar/3

		position.x += x_velocity
		position.y += y_velocity
	else:
		queue_free()
		
	_free()

# causes the bullet to bounce of the walls
func bouncing():
	if(position.x > 1280 || position.x < 0):
		direction[0] = -direction[0]
	elif(position.y > 720 || position.y < 0):
		direction[1] = -direction[1]

# deletes the bullet when it leaves the scene
func _free():
	if(position.x > 1280 || position.x < 0 || position.y > 720 || position.y < 0):
		queue_free()
		
#bullets bounce of eachother (bugged, they get stuck together sometimes)
#func _on_area_entered(area):
	#direction[0] = -direction[0]
	#direction[1] = -direction[1]
