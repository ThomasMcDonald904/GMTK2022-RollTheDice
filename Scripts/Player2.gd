extends KinematicBody2D

export (int) var speed = 600
export (int) var jump_speed = -700
export (int) var gravity = 3500

var arrow = preload("res://Characters/Arrow.tscn")

var distance_to_last_click = 0

var currently_clicking = false
var check_distance = false
var last_click
var last_click_global
var draw_distance = 0
var line = Line2D.new()
var bow_frame = 0

var arrow_is_super = false


var aiming_vector
var is_aim_locked = false
var has_let_go = false

func get_input():
#	if Input.is_action_pressed("ui_down"):
#		$PlayerAnimator.frame = 1
#	else: 
#		$PlayerAnimator.frame = 0
	pass

func draw_bow():
	if not is_aim_locked:
		if Input.is_action_just_pressed("drawBow"):
			last_click = get_local_mouse_position()
			last_click_global = get_global_mouse_position()
			check_distance = true
			has_let_go = false
			
		if Input.is_action_just_released("drawBow"):
			check_distance = false
			draw_distance = 0
			line.hide()
			$"../DistanceHolder".hide()
			has_let_go = true
		if check_distance == true and Input.is_action_pressed("drawBow"):
			line.show()
			draw_distance = round(clamp(get_local_mouse_position().distance_to(last_click), 0, 500))
			line.points = [last_click, get_local_mouse_position()]
			line.default_color = Color.black
			add_child_below_node($"..", line)

			aiming_vector = -(get_global_mouse_position() - last_click_global)
			var point_to_aim_at = global_position + aiming_vector
			$Bow.look_at(point_to_aim_at)

			bow_frame = round(range_lerp(draw_distance, 0, 500, 0, 3))
			$Bow.frame = bow_frame
			$"../DistanceHolder/Distance".text = str(draw_distance)
			$"../DistanceHolder".show()

func shoot_arrow():
	if arrow_is_super == false:
		var arrow_instance = arrow.instance()
		arrow_instance.global_position = $"Bow/Position2D".global_position
		arrow_instance.rotation = $Bow.rotation
		get_parent().add_child(arrow_instance)
		arrow_instance.apply_impulse(Vector2(), aiming_vector)
		

func _physics_process(delta):
	get_input()
	draw_bow()
#	print("P2 - ", has_let_go)
