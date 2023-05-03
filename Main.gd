extends Control
class_name Main

export (PackedScene) var hitbox_scene
var hitbox_spawn_location
var score = 0 setget set_score
onready var timerLabel = $Slider/TimerLabel
onready var hudContainer = $HUD/HUDContainer
onready var countdownTimer = $CountdownTimer
onready var collisionTimer = $CollisionTimer
onready var endTimer = $End/EndTimer
onready var hudTimer = $HUD/HUDContainer/Timer
onready var hudScore = $HUD/HUDContainer/Score

func _ready():
	randomize()
	hitbox_spawn_location = $Slider/HitboxPath/HitboxSpawnLocation
	timerLabel.hide()
	hudContainer.hide()
	self.score = -10
	
	
func _process(delta: float) -> void:
	timerLabel.text = str(int(collisionTimer.time_left + 1))
	hudTimer.text = str(int(countdownTimer.time_left))

#func _set(property: String, value) -> bool:
	
func _on_CollisionTimer_timeout():
	var hitbox = hitbox_scene.instance()
	
	#adds a hitbox at a random spot on the path
	hitbox_spawn_location.unit_offset = randf()
	hitbox_spawn_location.add_child(hitbox)
	hitbox.global_position = hitbox_spawn_location.global_position
	
	#updates the score. self accesses the setter method
	self.score += 10
	
	#Removes the hitbox that was collisioned
	if hitbox_spawn_location.get_child_count() == 2:
		hitbox.queue_free()

#Fires when the score value is changed
func set_score(value):
	score = value
	hudScore.set_text(str(score))
	#Game start
	if score == 0:
		countdownTimer.one_shot = false
		countdownTimer.start()
		countdownTimer.one_shot = true
		hudContainer.show()

func _on_Hitbox_area_entered(area: Area2D) -> void:
	collisionTimer.start()
	timerLabel.show()

func _on_Hitbox_area_exited(area: Area2D) -> void:
	collisionTimer.stop()
	timerLabel.hide()

func _on_CountdownTimer_timeout() -> void:
	endTimer.start()
	endTimer.one_shot = true
	

func _on_EndTimer_timeout() -> void:
	self.score = -10
	endTimer.one_shot = false
	hudContainer.hide()
