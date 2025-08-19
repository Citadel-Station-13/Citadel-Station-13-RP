/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/hardsuit
	name = "helmet"
	atom_flags = PHORONGUARD
	inv_hide_flags      = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

	max_pressure_protection = null
	min_pressure_protection = null

/obj/item/clothing/shoes/magboots/hardsuit
	name = "boots"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	body_cover_flags = FEET
	cold_protection_cover    = FEET
	heat_protection_cover    = FEET

	icon_base = null
	damage_force = 5 // if you're kicking someone with something meant to keep you locked on a hunk of metal...

	weight = 0
	encumbrance = 0

/obj/item/clothing/suit/space/hardsuit
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)

	//Flags
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	clothing_flags     = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	cold_protection_cover    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	atom_flags              = PHORONGUARD
	inv_hide_flags          = HIDEJUMPSUIT|HIDETAIL
	heat_protection_cover    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

	weight = 0
	encumbrance = 0

	// Will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit.
	// Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = TRUE

	supporting_limbs = list()
	var/obj/item/material/knife/tacknife
	max_pressure_protection = null
	min_pressure_protection = null

/obj/item/clothing/suit/space/hardsuit/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(tacknife)
		tacknife.loc = get_turf(src)
		if(user.put_in_active_hand(tacknife))
			to_chat(user, SPAN_NOTICE("You slide \the [tacknife] out of [src]."))
			playsound(user, 'sound/weapons/flipblade.ogg', 40, TRUE)
			tacknife = null
			update_icon()
		return
	..()

/obj/item/clothing/suit/space/hardsuit/attackby(obj/item/I, mob/living/M)
	if(istype(I, /obj/item/material/knife/tacknife))
		if(tacknife)
			return
		if(!M.attempt_insert_item_for_installation(I, src))
			return
		tacknife = I
		to_chat(M, "<span class='notice'>You slide the [I] into [src].</span>")
		playsound(M, 'sound/weapons/flipblade.ogg', 40, TRUE)
		update_icon()
	..()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/hardsuit/proc/prevent_track()
	return FALSE

/obj/item/clothing/gloves/gauntlets/hardsuit/Touch(atom/A, proximity)

	if(!A || !proximity)
		return FALSE

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || (!H.back && !H.belt))
		return FALSE

	var/obj/item/hardsuit/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return FALSE

	for(var/obj/item/rig_module/basic/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return TRUE

	return FALSE
