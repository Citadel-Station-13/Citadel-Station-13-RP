/obj/item/projectile/trajectory_tester
	name = "Uh Oh."
	desc = "You shouldn't see me!"
	invisibility = INVISIBILITY_ABSTRACT
	hitscan = TRUE
	nodamage = TRUE
	damage = 0
	var/list/hit

/obj/item/projectile/trajectory_tester/process_hitscan()
	. = ..()
	if(!QDELING(src))
		qdel(src)
	return hit

/obj/item/projectile/trajectory_tester/do_hit_atom(atom/A)
	LAZYOR(hit, A)
	. = ..()

/obj/item/projectile/trajectory_tester/prehit(atom/A)
	LAZYOR(hit, A)
	return ..()		//eehhhh..

//EXPENSIVE pixel projectile ""raytracing"".
/proc/projectile_raytrace(turf/source, atom/angle_or_target, pass_flags = (PASSTABLE | PASSGLASS | PASSGRILLE), penetration = 0, override_pixel_speed, override_pixel_iterations)
	var/obj/item/projectile/trajectory_tester/P = new(get_turf(source))
	P.pass_flags = pass_flags
	P.penetrating = penetration
	if(override_pixel_speed)
		P.override_pixel_speed = override_pixel_speed
	if(override_pixel_iterations)
		P.override_pixel_iterations = override_pixel_iterations
	if(istype(angle_or_target))
		AUTO_GET_ANGLE(source, angle_or_target, new_angle)
		angle_or_target = new_angle
	return P.fire(angle_or_target)
