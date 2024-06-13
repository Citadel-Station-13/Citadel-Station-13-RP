// Helper proc to check if you can hit them or not.
// Will return a list of hit mobs/objects.
/proc/check_trajectory(atom/target, atom/firer, pass_flags=ATOM_PASS_TABLE|ATOM_PASS_GLASS|ATOM_PASS_GRILLE, atom_flags)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/projectile/test/trace = new /obj/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(atom_flags))
		trace.atom_flags = atom_flags
	trace.pass_flags = pass_flags

	return trace.launch_projectile(target) //Test it!

/obj/projectile/proc/_check_fire(atom/target as mob, var/mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, atom_flags)

//"Tracing" projectile
/obj/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see me!
	hitscan = TRUE
	nodamage = TRUE
	damage = 0
	has_tracer = FALSE
	var/list/hit = list()

/obj/projectile/test/process_hitscan()
	. = ..()
	if(!QDELING(src))
		qdel(src)
	return hit

/obj/projectile/test/Bump(atom/A)
	if(A != src)
		hit |= A
	return ..()

/obj/projectile/test/projectile_attack_mob()
	return
