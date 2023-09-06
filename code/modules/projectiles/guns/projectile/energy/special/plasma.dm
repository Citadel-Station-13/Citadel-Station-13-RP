/datum/firemode/energy/plasma
	name = "normal"
	charge_cost = 350
	projectile_type = /obj/projectile/plasma

/datum/firemode/energy/plasma/highpower
	name = "high power"
	charge_cost = 370
	projectile_type = /obj/projectile/plasma/hot

/obj/item/gun/projectile/energy/plasma
	name = "\improper Balrog plasma rifle"
	desc = "This bulky weapon, the experimental NT-PLR-EX 'Balrog', fires magnetically contained balls of plasma at high velocity. Due to the volatility of the round, the weapon is known to overheat and fail catastrophically if fired too frequently."
	icon_state = "prifle"
	item_state = null
	fire_delay = 20
	charge_cost = 400
	cell_type = /obj/item/cell/device/weapon
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000)
	one_handed_penalty = 50
	regex_this_firemodes = list(
		/datum/firemode/energy/plasma,
		/datum/firemode/energy/plasma/highpower,
	)

	var/overheating = FALSE

/obj/item/gun/projectile/energy/plasma/update_icon()
	. = ..()
	if(overheating)
		icon_state = "prifle_overheat"
		update_held_icon()

/obj/item/gun/projectile/energy/plasma/consume_next_projectile(atom/movable/firer)
	if(overheating)
		return null
	. = ..()
	if(istype(., /obj/projectile/plasma/hot) && prob(1/6))
		if(ismob(firer))
			to_chat(firer, "<span class='danger'>The containment coil catastrophically overheats!</span>")
		overheating = TRUE
		addtimer(CALLBACK(src, PROC_REF(detonate)), rand(2 SECONDS, 5 SECONDS))

/obj/item/gun/projectile/energy/plasma/proc/detonate()
	visible_message("<span class='critical'>\The [src] detonates!</span>")
	explosion(get_turf(src), 0, 0, 2, 3)
	if(!QDELETED(src))
		qdel(src)

/obj/item/gun/projectile/energy/plasma/pistol
	name = "\improper Wyrm plasma pistol"
	desc = "This scaled down NT-PLP-EX 'Wyrm' plasma pistol fires magnetically contained balls of plasma at high velocity. Due to the volatility of the round, the weapon is known to overheat and fail catastrophically if fired too frequently."
	icon_state = "ppistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_NORMAL
	heavy = FALSE
	damage_force = 5
	origin_tech = list(TECH_COMBAT = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000)
	one_handed_penalty = 10

/obj/item/gun/projectile/energy/plasma/pistol/update_icon()
	. = ..()
	if(overheating)
		icon_state = "ppistol_overheat"
		update_held_icon()
	else
		return
