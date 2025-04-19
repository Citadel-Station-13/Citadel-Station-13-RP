/**
 * A gun that throws things instead of, well, firing them.
 */
/obj/item/gun/launcher
	name = "launcher"
	desc = "A device that launches things."
	icon = 'icons/obj/gun/launcher.dmi'
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = SLOT_BACK

	// todo: do we need to change this
	var/release_force = 0
	// todo: do we need to change this
	var/throw_distance = 10
	fire_sound_text = "a launcher firing"

/obj/item/gun/launcher/fire(datum/gun_firing_cycle/cycle)
	// point of no return
	var/atom/movable/throwing_projectile = consume_next_throwable(cycle)
	if(!istype(throwing_projectile))
		// it's an error code if it's not real
		return throwing_projectile
	// sike; real point of no return
	SEND_SIGNAL(src, COMSIG_GUN_FIRING_THROWABLE_INJECTION, cycle, throwing_projectile)
	// if they want to abort..
	if(cycle.next_firing_fail_result)
		// todo: deleting projectile here immediately in all cases is potentially unsound
		qdel(throwing_projectile)
		return cycle.next_firing_fail_result

	launch_throwable(cycle, throwing_projectile)

	return ..()

/obj/item/gun/launcher/proc/launch_throwable(datum/gun_firing_cycle/cycle, atom/movable/launching)
	update_release_force(launching)
	var/turf/T = cycle.firing_atom //Unlikely if there ever is a turf that could initiate the fire, but just to be sure
	if (!istype(T))
		T = get_turf(cycle.firing_atom)
	launching.forceMove(T)
	launching.throw_at_old(cycle.original_target, throw_distance, release_force, cycle.firing_actor?.performer)

/**
 * Returns the next /atom/movable to throw, or a GUN_FIRED_* for fail satus.
 *
 * * This should clear the throwable from our references.
 */
/obj/item/gun/launcher/proc/consume_next_throwable(datum/gun_firing_cycle/cycle)
	. = GUN_FIRED_FAIL_UNKNOWN
	CRASH("attempted to consume_next_throwable on base /gun/launcher")

// todo: do we need to change this
/obj/item/gun/launcher/proc/update_release_force(obj/projectile)
	return 0
