extends Area2D

export var speed = 400.0
var slider_size = Vector2.ZERO

func _ready():
	slider_size = get_parent().rect_size
	print(slider_size)
	

func _process(delta):
	var direction : = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	position += direction * speed * delta
	
	#Limits the arrow's position to the parent (the slider)
	position.x = clamp(position.x, 86, slider_size.x - 86)
	
	#if Input.is_action_pressed("move_right"):
		#unit_offset += 0.01
	#if Input.is_action_pressed("move_left"):
		#unit_offset -= 0.01

		#$Arrow.position += unit_offset * direction * speed * delta
