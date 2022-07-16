# BaseWorld.gd
extends Node

var player = preload("res://Characters/Player.tscn")
var player1_script = load("res://Scripts/Player1.gd")
var player2_script = load("res://Scripts/Player2.gd")

var dice_preload = preload("res://Characters/Dice.tscn")

onready var player1 = player.instance()
onready var player2 = player.instance()

var list_of_dice_positions = []

var attacked = false
# This is temporary until a player selection is put in place
func _ready():
	
	player1.set_script(player1_script)
	player2.set_script(player2_script)
	player1.global_position = $PlayerSpawn.global_position
	player2.global_position = $PlayerSpawn2.global_position
	
	add_child(player1, true)
	add_child(player2, true)
	
	player2.get_node("PlayerAnimator").flip_h = true
	player2.get_node("CollisionPolygon2D").scale.x = -1
	player2.get_node("CollisionPolygon2D").position.x *= -1

	#This is played once until gameloop is finished
	dice_roll(175)
	yield(get_tree().create_timer(2), "timeout")
	clearMovingDice(175)
	dice_roll(175-43.75)
	

func _process(delta):
	manage_player_turns()

func clearMovingDice(roll_distance):
	for dice in $MovingDiceContainer.get_children():
		var still_dice = dice_preload.instance()
		still_dice.global_position = dice.get_node("RollingDice").global_position
		$MovingDiceContainer.remove_child(dice)
		$DiceContainer.add_child(still_dice)

func dice_roll(roll_distance):
	for dice_position in $DicePositionContainer.get_children():
		var dice_instance = dice_preload.instance()
		dice_instance.global_position = dice_position.global_position
		$MovingDiceContainer.add_child(dice_instance)
	for dice in $MovingDiceContainer.get_children():
		var animation_player = dice.get_node("AnimationPlayer")
		var animation = animation_player.get_animation("MoveDice")
		var track_idx = animation.find_track(".:position")
		animation.track_set_key_value(track_idx, 0, Vector2(dice.position.x, 0))
		animation.track_set_key_value(track_idx, 1, Vector2(dice.position.x, roll_distance))
		animation_player.play("MoveDice")


func manage_player_turns():
	if attacked == false:
		$MainText.show()
		$MainText/Label.text = "Player 1"
		player2.is_aim_locked = true
		if player1.has_let_go == true:
			$MainText/Label.text = "Player 2"
			player1.is_aim_locked = true
			player2.is_aim_locked = false
			if player2.has_let_go == true:
				player2.is_aim_locked = true
		
		if player1.is_aim_locked and player2.is_aim_locked:
			player_attack()
			attacked = true

func player_attack():
	yield(get_tree(), "idle_frame")
	$MainText/Label.text = "3"
	yield(get_tree().create_timer(1.0), "timeout")
	$MainText/Label.text = "2"
	yield(get_tree().create_timer(1.0), "timeout")
	$MainText/Label.text = "1"
	yield(get_tree().create_timer(1.0), "timeout")
	$MainText/Label.text = "Attack!"
	player1.shoot_arrow()
	player2.shoot_arrow()
	print("finished player attacking")

