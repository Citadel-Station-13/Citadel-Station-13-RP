/obj/item/rig/proc/helmet_deleted(obj/item/clothing/head/rig/helmet)
	piece_deleted(helmet)

/obj/item/rig/proc/chestpiece_deleted(obj/item/clothing/suit/rig/chestpiece)
	piece_deleted(chestpiece)

/obj/item/rig/proc/gauntlets_deleted(obj/item/clothing/gloves/rig/gauntlets)
	piece_deleted(gauntlets)

/obj/item/rig/proc/boots_deleted(obj/item/clothing/shoes/rig/boots)
	piece_deleted(boots)

/obj/item/rig/proc/piece_deleted(obj/item/piece)

//? piece defs

/obj/item/clothing/head/rig
	name = "helmet"
	atom_flags = PHORONGUARD
	clothing_flags = THICKMATERIAL | ALLOW_SURVIVALFOOD | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB | ALLOWINTERNALS
	inv_hide_flags      = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	heat_protection    = HEAD|FACE|EYES
	cold_protection    = HEAD|FACE|EYES
	brightness_on = 4

	max_pressure_protection = null
	min_pressure_protection = null
	damage_force = 3 // if you're headbutting someone with something meant to protect you from space...

	/// host rig
	var/obj/item/rig/rig

/obj/item/clothing/head/rig/Initialize(mapload, obj/item/rig/rig)
	src.rig = rig
	return ..()

/obj/item/clothing/head/rig/Destroy()
	if(rig.helmet == src)
		rig.helmet = null
		rig.helmet_deleted(src)
	rig = null
	return ..()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/rig/proc/prevent_track()
	return FALSE

/obj/item/clothing/suit/rig
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)

	//Flags
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	clothing_flags     = THICKMATERIAL | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
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

	/// host rig
	var/obj/item/rig/rig

/obj/item/clothing/suit/rig/Initialize(mapload, obj/item/rig/rig)
	src.rig = rig
	return ..()

/obj/item/clothing/suit/rig/Destroy()
	if(rig.chestpiece == src)
		rig.chestpiece = null
		rig.chestpiece_deleted(src)
	rig = null
	return ..()

/obj/item/clothing/suit/space/rig/attack_hand(mob/user, list/params)
	if(tacknife)
		tacknife.loc = get_turf(src)
		if(user.put_in_active_hand(tacknife))
			to_chat(user, SPAN_NOTICE("You slide \the [tacknife] out of [src]."))
			playsound(user, 'sound/weapons/flipblade.ogg', 40, TRUE)
			tacknife = null
			update_icon()
		return
	..()

/obj/item/clothing/suit/space/rig/attackby(obj/item/I, mob/living/M)
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

/obj/item/clothing/gloves/rig
	name = "gauntlets"
	clothing_flags = THICKMATERIAL | CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	atom_flags = PHORONGUARD
	body_cover_flags = HANDS
	heat_protection    = HANDS
	cold_protection    = HANDS

	/// host rig
	var/obj/item/rig/rig

/obj/item/clothing/gloves/rig/Initialize(mapload, obj/item/rig/rig)
	src.rig = rig
	return ..()

/obj/item/clothing/gloves/rig/Destroy()
	if(rig.gauntlets == src)
		rig.gauntlets = null
		rig.gauntlets_deleted(src)
	rig = null
	return ..()

/obj/item/clothing/gloves/gauntlets/rig/Touch(atom/A, proximity)

	if(!A || !proximity)
		return FALSE

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || (!H.back && !H.belt))
		return FALSE

	var/obj/item/rig/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return FALSE

	for(var/obj/item/rig_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return TRUE

	return FALSE

/obj/item/clothing/shoes/rig
	name = "boots"
	atom_flags = PHORONGUARD
	clothing_flags = CLOTHING_IGNORE_BELTLINK | CLOTHING_IGNORE_DELIMB
	body_cover_flags = FEET
	cold_protection    = FEET
	heat_protection    = FEET

	icon_base = null
	damage_force = 5 // if you're kicking someone with something meant to keep you locked on a hunk of metal...

	/// host rig
	var/obj/item/rig/rig

/obj/item/clothing/shoes/rig/Initialize(mapload, obj/item/rig/rig)
	src.rig = rig
	return ..()

/obj/item/clothing/shoes/rig/Destroy()
	if(rig.boots == src)
		rig.boots = null
		rig.boots_deleted(src)
	rig = null
	return ..()
