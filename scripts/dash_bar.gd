extends ProgressBar

@onready var player: CharacterBody2D = $"../../../player"
@onready var text = $text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.pounce_unlocked:
		value = 100-(player.can_pounce_timer.time_left/player.can_pounce_timer.wait_time*100)
		text.text = "SPACE"
	else:
		value = 0
		text.text = "LOCKED"
	var style_box: StyleBoxFlat = get_theme_stylebox("fill")
	if(value < 100):
		style_box.border_width_top = 0
