extends ProgressBar

@onready var player: CharacterBody2D = $"../../../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = 100-(player.can_pounce_timer.time_left/player.can_pounce_timer.wait_time*100)
	var style_box: StyleBoxFlat = get_theme_stylebox("fill")
	print(value)
	if(value < 100):
		style_box.border_width_top = 0
	else:
		style_box.border_width_top = 0
