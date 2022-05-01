/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/rig
	name = "helmet"
	body_parts_covered = HEAD|FACE|EYES
	heat_protection    = HEAD|FACE|EYES
	cold_protection    = HEAD|FACE|EYES
	item_flags         = THICKMATERIAL|ALLOW_SURVIVALFOOD
	flags_inv          = HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	flags              = PHORONGUARD
	brightness_on = 4
	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/species/akula/head.dmi',
		SPECIES_NEVREAN     = 'icons/mob/species/nevrean/head.dmi',
		SPECIES_PLASMAMAN   = 'icons/mob/species/phoronoid/head.dmi',
		SPECIES_PROMETHEAN  = 'icons/mob/species/skrell/head.dmi',
		SPECIES_SERGAL      = 'icons/mob/species/sergal/head.dmi',
		SPECIES_SKRELL      = 'icons/mob/species/skrell/head.dmi',
		SPECIES_TAJARA      = 'icons/mob/species/tajaran/head.dmi',
		SPECIES_TESHARI     = 'icons/mob/species/teshari/head.dmi',
		SPECIES_UNATHI      = 'icons/mob/species/unathi/head.dmi',
		SPECIES_VOX         = 'icons/mob/species/vox/head.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/species/vulpkanin/head.dmi',
		SPECIES_XENOHYBRID  = 'icons/mob/species/unathi/head.dmi',
		SPECIES_ZADDAT      = 'icons/mob/species/zaddat/head.dmi',
		SPECIES_ZORREN_FLAT = 'icons/mob/species/fennec/head.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/species/fox/head.dmi'
		)
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_XENOHYBRID, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_ALRAUNE, SPECIES_ZADDAT, SPECIES_PLASMAMAN, SPECIES_APIDAEN, SPECIES_VETALA_RUDDY, SPECIES_VETALA_PALE, SPECIES_AURIL, SPECIES_DREMACHIR)
	max_pressure_protection = null
	min_pressure_protection = null
	force = 3 // if you're headbutting someone with something meant to protect you from space...

/obj/item/clothing/gloves/gauntlets/rig
	name = "gauntlets"
	body_parts_covered = HANDS
	heat_protection    = HANDS
	cold_protection    = HANDS
	item_flags         = THICKMATERIAL
	flags              = PHORONGUARD
	species_restricted = list(
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_APIDAEN,
		SPECIES_AURIL,
		SPECIES_DREMACHIR,
		SPECIES_HUMAN,
		SPECIES_NEVREAN,
		SPECIES_PLASMAMAN,
		SPECIES_PROMETHEAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_SKRELL,
		SPECIES_TAJARA,
		SPECIES_TESHARI,
		SPECIES_UNATHI,
		SPECIES_VASILISSAN,
		SPECIES_VETALA_PALE,
		SPECIES_VETALA_RUDDY,
		SPECIES_VOX,
		SPECIES_VULPKANIN,
		SPECIES_XENOHYBRID,
		SPECIES_ZADDAT,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH)

	gender = PLURAL

/obj/item/clothing/shoes/magboots/rig
	name = "boots"
	flags = PHORONGUARD
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	gender = PLURAL
	icon_base = null
	sprite_sheets = list(
		SPECIES_TESHARI   = 'icons/mob/species/teshari/feet.dmi',
		SPECIES_VOX       = 'icons/mob/species/vox/shoes.dmi',
		SPECIES_WEREBEAST = 'icons/mob/species/werebeast/feet.dmi',
		SPECIES_ZADDAT    = 'icons/mob/species/zaddat/shoes.dmi' //? Zaddat Engi RIG appearance is unique.
		)

	species_restricted = list(
		SPECIES_AKULA, SPECIES_ALRAUNE, SPECIES_APIDAEN,
		SPECIES_AURIL, SPECIES_DREMACHIR, SPECIES_HUMAN,
		SPECIES_NEVREAN, SPECIES_PLASMAMAN, SPECIES_PROMETHEAN,
		SPECIES_RAPALA, SPECIES_SERGAL, SPECIES_SKRELL,
		SPECIES_TAJARA, SPECIES_TESHARI, SPECIES_UNATHI,
		SPECIES_VASILISSAN, SPECIES_VETALA_PALE, SPECIES_VETALA_RUDDY,
		SPECIES_VOX, SPECIES_VULPKANIN, SPECIES_XENOHYBRID,
		SPECIES_ZADDAT, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH)
	force = 5 // if you're kicking someone with something meant to keep you locked on a hunk of metal...

/obj/item/clothing/suit/space/rig
	name = "chestpiece"
	flags = PHORONGUARD
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv          = HIDEJUMPSUIT|HIDETAIL
	item_flags         = THICKMATERIAL|ALLOWINTERNALS
	slowdown = 0
	//will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit. Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = TRUE

	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/species/akula/suits.dmi',
		SPECIES_NEVREAN     = 'icons/mob/species/nevrean/suits.dmi',
		SPECIES_PLASMAMAN   = 'icons/mob/species/phoronoid/suits.dmi',
		SPECIES_PROMETHEAN  = 'icons/mob/species/skrell/suits.dmi',
		SPECIES_SERGAL      = 'icons/mob/species/sergal/suits.dmi',
		SPECIES_SKRELL      = 'icons/mob/species/skrell/suits.dmi',
		SPECIES_TAJARA      = 'icons/mob/species/tajaran/suits.dmi',
		SPECIES_TESHARI     = 'icons/mob/species/teshari/suits.dmi',
		SPECIES_UNATHI      = 'icons/mob/species/unathi/suits.dmi',
		SPECIES_VOX         = 'icons/mob/species/vox/suits.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/species/vulpkanin/suits.dmi',
		SPECIES_XENOHYBRID  = 'icons/mob/species/unathi/suits.dmi',
		SPECIES_ZADDAT      = 'icons/mob/species/zaddat/suits.dmi',
		SPECIES_ZORREN_FLAT = 'icons/mob/species/fennec/suits.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/species/fox/suits.dmi'
		)

	species_restricted = list(
		SPECIES_AKULA, SPECIES_ALRAUNE, SPECIES_APIDAEN,
		SPECIES_AURIL, SPECIES_DREMACHIR, SPECIES_HUMAN,
		SPECIES_NEVREAN, SPECIES_PLASMAMAN, SPECIES_PROMETHEAN,
		SPECIES_RAPALA, SPECIES_SERGAL, SPECIES_SKRELL,
		SPECIES_TAJARA, SPECIES_TESHARI, SPECIES_UNATHI,
		SPECIES_VASILISSAN, SPECIES_VETALA_PALE, SPECIES_VETALA_RUDDY,
		SPECIES_VOX, SPECIES_VULPKANIN, SPECIES_XENOHYBRID,
		SPECIES_ZADDAT, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH)

	supporting_limbs = list()
	var/obj/item/material/knife/tacknife
	max_pressure_protection = null
	min_pressure_protection = null

/obj/item/clothing/suit/space/rig/attack_hand(var/mob/living/M)
	if(tacknife)
		tacknife.loc = get_turf(src)
		if(M.put_in_active_hand(tacknife))
			to_chat(M, "<span class='notice'>You slide \the [tacknife] out of [src].</span>")
			playsound(M, 'sound/weapons/flipblade.ogg', 40, 1)
			tacknife = null
			update_icon()
		return
	..()

/obj/item/clothing/suit/space/rig/attackby(var/obj/item/I, var/mob/living/M)
	if(istype(I, /obj/item/material/knife/tacknife))
		if(tacknife)
			return
		M.drop_item()
		tacknife = I
		I.loc = src
		to_chat(M, SPAN_NOTICE("You slide the [I] into [src]."))
		playsound(M, 'sound/weapons/flipblade.ogg', 40, 1)
		update_icon()
	..()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/rig/proc/prevent_track()
	return FALSE

/obj/item/clothing/gloves/gauntlets/rig/Touch(var/atom/A, var/proximity)

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

//! ## Rig pieces for non-spacesuit based rigs

/obj/item/clothing/head/lightrig
	name = "mask"
	body_parts_covered = HEAD|FACE|EYES
	heat_protection    = HEAD|FACE|EYES
	cold_protection    = HEAD|FACE|EYES
	item_flags         = THICKMATERIAL
	flags              = PHORONGUARD|ALLOWINTERNALS

/obj/item/clothing/suit/lightrig
	name = "suit"
	allowed = list(/obj/item/flashlight)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection    = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv          = HIDEJUMPSUIT
	item_flags         = THICKMATERIAL
	flags              = PHORONGUARD


/obj/item/clothing/shoes/lightrig
	name = "boots"
	species_restricted = null
	body_parts_covered = FEET
	cold_protection    = FEET
	heat_protection    = FEET
	item_flags         = THICKMATERIAL
	flags              = PHORONGUARD

/obj/item/clothing/gloves/gauntlets/lightrig
	name = "gloves"
	species_restricted = null
	body_parts_covered = HANDS
	heat_protection    = HANDS
	cold_protection    = HANDS
	item_flags         = THICKMATERIAL
	flags              = PHORONGUARD
