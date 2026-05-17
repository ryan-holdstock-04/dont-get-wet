extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_missile_timer_timeout() -> void:
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
