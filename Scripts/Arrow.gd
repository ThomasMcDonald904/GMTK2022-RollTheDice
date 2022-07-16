extends RigidBody2D

func _physics_process(delta):
#	var radians
#	radians = atan(linear_velocity.x/linear_velocity.y)
#	rotation = radians
#
	print(angular_velocity)
	for i in get_colliding_bodies():
		if i.name == "Floor":
			mode = RigidBody2D.MODE_STATIC
