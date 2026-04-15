extends RefCounted


func calculate_damage(attacker_attack: int, defender_defense: int) -> int:
	return max(1, attacker_attack + randi() % 5 - defender_defense)
