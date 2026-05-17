extends Area2D

@onready var sprite: AnimatedSprite2D = $sprite
@onready var explosion_sprite: AnimatedSprite2D = $explosion_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_missile_timer_timeout() -> void:
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	sprite.visible = false
	explosion_sprite.visible = true
	explosion_sprite.play("default")


func _on_explosion_sprite_animation_finished() -> void:
	queue_free()
