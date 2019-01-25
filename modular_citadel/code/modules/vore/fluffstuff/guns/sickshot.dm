/obj/item/projectile/sickshot
	damage = 2
	damage_type = BRUTE
	..()
/obj/item/projectile/sickshot/on_hit(var/atom/movable/target, var/blocked = 0)
	if(isliving(target))
		var/mob/living/L = target
		if(prob(40))
			L.release_vore_contents()

		if(ishuman(target))
			.=..()
