extends MarginContainer

@onready var player = $"../../player"
@onready var abilities = $"../abilities"
@onready var health_bar = $"../health_bar"
@onready var break_timer_text = $"../break_timer_text"

func _process(delta):
	if(player.gameover):
		abilities.visible = false
		health_bar.visible = false
		visible = true
		
func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file('res://scenes/menu.tscn')
