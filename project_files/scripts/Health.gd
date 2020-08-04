class_name Health
extends Component



export(int) var health = 3



func hurt(damage: int):
	if health > 0:
		health -= damage
	if health < 0:
		health = 0
	print(str("Ouch. ", game_object.name, "'s health is now ", health))
