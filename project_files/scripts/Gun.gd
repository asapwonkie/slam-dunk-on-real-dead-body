# Gun.gd
class_name Gun
extends GameObject



const BULLET = preload("res://game_objects/Bullet.tscn")

enum Type {AK=0, DEAG=1, SHOTGUN=2}
	

export(Type) var gun_type = Type.AK
var aim_direction = Vector2.ZERO
var shooting = false
var can_shoot = true

var ammo = 0
var fire_rate = 0 # rounds per second
var damage = 0

onready var bullet_holder = game_world.bullet_holder
var timer = Timer.new()
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	add_child(timer)
	timer.connect("timeout", self, "timer_timeout")
	gun_type = rng.randi_range(0, Type.size()-1)
	set_weapon_properties()
	
func set_weapon_properties():
	if gun_type == Type.AK:
		ammo = 30
		fire_rate = 15
		damage = 1
	elif gun_type == Type.DEAG:
		ammo = 12
		fire_rate = 1.5
		damage = 3
	elif gun_type == Type.SHOTGUN:
		ammo = 12
		fire_rate = 1.5
		damage = 3
		
	timer.set_wait_time(1.0/fire_rate)
	timer.set_one_shot(false)
	
	
func aim(direction):
	aim_direction = direction.normalized()



func shoot_bullet():
	if ammo > 0:
		var b = BULLET.instance()
		bullet_holder.add_child(b)
		b.fire(global_position, aim_direction, damage)
		ammo -= 1
		shooting = true
		can_shoot = false



func timer_timeout():
	can_shoot = true
	if shooting:
		shoot_bullet()
	else:
		timer.stop()


func start_shooting():
	if can_shoot:
		shoot_bullet()
		timer.start()



func stop_shooting():
	shooting = false
