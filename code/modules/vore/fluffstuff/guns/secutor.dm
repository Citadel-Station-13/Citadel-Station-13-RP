// -------------- Secutor -------------
/obj/item/gun/energy/secutor
	name = "\improper NT/HI-S-1 'Secutor'"
	desc = "The Seuctor standard service sidearm was designed by NanoTrasen in conjunction with Hephaestus Industries. Following years of cooperative development, this weapon features NanoTrasen's superior neuro-disruptive electronic payload in a new frame heavily influenced by Hephaestus' more popular and ergonomic taser. Designed exclusively for NanoTrasen Security personnel, this weapon features three fire modes: a non-lethal stun bolt, a low power phaser medium, and an alert-locked lethal contingency. This state-of-the-art weapon serves as a symbolic representation of NanoTrasen and Hephaestus' lasting cooperative relationship - and it's an excellent sidearm to boot."

	icon = 'icons/obj/gun/secutor.dmi'
	icon_state = "secutorstun100"

	icon_override = 'icons/obj/gun/secutor.dmi'
	item_state = null
	worn_render_flags = WORN_RENDER_SLOT_NO_RENDER

	projectile_type = /obj/projectile/energy/electrode/strong/secutor
	fire_delay = 8

	modifystate = "secutorstun"

	firemodes = list(
	list(mode_name="stun", fire_delay=8, projectile_type=/obj/projectile/energy/electrode/strong/secutor, modifystate="secutorstun", charge_cost = 240),
	list(mode_name="phaser", fire_delay=8, projectile_type=/obj/projectile/energy/phase/secutor, modifystate="secutorphaser", charge_cost = 200),
	list(mode_name="low-power-lethal", fire_delay=10, projectile_type=/obj/projectile/beam/secutor, modifystate="secutorkill", charge_cost = 300),
	)

	var/emagged = FALSE


/obj/item/gun/energy/secutor/update_overlays()
	. = ..()
	. = get_security_level()
	cut_overlays()

/obj/item/gun/energy/secutor/special_check(mob/user)
	if(!emagged && mode_name == "low-power-lethal" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting and while under security level blue!</span>")
		return FALSE

	return ..()

/obj/item/gun/energy/secutor/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")

	return TRUE


//--------------- Hitscan Lasers ----------------
/obj/projectile/beam/secutor
	name = "secutor laser beam"
	icon_state = "laser"
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	light_range = 2
	light_power = 0.6
	light_color = "#BF2F4B"
	muzzle_type = /obj/effect/projectile/muzzle/secutorkill
	tracer_type = /obj/effect/projectile/tracer/secutorkill
	impact_type = /obj/effect/projectile/impact/secutorkill
	damage = 20

//--------------- Projectiles ----------------
/obj/projectile/energy/electrode/secutor
	name = "secutor electrode"
	fire_sound = 'sound/weapons/Gunshot2.ogg'
	icon_state = "energy4"
	light_range = 2
	light_power = 0.6
	light_color = "#2B5DB1"

/obj/projectile/energy/phase/secutor
	name = "secutor phase wave"
	fire_sound = 'sound/weapons/resonator_fire.ogg'
	icon_state = "energy2"
	light_range = 2
	light_power = 0.6
	light_color = "#cea036"
	range = 20
	damage = 5 //minor penalty for repeated FF
	SA_bonus_damage = 25	// 30 total on animals - lowest of all phasers
	SA_vulnerability = MOB_CLASS_ANIMAL

