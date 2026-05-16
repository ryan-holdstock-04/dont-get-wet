extends RichTextLabel

@onready var player = $"../../player"

func _process(delta):
	var title = "Player Stats\n"
	var attack_speed = str(1/player.fire_speed) + " Attacks/Sec\n"
	var dash_speed = str(("%0.2f" % (1/player.can_pounce_timer.wait_time))) + " Dashes/Sec"
	text = title + attack_speed + dash_speed
	
