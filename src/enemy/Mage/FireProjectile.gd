extends Area2D
class_name FireProjectile

const exploded_texture = preload("res://assets/Tiles/explosion.png")

const SPEED = 1
const CORRECTION_SPEED = 0.05
const MAX_LIFETIME = 5
const EXPLOSION_IMPULSE = 200

var target: PhysicsBody2D
var direction : Vector2
var exploded := false
onready var creation_time = OS.get_ticks_msec()

func  _ready():
	direction = (GameManager.player_position - global_position).normalized()

func _physics_process(delta):
	if not exploded:
		direction = direction.linear_interpolate(
			(GameManager.player_position - global_position).normalized(), 
			get_correction_speed()
			)
		direction = direction.normalized()
		global_position += direction * SPEED
	if get_lifetime_sec() > MAX_LIFETIME:
		queue_free()

func explode():
	exploded = true
	$AnimationPlayer.play("Explode")
	$ExplodeTimer.start()
	$DieTimer.start()

func _on_ExplodeTimer_timeout():
	$Sprite.texture = exploded_texture

func _on_DieTimer_timeout():
	queue_free()

func get_correction_speed() -> float:
	var lifetime = get_lifetime_sec() + 1.0
	return min(1, CORRECTION_SPEED / pow(lifetime, 1.2))

func get_lifetime_sec():
	return (OS.get_ticks_msec() - creation_time) / 1000

func _on_FireProjectile_body_entered(body: PhysicsBody2D):
	if body.is_in_group("player") and not exploded:
		var impulse = EXPLOSION_IMPULSE * (GameManager.player_position - global_position).normalized()
		body.take_directional_damage(impulse)
		body.apply_impulse(Vector2.ZERO, impulse)
		explode()
