/**
 * Simple grenade
 *
 * Blows up.
 * That's it.
 */
/obj/item/grenade/simple
	/// has been activated
	var/activated = FALSE

	/// you don't really have a reason to use this most of the time but it's here if you somehow do
	/// * if this is set you have to qdel self as needed manually!
	var/detonation_delete_self = TRUE
	/// sound to play on detonate
	var/detonation_sound

	/// automatic detonation handling; prime once activated for [activation_detonate_delay] then detonate()
	var/activation_detonate = FALSE
	/// time to detonate once activated
	/// * 0 is instant
	var/activation_detonate_delay = 5 SECONDS
	/// append state when active
	var/activation_state_append = "_active"
	/// sound to play when activated
	var/activation_sound = 'sound/weapons/armbomb.ogg'

/obj/item/grenade/simple/update_icon_state()
	icon_state = "[base_icon_state || initial(icon_state)][activated ? activation_state_append : ""]"
	return ..()

/obj/item/grenade/simple/on_activate_inhand(datum/event_args/actor/actor)
	..()
	activate(actor)
	return TRUE

/obj/item/grenade/simple/proc/activate(datum/event_args/actor/actor)
	if(activated)
		return
	activated = TRUE
	on_activate(actor)

/obj/item/grenade/simple/proc/on_activate(datum/event_args/actor/actor)
	SHOULD_CALL_PARENT(TRUE)
	if(actor)
		msg_admin_attack("[actor.performer] primed \a [src] ([type]).")
	if(activation_detonate)
		if(activation_detonate_delay)
			actor?.chat_feedback(
				SPAN_WARNING("You prime \the [src]![activation_detonate_delay > 0 ? " [CEILING(activation_detonate_delay * 0.1, world.tick_lag)] seconds!" : ""]"),
				target = src,
			)
		addtimer(CALLBACK(src, PROC_REF(detonate)), activation_detonate_delay)
	else
		actor?.chat_feedback(
			SPAN_WARNING("You prime \the [src]!"),
			target = src,
		)
	update_icon()
	if(activation_sound)
		playsound(src, activation_sound, 75, TRUE, -3)

/obj/item/grenade/simple/proc/detonate()
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/turf/location = get_turf(src)
	if(location)
		on_detonate(location, loc)

	if(detonation_delete_self)
		qdel(src)

/**
 * perform detonation effects here
 *
 * * do not delete the grenade, detonate() handles this
 */
/obj/item/grenade/simple/proc/on_detonate(turf/location, atom/grenade_location)
	SHOULD_CALL_PARENT(TRUE)

	if(detonation_sound)
		playsound(src, detonation_sound, 75, TRUE, 3)
	location.hotspot_expose(700,125)
