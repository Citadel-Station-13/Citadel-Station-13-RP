/obj/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = 1
	damage_flag = ARMOR_ENERGY
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"
	combustion = FALSE

/obj/projectile/animate/Bump(var/atom/change)
	if((istype(change, /obj/item) || istype(change, /obj/structure)) && !is_type_in_list(change, protected_objects))
		var/obj/O = change
		new /mob/living/simple_mob/hostile/mimic/copy(O.loc, O, firer)
	..()
