/obj/item/projectile/sonic
	name = "sonic pulse"
	icon_state = "sound"
	fire_sound = 'sound/effects/basscannon.ogg'
	damage = 5
	armor_penetration = 30
	damage_type = BRUTE
	check_armour = "melee"
	embed_chance = 0
	vacuum_traversal = 0

/obj/item/projectile/sonic/weak
	agony = 50

/obj/item/projectile/sonic/strong
	damage = 45

/obj/item/projectile/sonic/strong/on_hit(var/atom/movable/target, var/blocked = 0)
	. = ..()
	if(ismob(target))
		var/throwdir = get_dir(firer,target)
		target.safe_throw_at(get_edge_target_turf(target, throwdir), rand(1,6), 3, src)
