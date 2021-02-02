extends KinematicBody2D
class_name Player

const PLAYER_CENTER = Vector2(0, -1.9)
const SPEED = 80  # speed in pixels/sec
const AIMING_MOVEMENT_SPEED_MODIFIER = 0.4

var current_velocity := Vector2()

var arrows: Array # of Arrow
var possible_actions: Array # of PlayerAction
var current_action: PlayerAction # of PlayerAction

var is_invinsible = false

func _on_DamageDetector_body_entered(body: PhysicsBody2D):
	if is_invinsible:
		return
	if body.is_in_group("enemies"):
		take_damage()

func take_damage():
	$ColorAnimationPlayer.play("EnemyTakeDamage")

func _ready():
	possible_actions = [
		PlayerDashAction.new(get_args()),
		PlayerAttackAction.new(get_args(), funcref(self, "can_shoot"), funcref(self, "on_arrow_fired")),
		PlayerPullAction.new(get_args(), funcref(self, "get_arrows"))
	]

func _physics_process(delta):
	if current_action != null and current_action.is_finished():
		current_action.cancel()
		current_action = null
	
	if current_action == null or current_action.is_interruptable():
		for action in possible_actions:
			if action != current_action and action.want_to_start():
				if current_action != null:
					current_action.cancel()
				current_action = action
	
	if current_action != null:
		current_action.perform()
	
	is_invinsible = current_action is PlayerDashAction
	
	if not current_action is PlayerDashAction:
		var speed_modifier = 1.0
		if current_action is PlayerAttackAction or current_action is PlayerPullAction:
			speed_modifier = AIMING_MOVEMENT_SPEED_MODIFIER
		walk(speed_modifier)

func can_shoot() -> bool:
	return true

func on_arrow_fired(arrow: Arrow):
	arrows.append(arrow)
	arrow.set_pull_target(self)

func get_arrows() -> Array:
	return arrows


func walk(speed_modifier: float): 
	current_velocity = Vector2()
	$StepParticles/Left.emitting = false
	$StepParticles/Right.emitting = false
	
	var direction = PlayerInput.get_direction()
	if direction.length() == 0:
		return
	
	var velocity = direction * SPEED * speed_modifier
	$AnimationPlayer.play("Walk")
	$StepParticles/Left.emitting = true
	$StepParticles/Right.emitting = true
	current_velocity = move_and_slide(velocity)



func get_args() -> Dictionary:
	var args = {
		Action.Args.body: self
	}
	return args


func _on_PickArea_body_entered(arrow: Arrow):
	if OS.get_ticks_msec() - arrow.creation_time > 800:
		arrows.erase(arrow)
		arrow.queue_free()
	
