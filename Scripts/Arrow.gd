extends RigidBody2D

signal damaged_p1(damage_amount)
signal damaged_p2(damage_amount)
signal increase_score_p1(score_amount)
signal increase_score_p2(score_amount)

func _ready():
	connect("damaged_p1", get_node("../Player"), "get_damage")
	connect("damaged_p2", get_node("../Player2"), "get_damage")
	connect("increase_score_p1", get_node("../Player"), "increase_score")
	connect("increase_score_p2", get_node("../Player2"), "increase_score")

func _physics_process(delta):
	for i in get_colliding_bodies():
		if i.name == "Floor":
			mode = RigidBody2D.MODE_STATIC
		if i.name == "Player" and not "P1Arrow" in name:
			emit_signal("damaged_p1", 10)
			mode = RigidBody2D.MODE_STATIC
		if i.name == "Player2" and not "P2Arrow" in name:
			emit_signal("damaged_p2", 10)
			mode = RigidBody2D.MODE_STATIC
		if "Dice" in i.name:
			if name == "P1Arrow":
				emit_signal("increase_score_p1", i.get_node("RollingDice").frame + 1)
				i.queue_free()
				queue_free()
			if name == "P2Arrow":
				emit_signal("increase_score_p2", i.get_node("RollingDice").frame + 1)
				i.queue_free()
				queue_free()
