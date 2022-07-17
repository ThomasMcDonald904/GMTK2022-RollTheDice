extends Control


func _on_Yes_button_up():
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_No_button_up():
	get_tree().change_scene("res://Scenes/Credits.tscn")
