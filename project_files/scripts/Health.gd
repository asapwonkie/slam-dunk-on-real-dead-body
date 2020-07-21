class_name Health
extends Component



export(int) var health = 100



func hurt(damage: int):
	health -= damage
	print(str("Ouch! ", game_object.name, "'s health is now ", health))
	
	if health <= 0:
		get_parent().queue_free()
