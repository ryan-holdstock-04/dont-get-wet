extends Node2D

@onready var start_button = $UI/MarginContainer/VBoxContainer/start_button
@onready var tutorial_button = $UI/MarginContainer/VBoxContainer/tutorial_button
@onready var exit_button = $UI/MarginContainer/VBoxContainer/exit_button
@onready var tutorial = $UI/tutorial
@onready var back_button = $UI/tutorial/back_button
@onready var tut1 = $UI/tut1
@onready var tut2 = $UI/tut2
@onready var tut3 = $UI/tut3
@onready var tut4 = $UI/tut4
@onready var tut5 = $UI/tut5
@onready var tut6 = $UI/tut6
@onready var tut7 = $UI/tut7

func _process(delta):
	if start_button.is_hovered():
		start_button.text = "> Start"
	else:
		start_button.text = "Start"
	if exit_button.is_hovered():
		exit_button.text = "> Exit"
	else:
		exit_button.text = "Exit"
	if tutorial_button.is_hovered():
		tutorial_button.text = "> Tutorial"
	else:
		tutorial_button.text = "Tutorial"


func _on_start_button_pressed():
	get_tree().change_scene_to_file('res://scenes/main.tscn')

func _on_tutorial_button_pressed():
	tutorial.visible = true
	back_button.visible = true
	tut1.visible = true
	tut2.visible = true
	tut3.visible = true
	tut4.visible = true
	tut5.visible = true
	tut6.visible = true
	tut7.visible = true

func _on_exit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	tutorial.visible = false
	back_button.visible = false
	tut1.visible = false
	tut2.visible = false
	tut3.visible = false
	tut4.visible = false
	tut5.visible = false
	tut6.visible = false
	tut7.visible = false
