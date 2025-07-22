/datum/firemode/energy/stripper
	projectile_type = /obj/projectile/energy/stripper
	charge_cost = 240

/obj/item/gun/projectile/energy/stripper//Because it can be fun
	name = "stripper gun"
	desc = "A gun designed to remove unnessary layers from people. For external use only!"
	icon = 'icons/modules/projectiles/guns/energy/stripper.dmi'
	icon_state = "stripper-4"
	base_icon_state = "stripper"
	worn_state = "stripper"
	item_renderer = /datum/gun_item_renderer/states{
		count = 4;
		use_empty = TRUE;
	}
	modifystate = "sizegun-shrink"
	no_pin_required = TRUE
	legacy_battery_lock = TRUE
	firemodes = list(
		/datum/firemode/energy/stripper,
	)

/obj/projectile/energy/stripper
	icon_state = "magicm"
	damage_force = 0
	damage_mode = NONE
	damage_flag = ARMOR_MELEE
	fire_sound = 'sound/weapons/wave.ogg'

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
