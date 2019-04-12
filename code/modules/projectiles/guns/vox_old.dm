/*
 * Vox Spike Thrower
 *  Alien pinning weapon.
 */

/obj/item/gun/launcher/spikethrower
	name = "spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."

	var/last_regen = 0
	var/spike_gen_time = 150
	var/max_spikes = 5
	var/spikes = 5
	release_force = 30
	icon = 'icons/obj/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound = 'sound/weapons/bladeslice.ogg'
	fire_sound_text = "a strange noise"

/obj/item/gun/launcher/spikethrower/New()
	..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time

/obj/item/gun/launcher/spikethrower/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/gun/launcher/spikethrower/process()
	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/gun/launcher/spikethrower/examine(mob/user)
	..(user)
	to_chat(user, "It has [spikes] spike\s remaining.")

/obj/item/gun/launcher/spikethrower/update_icon()
	icon_state = "spikethrower[spikes]"

/obj/item/gun/launcher/spikethrower/update_release_force()
	return

/obj/item/gun/launcher/spikethrower/consume_next_projectile()
	if(spikes < 1) return null
	spikes--
	return new /obj/item/weapon/spike(src)

