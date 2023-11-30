class_name Health
extends Component



@export var health: int = 3
@export var invincible: bool = false



func hurt(damage: int):
	if !invincible:
		if health > 0:
			health -= damage
		if health < 0:
			health = 0
