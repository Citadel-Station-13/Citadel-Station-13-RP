/**
 * A gun that throws things instead of, well, firing them.
 */
/obj/item/gun/launcher
	name = "launcher"
	desc = "A device that launches things."
	icon = 'icons/obj/gun/launcher.dmi'
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = SLOT_BACK

	var/release_force = 0
	var/throw_distance = 10
	muzzle_flash = 0
	fire_sound_text = "a launcher firing"

/obj/item/gun/launcher/proc/update_release_force(obj/projectile)
	return 0

#warn firing (this ain't it)

/obj/item/gun/launcher/fire(datum/gun_firing_cycle/cycle)
	. = ..()

	update_release_force(projectile)
	projectile.forceMove(get_turf(user))
	projectile.throw_at_old(target, throw_distance, release_force, user)
	return 1

/**
 * Returns the next /atom/movable to throw, or a GUN_FIRED_* for fail satus.
 *
 * * This should clear the throwable from our references.
 */
/obj/item/gun/launcher/proc/consume_next_throwable(iteration, firing_flags, datum/firemode/firemode, datum/event_args/actor/actor, atom/firer)
	. = GUN_FIRED_FAIL_UNKNOWN
	CRASH("attempted to consume_next_throwable on base /gun/launcher")
