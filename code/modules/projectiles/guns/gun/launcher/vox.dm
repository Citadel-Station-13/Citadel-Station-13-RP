// todo: why is all this crap in the root level?

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
	icon = 'icons/obj/gun/launcher.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound = 'sound/weapons/bladeslice.ogg'
	fire_sound_text = "a strange noise"

/obj/item/gun/launcher/spikethrower/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time

/obj/item/gun/launcher/spikethrower/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/gun/launcher/spikethrower/process(delta_time)
	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/gun/launcher/spikethrower/examine(mob/user, dist)
	. = ..()
	. += "It has [spikes] spike\s remaining."

/obj/item/gun/launcher/spikethrower/update_icon_state()
	. = ..()
	icon_state = "spikethrower[spikes]"

/obj/item/gun/launcher/spikethrower/update_release_force()
	return

/obj/item/gun/launcher/spikethrower/consume_next_throwable(datum/gun_firing_cycle/cycle)
	if(spikes < 1)
		return GUN_FIRED_FAIL_EMPTY
	spikes--
	return new /obj/item/spike(src)

/*
 * Vox Darkmatter Cannon
 */
/obj/item/gun/projectile/energy/darkmatter
	name = "dark matter gun"
	desc = "A vicious alien beam weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "darkcannon"
	item_state = "darkcannon"
	w_class = WEIGHT_CLASS_HUGE
	heavy = TRUE
	charge_cost = 300
	projectile_type = /obj/projectile/beam/stun/darkmatter
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	accuracy = 30

	firemodes = list(
		list(mode_name="stunning", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/projectile/beam/stun/darkmatter, charge_cost = 300),
		list(mode_name="focused", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/projectile/beam/darkmatter, charge_cost = 400),
		list(mode_name="scatter burst", burst=8, fire_delay=null, move_delay=4, burst_accuracy=list(0, 0, 0, 0, 0, 0, 0, 0), dispersion=list(3, 3, 3, 3, 3, 3, 3, 3, 3), projectile_type=/obj/projectile/energy/darkmatter, charge_cost = 300),
		)

/obj/projectile/beam/stun/darkmatter
	name = "dark matter wave"
	icon_state = "darkt"
	fire_sound = 'sound/weapons/eLuger.ogg'
	nodamage = 1
	damage_inflict_agony = 55
	damage_type = DAMAGE_TYPE_HALLOSS
	light_color = "#8837A3"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/darkmatterstun
	legacy_tracer_type = /obj/effect/projectile/tracer/darkmatterstun
	legacy_impact_type = /obj/effect/projectile/impact/darkmatterstun

/obj/projectile/beam/darkmatter
	name = "dark matter bolt"
	icon_state = "darkb"
	fire_sound = 'sound/weapons/eLuger.ogg'
	damage_force = 35
	damage_tier = 4
	damage_type = DAMAGE_TYPE_BRUTE
	damage_flag = ARMOR_ENERGY
	light_color = "#8837A3"

	embed_chance = 0

	legacy_muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	legacy_tracer_type = /obj/effect/projectile/tracer/darkmatter
	legacy_impact_type = /obj/effect/projectile/impact/darkmatter

/obj/projectile/energy/darkmatter
	name = "dark matter pellet"
	icon_state = "dark_pellet"
	fire_sound = 'sound/weapons/eLuger.ogg'
	damage_force = 20
	damage_tier = 4
	damage_type = DAMAGE_TYPE_BRUTE
	damage_flag = ARMOR_ENERGY
	light_color = "#8837A3"

	embed_chance = 0

/*
 * Vox Sonic Cannon
 */
/obj/item/gun/projectile/energy/sonic
	name = "soundcannon"
	desc = "A vicious alien sound weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "noise"
	item_state = "noise"
	w_class = WEIGHT_CLASS_HUGE
	heavy = TRUE
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	charge_cost = 400

	projectile_type=/obj/projectile/sonic/weak

	firemodes = list(
		list(mode_name="suppressive", projectile_type=/obj/projectile/sonic/weak, charge_cost = 200),
		list(mode_name="normal", projectile_type=/obj/projectile/sonic/strong, charge_cost = 600),
		)

/obj/projectile/sonic
	name = "sonic pulse"
	icon_state = "sound"
	fire_sound = 'sound/effects/basscannon.ogg'
	damage_force = 5
	damage_tier = 4
	damage_type = DAMAGE_TYPE_BRUTE
	damage_flag = ARMOR_MELEE
	embed_chance = 0
	vacuum_traversal = 0

/obj/projectile/sonic/weak
	damage_inflict_agony = 50

/obj/projectile/sonic/strong
	damage_force = 45

/obj/projectile/sonic/strong/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(ismob(target))
		var/mob/M = target
		var/throwdir = get_dir(firer,target)
		M.throw_at_old(get_edge_target_turf(target, throwdir), rand(1,6), 10)
