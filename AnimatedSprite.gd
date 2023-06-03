extends AnimatedSprite
onready var hitboxspawn := get_node("%HitboxSpawnLocation")
onready var collisionTimer := get_node("%CollisionTimer")
onready var animations = frames.get_animation_names()
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func _on_CollisionTimer_timeout() -> void:
	#randi() return 2^32 - 1 
	var animation_id = randi() % animations.size()
	var animation_name = animations[animation_id]
	play(animation_name)
	if hitboxspawn.unit_offset < 0.5:
		flip_h = true
	else:
		flip_h = false
