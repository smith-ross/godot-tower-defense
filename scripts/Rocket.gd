class_name Rocket
extends Bullet

@export var max_hit = 3
var hit_count = 0

func do_hit():
	hit_count += 1
	if hit_count >= max_hit:
		hit = true
