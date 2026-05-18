extends Area2D

@onready var sprite: AnimatedSprite2D = $sprite
@onready var explosion_sprite: AnimatedSprite2D = $explosion_sprite
@onready var explosion_sound = $explosion_sound
var played_sound = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if explosion_sprite.frame > 0:
		set_collision_layer_value(2, false)
		set_collision_layer_value(2, false)

func _on_missile_timer_timeout() -> void:
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	z_index = 4
	sprite.visible = false
	explosion_sprite.visible = true
	explosion_sprite.play("default")
	if(!played_sound):
		explosion_sound.play()
		played_sound = true

func _on_explosion_sprite_animation_finished() -> void:
	sprite.visible = false
	explosion_sprite.stop()
	explosion_sprite.visible = false


func _on_explosion_sound_finished():
	queue_free()
