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
	var/activation_detonate = TRUE
	/// time to detonate once activated
	/// * 0 is instant
	var/activation_detonate_delay = 5 SECONDS
	/// append state when active
	var/activation_state_append = "-active"
	/// sound to play when activated
	var/activation_sound = 'sound/weapons/armbomb.ogg'

	/// allow modifying activation delay
	var/simple_activation_delay_tweak = TRUE
	/// get allowed delay notches for modification
	/// * this will be typelisted so don't edit after init!
	var/list/simple_activation_delay_notches = list(
		0 SECONDS,
		1 SECONDS,
		3 SECONDS,
		5 SECONDS,
		7 SECONDS,
		10 SECONDS,
	)

	/// chance to automatically activate on atom_break
	/// * only rolled if we don't self-detonate immediately
	var/damage_failure_activation_chance = 60
	/// chance to immediately detonate on atom_break
	var/damage_failure_detonation_chance = 30

/obj/item/grenade/simple/Initialize(mapload)
	. = ..()
	if(simple_activation_delay_notches)
		simple_activation_delay_notches = typelist(NAMEOF(src, simple_activation_delay_notches), simple_activation_delay_notches)

/obj/item/grenade/simple/update_overlays()
	. = ..()
	if(activated && activation_state_append)
		. += "[base_icon_state || initial(icon_state)][activation_state_append]"

/obj/item/grenade/simple/atom_break()
	..()
	if(prob(damage_failure_detonation_chance) && !activated)
		detonate()
	else if(prob(damage_failure_activation_chance))
		activate()

/obj/item/grenade/simple/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("It's set to detonate after [activation_detonate_delay * 0.1] seconds.")
	if(should_simple_delay_adjust(new /datum/event_args/actor(user)))
		. += SPAN_NOTICE("Use a screwdriver on this to change the fuse time.")

/obj/item/grenade/simple/activate(datum/event_args/actor/actor)
	if(activated)
		return
	activated = TRUE
	return ..()

/obj/item/grenade/simple/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args)
	if(!should_simple_delay_adjust(e_args))
		return ..()
	. = list(
		TOOL_SCREWDRIVER = list(
			"adjust fuse" = dyntool_image_neutral(TOOL_SCREWDRIVER),
		),
	)
	return merge_double_lazy_assoc_list(..(), .)

/obj/item/grenade/simple/screwdriver_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	if(!should_simple_delay_adjust(e_args))
		return
	if(!use_screwdriver(I, e_args, flags, 0))
		return TRUE
	do_simple_delay_adjust(e_args)
	return TRUE

/obj/item/grenade/simple/proc/should_simple_delay_adjust(datum/event_args/actor/actor)
	return simple_activation_delay_tweak

/obj/item/grenade/simple/on_activate(datum/event_args/actor/actor)
	..()
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
	// TODO: this & throw mode should only happen on clickchain activation
	add_fingerprint(actor.performer)
	if(actor?.performer?.get_active_held_item() == src)
		actor.performer.throw_mode_on()
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

/obj/item/grenade/simple/proc/do_simple_delay_adjust(datum/event_args/actor/actor)
	if(!length(simple_activation_delay_notches))
		return
	var/current_index = simple_activation_delay_notches.Find(activation_detonate_delay) || round(length(simple_activation_delay_notches) / 1) || 1
	var/new_index = current_index + 1
	if(new_index > length(simple_activation_delay_notches))
		new_index = 1
	activation_detonate_delay = simple_activation_delay_notches[new_index]
	actor?.chat_feedback(
		SPAN_NOTICE("You set \the [src] for [activation_detonate_delay ? "[activation_detonate_delay * 0.1] second detonation time" : "instant detonation"]."),
		target = src,
	)

	// TODO: log
