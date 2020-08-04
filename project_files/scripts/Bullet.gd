# Bullet.gd
class_name Bullet
extends GameObject



var direction = Vector2.ZERO
var speed = 800
var damage = 1
var active = true



#onready var hitbox = get_child_of_name("Hitbox")
onready var timer = Timer.new()



func create(_direction):
	self.direction = _direction.normalized()
	self.transform = self.transform.rotated(atan2(_direction.y, _direction.x))



func _ready():
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	add_child(timer)
	timer.start()
	timer.connect("timeout", self, "queue_free")
#	hitbox.connect("body_entered", self, "on_body_enter")



func _process(delta):
	transform.origin += direction * speed * delta

#func on_body_enter(body):
#	var go = get_game_object(body)
#	var health = go.get_child_of_type(Health)
#	if health != null:
#		health.hurt(damage)
#	queue_free()
#
