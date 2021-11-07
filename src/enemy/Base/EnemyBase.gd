extends RigidBody2D
class_name EnemyBase

signal on_enemy_death
signal on_enemy_alarmed

var is_dead := false

# init this in _on_ready()
var tag: String
var damage_treshold: int

onready var state: EnemyState = $Brain/EnemyState

func _ready():
	$Brain/Sensors.set_raycast_exceptions(
		[self, $Character/CharacterBody]
	)

func get_intimidation() -> int:
	return state.intimidation

func get_size() -> int:
	return state.size

# returns true if is stuck
func arrow_entered(arrow: Arrow):
	var arrow_velocity = arrow.linear_velocity.length()
	var damage = int(arrow_velocity / 10)
	var damaged = damage > damage_treshold
	
	if damaged:
		$HealthManager.take_directional_damage(damage, arrow.linear_velocity.normalized())


func take_directional_damage(damage: int, impulse: Vector2):
	$HealthManager.take_directional_damage(damage, impulse)

func take_damage(damage: int):
	$HealthManager.take_damage(damage)


func _on_HealthManager_on_death():
	GameManager.enemy_died()
	$Character/CharacterBody/Hitbox.disabled = true
	$Character/CharacterBody.collision_layer = 0
	set_modulate(Color(1,1,1,0.4))
	$Brain.is_active = false
	is_dead = true
	emit_signal("on_enemy_death")
	$QueueFreeTimer.start()

func set_hitpoints(value: int):
	$HealthManager.hitpoints = value

func _on_QueueFreeTimer_timeout():
	queue_free()

func _on_surprise_animation_finished(anim_name):
	$Brain.is_active = true

func _on_Sensors_alarmed_by(target):
	$Character/UnderCharacter/AlarmedEmote.show()
	$SurpriseAnimationPlayer.play("Surprise")
	yield(get_tree().create_timer(.5), "timeout")
	emit_signal("on_enemy_alarmed", target)
