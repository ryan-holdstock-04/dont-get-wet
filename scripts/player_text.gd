extends RichTextLabel

@onready var player = $"../../player"
@onready var enemy_spawner: Node2D = $"../../enemy_spawner"

func _process(delta):
	var title = "Player Stats\n"
	var health =str(player.health) + "/" + str(player.max_health) + " HP" + " (+" + str(player.max_health - 100) + ")\n"
	var attack_speed = str(("%0.2f" % (1/player.fire_speed))) + " Attacks/Sec" + " (+" + str(("%0.2f" % (1/player.fire_speed - 1))) + ")\n"
	var attack_damage = str(player.damage_mult) + "x Damage" + " (+" + str(player.damage_mult - 1) + ")\n"
	var speed = str(player.speed) + " Move Speed" + " (+" + str(player.speed - 300) + ")\n"

	if player.pounce_unlocked and !player.missile_unlocked:
		var pounce_cd = "Pounce CD: " + str(player.pounce_wait) + " sec" + " (" + str(player.pounce_wait - 3) + ")\n"
		text = title + health + attack_speed + attack_damage + speed + pounce_cd
	elif player.pounce_unlocked and player.missile_unlocked:
		var pounce_cd = "Pounce CD: " + str(player.pounce_wait) + " sec" + " (" + str(player.pounce_wait - 3) + ")\n"
		var missile_cd = "Missile CD: " + str(player.missile_wait) + "sec" + " (" + str(player.missile_wait - 5) + ")\n"
		text = title + health + attack_speed + attack_damage + speed + pounce_cd + missile_cd
	else:
		text = title + health + attack_speed + attack_damage + speed
