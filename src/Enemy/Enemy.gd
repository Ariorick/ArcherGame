extends KinematicBody2D
class_name Enemy

var body_velocity := Vector2()

var target: Node2D
var other_enemies: Array = []
var in_range: bool = false

var conditions_changed = true

# init this in _on_ready()
var tag: String
var hitpoints: int

# override this
func _on_take_damage():
	pass

func connect_signals(vision: Area2D, attack_radius: Area2D, damage_detector: Area2D):
	vision.connect("body_entered", self, "_on_Vision_body_entered")
	vision.connect("body_exited", self, "_on_Vision_body_exited")
	attack_radius.connect("body_entered", self, "_on_AttackRadius_body_entered")
	attack_radius.connect("body_exited", self, "_on_AttackRadius_body_exited")
	damage_detector.connect("body_entered", self, "_on_DamageDetector_body_entered")

func _on_Vision_body_entered(body: PhysicsBody2D):
	if body is Player:
		target = body
		conditions_changed = true
	if body.is_in_group("enemies") and body != self:
		other_enemies.append(body)

func _on_Vision_body_exited(body: PhysicsBody2D):
	if body == target:
		target = null
		conditions_changed = true
	if body.is_in_group("enemies"):
		other_enemies.erase(body)

func _on_AttackRadius_body_entered(body):
	if body is Player:
		in_range = true
		conditions_changed = true

func _on_AttackRadius_body_exited(body):
	if body is Player:
		in_range = false
		conditions_changed = true

func _on_DamageDetector_body_entered(body): 
	if body is Arrow:
		var arrow_velocity = body.linear_velocity.length()
		if arrow_velocity > 100:
			var damage = int(arrow_velocity)
			print(tag, " got ",  damage, " damage")
			hitpoints -= damage
			_on_take_damage()
			if hitpoints <= 0:
				set_modulate(Color(1,1,1,0.5))
				set_physics_process(false)
			body.get_stuck(self, body_velocity)

func move_and_slide(linear_velocity: Vector2, up_direction: Vector2 = Vector2( 0, 0 ), stop_on_slope: bool = false, max_slides: int = 4, floor_max_angle: float = 0.785398, infinite_inertia: bool = true):
	body_velocity = .move_and_slide(linear_velocity, up_direction, stop_on_slope, max_slides, floor_max_angle, infinite_inertia)

func get_args() -> Dictionary:
	var args = {
		Action.Args.body: self
	}
	return args
