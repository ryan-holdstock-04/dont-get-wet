extends RichTextLabel

@onready var player = $"../../player"
@onready var enemy_spawner: Node2D = $"../../enemy_spawner"

func _process(delta):
	var title = "Player Stats\n"
	var health = str(player.health) + "/" + str(player.max_health) + " HP\n"
	var attack_speed = str(1/player.fire_speed) + " Attacks/Sec\n"
	var dash_speed = str(("%0.2f" % (1/player.can_pounce_timer.wait_time))) + " Dashes/Sec"
	text = title + health + attack_speed + dash_speed
	
