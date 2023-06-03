extends AnimationPlayer
var animation_list = get_animation_list()
var random_animation = animation_list[randi() % animation_list.size()]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	play(random_animation)
	queue("RESET")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	play("RESET")
	random_animation = animation_list[randi() % animation_list.size()]
	play(random_animation)
	queue("RESET")
