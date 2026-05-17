extends Area2D

var upgrades = ["attack_speed", "heal", "attack_damage", "dash_timer", "rocket_timer"]
@onready var heal_sprite: AnimatedSprite2D = $heal_sprite
@onready var ammo_sprite: AnimatedSprite2D = $ammo_sprite
@export var up_type = "sussy"
@onready var target_sprite: AnimatedSprite2D = $target_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print(up_type)
