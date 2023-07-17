/obj/item/hardsuit/proc/helmet_deleted(obj/item/clothing/head/hardsuit/helmet)
	piece_deleted(helmet)

/obj/item/hardsuit/proc/chestpiece_deleted(obj/item/clothing/suit/hardsuit/chestpiece)
	piece_deleted(chestpiece)

/obj/item/hardsuit/proc/gauntlets_deleted(obj/item/clothing/gloves/hardsuit/gauntlets)
	piece_deleted(gauntlets)

/obj/item/hardsuit/proc/boots_deleted(obj/item/clothing/shoes/hardsuit/boots)
	piece_deleted(boots)

/obj/item/hardsuit/proc/piece_deleted(obj/item/piece)

//? piece defs

/obj/item/clothing/head/hardsuit
	name = "helmet"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | ALLOW_SURVIVALFOOD | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB | ALLOWINTERNALS
	inv_hide_flags      = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	heat_protection    = HEAD|FACE|EYES
	cold_protection    = HEAD|FACE|EYES
	brightness_on = 4

	max_pressure_protection = null
	min_pressure_protection = null
	damage_force = 3 // if you're headbutting someone with something meant to protect you from space...

	/// host hardsuit
	var/obj/item/hardsuit/hardsuit

/obj/item/clothing/head/hardsuit/Initialize(mapload, obj/item/hardsuit/hardsuit)
	src.hardsuit = hardsuit
	return ..()

/obj/item/clothing/head/hardsuit/Destroy()
	if(hardsuit.helmet == src)
		hardsuit.helmet = null
		hardsuit.helmet_deleted(src)
	hardsuit = null
	return ..()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/hardsuit/proc/prevent_track()
	return FALSE

/obj/item/clothing/suit/hardsuit
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)

	//Flags
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	clothing_flags     = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	cold_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	atom_flags              = PHORONGUARD
	inv_hide_flags          = HIDEJUMPSUIT|HIDETAIL
	heat_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

	slowdown = NONE

	// Will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit.
	// Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = TRUE

	supporting_limbs = list()
	var/obj/item/material/knife/tacknife
	max_pressure_protection = null
	min_pressure_protection = null

	/// host hardsuit
	var/obj/item/hardsuit/hardsuit

/obj/item/clothing/suit/hardsuit/Initialize(mapload, obj/item/hardsuit/hardsuit)
	src.hardsuit = hardsuit
	return ..()

/obj/item/clothing/suit/hardsuit/Destroy()
	if(hardsuit.chestpiece == src)
		hardsuit.chestpiece = null
		hardsuit.chestpiece_deleted(src)
	hardsuit = null
	return ..()

/obj/item/clothing/suit/space/hardsuit/attack_hand(mob/user, list/params, datum/event_args/clickchain/e_args)
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

/obj/item/clothing/gloves/hardsuit
	name = "gauntlets"
	clothing_flags = CLOTHING_THICK_MATERIAL | CLOTHING_INJECTION_PORT | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	atom_flags = PHORONGUARD
	body_cover_flags = HANDS
	heat_protection    = HANDS
	cold_protection    = HANDS

	/// host hardsuit
	var/obj/item/hardsuit/hardsuit

/obj/item/clothing/gloves/hardsuit/Initialize(mapload, obj/item/hardsuit/hardsuit)
	src.hardsuit = hardsuit
	return ..()

/obj/item/clothing/gloves/hardsuit/Destroy()
	if(hardsuit.gauntlets == src)
		hardsuit.gauntlets = null
		hardsuit.gauntlets_deleted(src)
	hardsuit = null
	return ..()

/obj/item/clothing/gloves/gauntlets/hardsuit/Touch(atom/A, proximity)

	if(!A || !proximity)
		return FALSE

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || (!H.back && !H.belt))
		return FALSE

	var/obj/item/hardsuit/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return FALSE

	for(var/obj/item/hardsuit_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return TRUE

	return FALSE

/obj/item/clothing/shoes/hardsuit
	name = "boots"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_IGNORE_BELTLINK | CLOTHING_INJECTION_PORT | CLOTHING_THICK_MATERIAL | CLOTHING_IGNORE_DELIMB
	body_cover_flags = FEET
	cold_protection    = FEET
	heat_protection    = FEET

	icon_base = null
	damage_force = 5 // if you're kicking someone with something meant to keep you locked on a hunk of metal...

	/// host hardsuit
	var/obj/item/hardsuit/hardsuit

/obj/item/clothing/shoes/hardsuit/Initialize(mapload, obj/item/hardsuit/hardsuit)
	src.hardsuit = hardsuit
	return ..()

/obj/item/clothing/shoes/hardsuit/Destroy()
	if(hardsuit.boots == src)
		hardsuit.boots = null
		hardsuit.boots_deleted(src)
	hardsuit = null
	return ..()
