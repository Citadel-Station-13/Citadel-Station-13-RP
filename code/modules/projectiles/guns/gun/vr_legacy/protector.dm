// -------------- Protector -------------
/obj/item/gun/projectile/energy/protector
	name = "Hephaestus \'Myrmidon\'"
	desc = "The Hephaestus Industries Myrmidon is a common energy sidearm for private security firms in the known galaxy. The Myrmidon can both stun and kill, its lethal mode locked to the alert level of its owner's choice. In the case of Nanotrasen facilities, this is most often locked to Code Blue."
	description_info = "The \'Myrmidon\' can't be set to lethal unless the station is on Code Blue or higher. Security officers may carry it on Code Green, since its stun abilities are all that can be used until the code is raised, which then unlocks and allows its lethal capabilities."
	description_fluff = "A common sight among Proxima Centauri Risk Control employees, the Myrmidon encourages responsible adherence to protocol, its lethal mode locked until the employee properly alerts their team and raises the alarm, freeing both the employee and their employer from responsibility for any ensuring casualties."
	description_antag = "The \'Myrmidon\' can be tampered with to remove its restrictions, freeing up its lethal capabilities on Code Green."

	catalogue_data = list()///datum/category_item/catalogue/information/organization/hephaestus)

	icon = 'icons/vore/custom_guns_vr.dmi'
	icon_state = "prot"

	icon_override = 'icons/vore/custom_guns_vr.dmi'
	item_state = "gun"

	fire_sound = 'sound/weapons/Taser.ogg'
	projectile_type = /obj/projectile/beam/stun

	modifystate = "stun"

	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)

	charge_sections = 3 //For the icon
	ammo_x_offset = 2
	ammo_y_offset = 0

	// todo: add flashlight attachment support

	firemodes = list(
			list(mode_name="stun", projectile_type=/obj/projectile/beam/stun/protector, modifystate="stun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", projectile_type=/obj/projectile/beam, modifystate="kill", fire_sound='sound/weapons/gauss_shoot.ogg'),
	)

	var/emagged = FALSE

/obj/item/gun/projectile/energy/protector/special_check(mob/user)
	if(!emagged &&firemode.name == "lethal" && get_security_level() == "green")
		to_chat(user,"<span class='warning'>The trigger refuses to depress while on the lethal setting under security level green!</span>")
		return FALSE

	return ..()


/obj/item/gun/projectile/energy/protector/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(!emagged)
		emagged = TRUE
		to_chat(user,"<span class='warning'>You disable the alert level locking mechanism on \the [src]!</span>")

	return TRUE

//Update icons from /tg/, so fancy! Use this more!
/obj/item/gun/projectile/energy/protector/update_icon()
	cut_overlay()
	var/list/overlays_to_add = list()
	var/ratio = 0

	/* Don't have one for this gun
	var/itemState = null
	if(!initial(item_state))
		itemState = icon_state
	*/

	var/iconState = "[icon_state]_charge"
	if (modifystate)
		overlays_to_add += "[icon_state]_[modifystate]"
		iconState += "_[modifystate]"
		/* Don't have one for this gun
		if(itemState)
			itemState += "[modifystate]"
		*/
	if(obj_cell_slot.cell)
		ratio = CEILING(((obj_cell_slot.cell.charge / obj_cell_slot.cell.maxcharge) * charge_sections), 1)

		if(obj_cell_slot.cell.charge < charge_cost)
			overlays_to_add += "[icon_state]_empty"
		else
			if(!shaded_charge)
				var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
				for(var/i = ratio, i >= 1, i--)
					charge_overlay.pixel_x = ammo_x_offset * (i - 1)
					overlays_to_add += charge_overlay
			else
				overlays_to_add += "[icon_state]_[modifystate][ratio]"

	/* Don't have one for this gun
	if(itemState)
		itemState += "[ratio]"
		item_state = itemState
	*/

	// todo: burn this entire proc to the ground, because the writer deserves to have their eyelids replaced with lemons
	// "this goodd system but i'm going to snowflake it for one gun"

	add_overlay(overlays_to_add)

	return ..()


// Protector beams
/obj/projectile/beam/stun/protector
	name = "protector stun beam"
	icon_state = "omnilaser" //A little more cyan
	light_color = "#00C6FF"
	damage_inflict_agony = 50 //Normal is 40 when this was set
	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni
