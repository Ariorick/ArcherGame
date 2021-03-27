extends RigidBody2D
class_name Player

const PLAYER_CENTER = Vector2(0, 4.3)
const WALK_FORCE = 800
const AIMING_MOVEMENT_SPEED_MODIFIER = 0.4
const PULLING_MOVEMENT_SPEED_MODIFIER = 0.65

var last_walk_force := Vector2.ZERO

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
	GameManager.player_take_damage()
	$ColorAnimationPlayer.play("PlayerTakeDamage")

func _ready():
	possible_actions = [
		PlayerDashAction.new(get_args()),
		PlayerAttackAction.new(get_args(), funcref(self, "can_shoot"), funcref(self, "on_arrow_fired")),
		PlayerPullAction.new(get_args(), funcref(self, "get_arrows"))
	]

func _process(delta):
	$BowSprite.visible = can_shoot()

func _physics_process(delta):
	GameManager.player_position = global_position - PLAYER_CENTER
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
		if current_action is PlayerAttackAction:
			speed_modifier = AIMING_MOVEMENT_SPEED_MODIFIER
		if current_action is PlayerPullAction:
			speed_modifier = PULLING_MOVEMENT_SPEED_MODIFIER
		walk(speed_modifier)

func can_shoot() -> bool:
	return GameManager.can_shoot()

func on_arrow_fired(arrow: Arrow):
	arrows.append(arrow)
	arrow.set_pull_target(self)
	GameManager.player_used_arrow()

func get_arrows() -> Array:
	return arrows


func walk(speed_modifier: float): 
	var is_walking = not current_action is PlayerDashAction and linear_velocity.length() > 1
	$StepParticles/Left.emitting = is_walking
	$StepParticles/Right.emitting = is_walking
	if is_walking:
		$AnimationPlayer.play("Walk")
	
	add_force(Vector2.ZERO, -1 * last_walk_force)
	last_walk_force = Vector2.ZERO
	var direction = PlayerInput.get_direction()
	if direction.length() == 0:
		return
	
	var walk_force = direction * WALK_FORCE * speed_modifier
	add_force(Vector2.ZERO, walk_force)
	last_walk_force = walk_force


func get_args() -> Dictionary:
	var args = {
		PlayerAction.Args.body: self
	}
	return args


func _on_PickArea_body_entered(arrow: Arrow):
	if OS.get_ticks_msec() - arrow.creation_time > 600:
		arrows.erase(arrow)
		arrow.queue_free()
		GameManager.player_collected_arrow()
	
