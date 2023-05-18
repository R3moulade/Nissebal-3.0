extends Control
class_name Main

export (PackedScene) var hitbox_scene
var hitbox_spawn_location
var score = 0 setget set_score
var highscore = 0 setget set_highscore
onready var hudContainer := $HUD/HUDGame
onready var hudStandby := $HUD/HUDStandby
onready var countdownTimer := $CountdownTimer
onready var collisionTimer := $Slider/CollisionTimer
onready var endTimer := $End/EndTimer
onready var hudTimer := $HUD/HUDGame/Timer
onready var hudScore := $HUD/HUDGame/Score
onready var animations := $AnimationPlayer
onready var animations2 := $AnimationPlayer2
onready var animations3 := $AnimationPlayer3
onready var animations4 := $AnimationPlayer4
onready var arrow := $Slider/Slider/Arrow
onready var hitbox := $Slider/Slider/HitboxPath/HitboxSpawnLocation/Hitbox
onready var fiveSecondsLeft := $Slider/CountdownTimer5sec
onready var between := $Slider/Slider/HitboxPath/HitboxSpawnLocation/Hitbox/Between
onready var middle := $Slider/Slider/HitboxPath/HitboxSpawnLocation/Hitbox/Middle
onready var scoreIncrease := $Slider/ScoreIncrease


func _ready():
	randomize()
	hitbox_spawn_location = $Slider/Slider/HitboxPath/HitboxSpawnLocation
	hudContainer.hide()
	self.score = -10
	
func _process(delta: float) -> void:
	if countdownTimer.time_left > 0:
		fiveSecondsLeft.text = str(int(countdownTimer.time_left) + 1)
	if hitbox.overlaps_area(arrow):
		if !animations2.is_playing() && animations.get_current_animation() != "EndScene":
			animations2.play("CollisionProgress")

func _on_CollisionTimer_timeout():
	#if the end scene is not playing...
	#prevents a bug on the animationplayer and continuation of play in the background.
	if animations.get_current_animation() != "EndScene":
		var hitbox = hitbox_scene.instance()
		
		#adds a hitbox at a random spot on the path
		hitbox_spawn_location.unit_offset = randf()
		hitbox_spawn_location.add_child(hitbox)
		hitbox.global_position = hitbox_spawn_location.global_position
		
		#updates the score. self accesses the setter method
		if score != -10:
			animations3.play("ScoreIncrease")
			
			if arrow.overlaps_area(between) && !arrow.overlaps_area(middle):
				self.score += 15
				scoreIncrease.text = "+15"
			elif arrow.overlaps_area(middle):
				self.score += 30
				scoreIncrease.text = "+30"
			else:
				self.score += 5
				scoreIncrease.text = "+5"
		else:
			self.score = 0
		#character jumps
		animations2.play("RESET")
		animations.play("Nansen")
		
		#Removes the hitbox that was collisioned
		if hitbox_spawn_location.get_child_count() == 2:
			hitbox.queue_free()

#Fires when the score value is changed
func set_score(s_value):
	score = s_value
	hudScore.set_text(str(score))
	#Game start
	if score == 0:
		countdownTimer.one_shot = false
		countdownTimer.start()
		countdownTimer.one_shot = true
		hudContainer.show()
		hudStandby.hide()
		animations4.play("RESET")
		animations4.play("CountdownProgress")
		

func set_highscore(hs_value):
	highscore = hs_value

#when the arrow enters the hitbox, start the timer
#func _on_Hitbox_area_entered(area: Area2D) -> void:
#	collisionTimer.start()
#	timerLabel.show()
#	animations2.play("CollisionProgress")

#when the arrow leaves the hitbox, restart the timer
func _on_Hitbox_area_exited(area: Area2D) -> void:
	collisionTimer.stop()
	animations2.play("RESET")

#when the game is over
func _on_CountdownTimer_timeout() -> void:
	endTimer.start()
	endTimer.one_shot = true
	$End/EndContainer/FinalScore.set_text(str(self.score))
	animations.play("EndScene")
	fiveSecondsLeft.text = "Tiden er gået!"
	#sets the highscore
	if self.score > self.highscore:
		highscore = score
		$End/EndContainer/Highscore.set_text("Ny highscore! \n" + str(self.highscore))
	else:
		$End/EndContainer/Highscore.set_text("Highscore \n" + str(self.highscore))
		

#when the full loop of the game is over
func _on_EndTimer_timeout() -> void:
	self.score = -10
	endTimer.one_shot = false
	hudContainer.hide()
	hudStandby.show()
	animations4.play("RESET")
