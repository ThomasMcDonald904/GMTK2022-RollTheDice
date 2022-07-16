# BaseWorld.gd
extends Node

var player = preload("res://Characters/Player.tscn")
var player1_script = load("res://Scripts/Player1.gd")
var player2_script = load("res://Scripts/Player2.gd")

onready var player1 = player.instance()
onready var player2 = player.instance()

var attacked = false
# This is temporary until a player selection is put in place
func _ready():
	player1.set_script(player1_script)
	player2.set_script(player2_script)
	player1.global_position = $PlayerSpawn.global_position
	player2.global_position = $PlayerSpawn2.global_position
	player2.get_node("PlayerAnimator").flip_h = true
	add_child_below_node($".", player1, true)
	add_child_below_node($".", player2, true)
	

func _process(delta):
	manage_player_turns()

func manage_player_turns():
	if attacked == false:
		$UI/MainText/Label.text = "Player 1"
		$UI/MainText.show()
		player2.is_aim_locked = true
		if player1.has_let_go == true:
			$UI/MainText/Label.text = "Player 2"
			player1.is_aim_locked = true
			player2.is_aim_locked = false
			if player2.has_let_go == true:
				player2.is_aim_locked = true
		
		if player1.is_aim_locked and player2.is_aim_locked:
			player_attack()
			attacked = true

func player_attack():
	yield(get_tree(), "idle_frame") # returns a GDScriptFunctionState object to _ready()
	$UI/MainText/Label.text = "3"
	yield(get_tree().create_timer(1.0), "timeout")
	$UI/MainText/Label.text = "2"
	yield(get_tree().create_timer(1.0), "timeout")
	$UI/MainText/Label.text = "1"
	yield(get_tree().create_timer(1.0), "timeout")
	$UI/MainText/Label.text = "Attack!"
	player1.shoot_arrow()
	player2.shoot_arrow()
	print("finished player attacking")

