extends RigidBody2D

signal damaged_p1(damage_amount)
signal damaged_p2(damage_amount)

func _ready():
	connect("damaged_p1", get_node("../Player"), "get_damage")
	connect("damaged_p2", get_node("../Player2"), "get_damage")

func _physics_process(delta):
	for i in get_colliding_bodies():
		if i.name == "Floor":
			mode = RigidBody2D.MODE_STATIC
		if i.name == "Player" and name != "P1Arrow":
			emit_signal("damaged_p1", 10)
			queue_free()
		if i.name == "Player2" and name != "P2Arrow":
			emit_signal("damaged_p2", 10)
			queue_free()
