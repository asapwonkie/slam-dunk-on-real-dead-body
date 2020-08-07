class_name Health
extends Component



export(int) var health = 3
export(bool) var invincible = false



func hurt(damage: int):
	if !invincible:
		if health > 0:
			health -= damage
		if health < 0:
			health = 0
