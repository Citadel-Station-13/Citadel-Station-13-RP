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

//This normally uses a proc on projectiles and our ammo is not strictly speaking a projectile.
/obj/item/gun/launcher/can_hit(mob/living/target as mob, mob/living/user as mob)
	return 1

//Override this to avoid a runtime with suicide handling.
/obj/item/gun/launcher/handle_suicide(mob/living/user)
	to_chat(user, "<font color='red'>Shooting yourself with \a [src] is pretty tricky. You can't seem to manage it.</font>")
	return

/obj/item/gun/launcher/proc/update_release_force(obj/projectile)
	return 0

/obj/item/gun/launcher/process_projectile(obj/projectile, mob/user, atom/target, target_zone, params=null, pointblank=0, reflex=0)
	update_release_force(projectile)
	projectile.forceMove(get_turf(user))
	projectile.throw_at_old(target, throw_distance, release_force, user)
	return 1
