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

/obj/item/gun/launcher/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null, var/pointblank=0, var/reflex=0)
	update_release_force(projectile)
	projectile.forceMove(get_turf(user))
	projectile.throw_at_old(target, throw_distance, release_force, user)
	return 1
