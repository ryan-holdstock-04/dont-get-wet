extends Area2D

@onready var direction = [0,0]

@export var bullet_speed = 500
var x_angular_scalar
var y_angular_scalar
var x_velocity
var y_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
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
	if(position.x > 1280 || position.x < 0):
		if(direction[0] > 0):
			direction[0] = 1-direction[0]
		elif(direction[0] < 0):
			direction[0] = -1+direction[0]
	elif(position.y > 720 || position.y < 0):
		if(direction[1] < 0):
			direction[1] = 1-direction[0]
		elif(direction[1] > 0):
			direction[1] = -1+direction[0]
	print(abs(direction[0]) + abs(direction[1]))
		
