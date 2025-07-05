/obj/item/gun/projectile/energy/stripper//Because it can be fun
	name = "stripper gun"
	desc = "A gun designed to remove unnessary layers from people. For external use only!"
	// TODO: modularize sprite
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "sizegun-shrink100" // Someone can probably do better. -Ace
	item_state = null	//so the human update icon uses the icon_state instead
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 240
	projectile_type = /obj/projectile/energy/stripper
	origin_tech = list(TECH_BLUESPACE = 4)
	modifystate = "sizegun-shrink"
	no_pin_required = 1
	legacy_battery_lock = 1
	firemodes = list()

/obj/projectile/energy/stripper
	icon_state = "magicm"
	damage_force = =0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE

/obj/projectile/energy/stripper/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.permit_stripped)
			return
		H.drop_slots_to_ground(list(SLOT_ID_SUIT, SLOT_ID_UNIFORM, SLOT_ID_BACK, SLOT_ID_SHOES, SLOT_ID_GLOVES))
		//Hats can stay! Most other things fall off with removing these.
