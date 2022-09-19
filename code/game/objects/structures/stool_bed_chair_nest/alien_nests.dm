#define NEST_RESIST_TIME 1200

/obj/structure/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/alien.dmi'
	icon_state = "nest"
	color = "#261438"
	var/health = 100

/obj/structure/bed/nest/update_icon()
	return

/obj/structure/bed/nest/mob_resist_buckle(mob/M, semantic)
	. = ..()
	if(!.)
		return
	var/mob/living/L = M
	if(!istype(L))
		return
	if(world.time <= L.last_special + NEST_RESIST_TIME)
		return FALSE
	L.last_special = world.time
	L.visible_message(\
		"<span class='warning'>[L.name] struggles to break free of the gelatinous resin...</span>",\
		"<span class='warning'>You struggle to break free from the gelatinous resin...</span>",\
		"<span class='notice'>You hear squelching...</span>")
	add_fingerprint(L)
	if(!do_after(L, NEST_RESIST_TIME, src, FALSE))
		L.visible_message(
			SPAN_WARNING("[L] fails to break out of [src]!"),
			SPAN_WARNING("You fail to break out of [src].")
		)
		return FALSE

/obj/structure/bed/nest/user_unbuckle_feedback(mob/M, flags, mob/user, semantic)
	if(user != M)
		user.visible_message(\
			"<span class='notice'>[user.name] pulls [M.name] free from the sticky nest!</span>",\
			"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
			"<span class='notice'>You hear squelching...</span>")
	else
		user.visible_message(
			SPAN_WARNING("[user] tears free of [src]."),
			SPAN_WARNING("You tear free of [src]."),
			SPAN_WARNING("You hear squelching...")
		)

/obj/structure/bed/nest/user_buckle_mob(mob/M, flags, mob/user, semantic)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	var/mob/living/carbon/xenos = user
	var/mob/living/carbon/victim = M

	if(istype(victim) && locate(/obj/item/organ/internal/xenos/hivenode) in victim.internal_organs)
		return

	if(istype(xenos) && !((locate(/obj/item/organ/internal/xenos/hivenode) in xenos.internal_organs)))
		return

	if(M == user)
		return

	return ..()

/obj/structure/bed/nest/user_buckle_feedback(mob/M, flags, mob/user, semantic)
	user.visible_message(\
		"<span class='notice'>[user.name] secretes a thick vile goo, securing [M.name] into [src]!</span>",\
		"<span class='warning'>[user.name] drenches you in a foul-smelling resin, trapping you in the [src]!</span>",\
		"<span class='notice'>You hear squelching...</span>")

/obj/structure/bed/nest/attackby(obj/item/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()

/obj/structure/bed/nest/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return
