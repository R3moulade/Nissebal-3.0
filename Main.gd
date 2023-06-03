extends Control
class_name Main

export (PackedScene) var hitbox_scene
var hitbox_spawn_location
var score = 0 setget set_score
var highscore = 0 setget set_highscore
onready var hudStandby := $HUD/HUDStandby
#the time in which the game is in-game
onready var countdownTimer := $CountdownTimer
onready var collisionTimer := $Slider/CollisionTimer
#the time for the end screen
onready var endTimer := $End/EndTimer
onready var animations := $AnimationPlayer
onready var animations2 := $AnimationPlayer2
onready var animations3 := $AnimationPlayer3
onready var animations4 := $AnimationPlayer4
onready var animations5 := $AnimationPlayer5
onready var arrow := $Slider/Slider/Arrow
onready var hitbox := $Slider/Slider/HitboxPath/HitboxSpawnLocation/Hitbox
onready var fiveSecondsLeft := $Slider/CountdownTimer5sec
onready var between := $Slider/Slider/HitboxPath/HitboxSpawnLocation/Hitbox/Between
onready var middle := $Slider/Slider/HitboxPath/HitboxSpawnLocation/Hitbox/Middle
onready var scoreIncrease := $Slider/ScoreIncrease
onready var standbyAnimations := $Character/NansenPuppet/AnimationPlayer


func _ready():
	#randomizes the number generator for randf()
	randomize()
	hitbox_spawn_location = $Slider/Slider/HitboxPath/HitboxSpawnLocation
	#the game starts when the score is 0, so it has to be <0 during standby
	self.score = -10
	$Character/DanceSprites.hide()
	$Character/NansenPuppet.show()
	$Character/NansenSprites.hide()
	

#a function which is called every frame
func _process(_delta: float) -> void:
	#display seconds left of the countdown timer. This is paired with animations5(CountdownProgress)
	if countdownTimer.time_left > 0:
		fiveSecondsLeft.text = str(int(countdownTimer.time_left) + 1)
	#plays animation; the slider filling up when the arrow is colliding with the hitbox
	if hitbox.overlaps_area(arrow):
		if !animations2.is_playing() && animations.get_current_animation() != "EndScene":
			animations2.play("CollisionProgress")

#function gets called when the CollisionTimer runs out. It's called in animations2(CollisionProgress).
#I'm using it as a symbol rather than an actual timer, because it's just called in the animation timeline.
#the time the user has to stay on the hitbox.
func _on_CollisionTimer_timeout():
	#if the end scene is not playing...
	#prevents a bug on the animationplayer and continuation of play in the background.
	if animations.get_current_animation() != "EndScene":
		#adds a hitbox at a random spot on the path
		var hitbox = hitbox_scene.instance()
		hitbox_spawn_location.unit_offset = randf()
		hitbox_spawn_location.add_child(hitbox)
		hitbox.global_position = hitbox_spawn_location.global_position
		
		#updates the score. self accesses the setter method
		#check if the game isn't in standby mode, and if it is, put it in in-game mode
		if score != -10:
			animations3.play("ScoreIncrease")
			#checks for which part of the hitbox the user has hit
			if arrow.overlaps_area(between) && !arrow.overlaps_area(middle):
				self.score += 15
				scoreIncrease.text = "Godt!"
			elif arrow.overlaps_area(middle):
				self.score += 30
				scoreIncrease.text = "Perfekt!"
				animations5.play("MusicNote")
			else:
				self.score += 5
				scoreIncrease.text = "Ok!"
		else:
			self.score = 0
		#CollisionProgress animation gets reset
		animations2.play("RESET")
		#character jumps
		animations.play("Nansen")
		
		#Removes the hitbox that was collisioned
		if hitbox_spawn_location.get_child_count() == 2:
			hitbox.queue_free()

#Gets called when the score value is changed
func set_score(s_value):
	score = s_value
	#In-Game start
	if score == 0:
		countdownTimer.one_shot = false
		countdownTimer.start()
		countdownTimer.one_shot = true
		hudStandby.hide()
		animations4.play("RESET")
		animations4.play("CountdownProgress")
		$Character/DanceSprites.show()
		$Character/NansenPuppet.hide()
		
		
#The highscore value for the end screen
func set_highscore(hs_value):
	highscore = hs_value

#when the arrow leaves the hitbox, restart the timer
func _on_Hitbox_area_exited(_area: Area2D) -> void:
	animations2.play("RESET")
	collisionTimer.stop()

#when the in-game is over
func _on_CountdownTimer_timeout() -> void:
	endTimer.start()
	endTimer.one_shot = true
	$Character/NansenSprites.show()
	$Character/NansenSprites.play("curtsey")
	$Character/DanceSprites.hide()
	#sets the user's final score and displays it
	$End/EndContainer/FinalScore.set_text(str(self.score))
	animations.play("EndScene")
	fiveSecondsLeft.text = "Tiden er gået!"
	#sets the highscore if the score is higher than the highscore and displays it
	if self.score > self.highscore:
		highscore = score
		$End/EndContainer/Highscore.set_text("Ny highscore! \n" + str(self.highscore))
	else:
		$End/EndContainer/Highscore.set_text("Highscore \n" + str(self.highscore))
		

#when the full loop of the game (in-game + end screen) is over
func _on_EndTimer_timeout() -> void:
	#resets the score
	self.score = -10
	endTimer.one_shot = false
	hudStandby.show()
	animations4.play("RESET")
	$Character/NansenSprites.hide()
	$Character/NansenPuppet.show()
