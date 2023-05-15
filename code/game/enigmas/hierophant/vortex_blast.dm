/obj/effect/vortex_magic/blast
	name = "vortex blast"
	desc = "A very unpleasant looking burst of energy."
	#warn icon, state

	/// how much damage we do
	var/damage = 10

#warn duration from animation

/obj/effect/vortex_magic/blast/Initialize(mapload, datum/vortex_magic/parent, damage)
	if(!isnull(damage))
		src.damage = damage
	#warn sfx?

	return ..()

/obj/effect/vortex_magic/blast/proc/burst()
	for(var/obj/O in loc)
		hit_object(O)
	for(var/mob/M in loc)
		hit_mob(M)
	#warn sfx

/obj/effect/vortex_magic/blast/proc/hit_obj(obj/O)
	return

/obj/effect/vortex_magic/blast/proc/hit_mob(mob/M)
	if(!isliving(M))
		return
	var/mob/living/L = M
	L.take_overall_damage(burn = damage)
