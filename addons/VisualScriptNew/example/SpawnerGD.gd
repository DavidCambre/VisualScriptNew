extends Node2D

func _on_Timer_timeout():
	var rigid_body = RigidBody2D.new()
	rigid_body.position = Vector2(450, 500)
	rigid_body.linear_velocity = Vector2(rand_range(-90, 90), -350)
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = 32
	var sprite = Sprite.new()
	sprite.texture = preload("res://icon.png")
	
	rigid_body.add_child(collision_shape)
	rigid_body.add_child(sprite)
	add_child(rigid_body)
