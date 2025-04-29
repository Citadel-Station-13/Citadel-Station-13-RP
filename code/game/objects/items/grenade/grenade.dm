/**
 * A thing you can throw that goes boom. Simple, really, but not always.
 *
 * TODO: /datum/grenade_effect, much like reagent / projectile effects for composition-based
 *       grenades
 */
/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	slot_flags = SLOT_MASK|SLOT_BELT

	var/active = 0
	var/det_time = 50
	var/loadable = TRUE
	var/arm_sound = 'sound/weapons/armbomb.ogg'

/obj/item/grenade/examine(mob/user, dist)
	. = ..()
	if(det_time > 1)
		. += "<span class = 'notice'>The timer is set to [det_time/10] seconds.</span>"
		return
	if(det_time == null)
		. += "<span class = 'danger'>The [src] is set for instant detonation.</span>"

/obj/item/grenade/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()

/obj/item/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[key_name_admin(user)] primed \a [src.name]")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, arm_sound, 75, 1, -3)

	spawn(det_time)
		detonate()

/obj/item/grenade/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()
	return

/obj/item/grenade/proc/activate_inhand(datum/event_args/actor/actor)

/obj/item/grenade/proc/on_activate_inhand(datum/event_args/actor/actor)
