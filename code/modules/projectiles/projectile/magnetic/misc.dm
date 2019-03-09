/obj/item/projectile/bullet/magnetic/slug
	name = "slug"
	icon_state = "gauss_silenced"
	damage = 75
	armor_penetration = 90

/obj/item/projectile/bullet/magnetic/flechette
	name = "flechette"
	icon_state = "flechette"
	fire_sound = 'sound/weapons/rapidslice.ogg'
	damage = 20
	armor_penetration = 100

/obj/item/projectile/bullet/magnetic/bore/Bump(atom/A, forced=0)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/MI = A
		loc = get_turf(A) // Careful.
		permutated.Add(A)
		MI.GetDrilled(TRUE)
		return 0
	else if(istype(A, /turf/simulated/wall) || istype(A, /turf/simulated/shuttle/wall))	// Cause a loud, but relatively minor explosion on the wall it hits.
		explosion(A, -1, -1, 1, 3)
		qdel(src)
		return 1
	else
		..()
