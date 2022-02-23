//
// Because of our custom change in update_icons, we cannot rely upon the normal
// method of switching sprites when refitting (which is to have the referitter
// set the value of icon_override).  Therefore we use the sprite sheets method
// instead.
//

/obj/item/clothing/head/helmet/space/void
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/helmet.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/helmet.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/helmet.dmi',
		"Teshari"				= 'icons/mob/species/teshari/head.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/helmet_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/helmet_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/helmet_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/helmet_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/helmet_vr.dmi',
		"Vulpkanin"				= 'icons/mob/species/vulpkanin/helmet.dmi',
		"Promethean"			= 'icons/mob/species/skrell/helmet.dmi',
		"Xenomorph Hybrid"		= 'icons/mob/species/unathi/helmet.dmi',
		"Vox"					= 'icons/mob/species/vox/helmet.dmi'
		)

	sprite_sheets_obj = list(
		"Tajara" 			= 'icons/obj/clothing/species/tajaran/hats.dmi', // Copied from void.dm
		"Skrell"			= 'icons/obj/clothing/species/skrell/hats.dmi',  // Copied from void.dm
		"Unathi"			= 'icons/obj/clothing/species/unathi/hats.dmi',  // Copied from void.dm
		"Teshari"			= 'icons/obj/clothing/species/teshari/hats.dmi',  // Copied from void.dm
		"Nevrean"			= 'icons/obj/clothing/species/nevrean/hats.dmi',
		"Akula"				= 'icons/obj/clothing/species/akula/hats.dmi',
		"Sergal"			= 'icons/obj/clothing/species/sergal/hats.dmi',
		"Flatland Zorren"	= 'icons/obj/clothing/species/fennec/hats.dmi',
		"Highlander Zorren"	= 'icons/obj/clothing/species/fox/hats.dmi',
		"Vulpkanin"			= 'icons/obj/clothing/species/vulpkanin/hats.dmi',
		"Promethean"		= 'icons/obj/clothing/species/skrell/hats.dmi',
		"Xenomorph Hybrid"	= 'icons/obj/clothing/species/unathi/hats.dmi',
		"Vox"				= 'icons/obj/clothing/species/vox/hats.dmi'
		)

/obj/item/clothing/suit/space/void
	sprite_sheets = list(
		"Tajara" 				= 'icons/mob/species/tajaran/suit.dmi',
		"Skrell" 				= 'icons/mob/species/skrell/suit.dmi',
		"Unathi" 				= 'icons/mob/species/unathi/suit.dmi',
		"Teshari"				= 'icons/mob/species/teshari/suit.dmi',
		"Nevrean" 				= 'icons/mob/species/nevrean/suit_vr.dmi',
		"Akula" 				= 'icons/mob/species/akula/suit_vr.dmi',
		"Sergal"				= 'icons/mob/species/sergal/suit_vr.dmi',
		"Flatland Zorren" 		= 'icons/mob/species/fennec/suit_vr.dmi',
		"Highlander Zorren" 	= 'icons/mob/species/fox/suit_vr.dmi',
		"Vulpkanin"				= 'icons/mob/species/vulpkanin/suit.dmi',
		"Promethean"			= 'icons/mob/species/skrell/suit.dmi',
		"Xenomorph Hybrid"		= 'icons/mob/species/unathi/suit.dmi',
		"Vox"					= 'icons/mob/species/vox/suit.dmi'
		)



	sprite_sheets_obj = list(
		"Tajara"			= 'icons/obj/clothing/species/tajaran/suits.dmi', // Copied from void.dm
		"Skrell"			= 'icons/obj/clothing/species/skrell/suits.dmi',  // Copied from void.dm
		"Unathi"			= 'icons/obj/clothing/species/unathi/suits.dmi',  // Copied from void.dm
		"Teshari"			= 'icons/obj/clothing/species/teshari/suits.dmi',  // Copied from void.dm
		"Nevrean"			= 'icons/obj/clothing/species/nevrean/suits.dmi',
		"Akula"				= 'icons/obj/clothing/species/akula/suits.dmi',
		"Sergal"			= 'icons/obj/clothing/species/sergal/suits.dmi',
		"Flatland Zorren"	= 'icons/obj/clothing/species/fennec/suits.dmi',
		"Highlander Zorren"	= 'icons/obj/clothing/species/fox/suits.dmi',
		"Vulpkanin"			= 'icons/obj/clothing/species/vulpkanin/suits.dmi',
		"Promethean"		= 'icons/obj/clothing/species/skrell/suits.dmi',
		"Vox"				= 'icons/obj/clothing/species/vox/suits.dmi'
		)

	// This is a hack to prevent the item_state variable on the suits from taking effect
	// when the item is equipped in outer clothing slot.
	// This variable is normally used to set the icon_override when the suit is refitted,
	// however the species spritesheet now means we no longer need that anyway!
	sprite_sheets_refit = list()

/obj/item/clothing/suit/space/void/explorer
	desc = "A classy red voidsuit for the needs of any semi-retro-futuristic spaceperson! This one is rather loose fitting."
	species_restricted = list(
		SPECIES_HUMAN,
		SPECIES_SKRELL,
		SPECIES_UNATHI,
		SPECIES_TAJ,
		SPECIES_TESHARI,
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_NEVREAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_VASILISSAN,
		SPECIES_VULPKANIN,
		SPECIES_XENOCHIMERA,
		SPECIES_XENOHYBRID,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH,
		SPECIES_VOX,
		SPECIES_AURIL,
		SPECIES_DREMACHIR,
		SPECIES_VETALA_PALE,
		SPECIES_VETALA_RUDDY,
		SPECIES_APIDAEN
	)
/obj/item/clothing/suit/space/void/explorer/Initialize(mapload)
	. = ..()
	sprite_sheets += sprite_sheets_refit

/obj/item/clothing/head/helmet/space/void/explorer
	desc = "A helmet that matches a red voidsuit! So classy."
	species_restricted = list(
		SPECIES_HUMAN,
		SPECIES_SKRELL,
		SPECIES_UNATHI,
		SPECIES_TAJ,
		SPECIES_TESHARI,
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_NEVREAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_VASILISSAN,
		SPECIES_VULPKANIN,
		SPECIES_XENOCHIMERA,
		SPECIES_XENOHYBRID,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH,
		SPECIES_VOX,
		SPECIES_AURIL,
		SPECIES_DREMACHIR,
		SPECIES_VETALA_PALE,
		SPECIES_VETALA_RUDDY,
		SPECIES_APIDAEN
	)
/obj/item/clothing/head/helmet/space/void/explorer/Initialize(mapload)
	. = ..()
	sprite_sheets += sprite_sheets_refit


/obj/item/clothing/suit/space/void/autolok
	name = "AutoLok pressure suit"
	desc = "A high-tech snug-fitting pressure suit. Fits any species. It offers very little physical protection, but is equipped with sensors that will automatically deploy the integral helmet to protect the wearer."
	icon_state = "autoloksuit"
	item_state = "autoloksuit"
	armor = list(melee = 15, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 100, rad = 80)
	slowdown = 0.5
	siemens_coefficient = 1
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt
	icon = 'icons/obj/clothing/suits_vr.dmi'
	breach_threshold = 6 //this thing is basically tissue paper
	w_class = ITEMSIZE_NORMAL //if it's snug, high-tech, and made of relatively soft materials, it should be much easier to store!

/obj/item/clothing/suit/space/void/autolok
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/spacesuit_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/suit_vr.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/suit_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_TESHARI			= 'icons/mob/species/teshari/suit_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_TESHARI			= 'icons/obj/clothing/suits_vr.dmi'
		)

/obj/item/clothing/suit/space/void/autolok/Initialize()
	. = ..()
	helmet = new /obj/item/clothing/head/helmet/space/void/autolok //autoinstall the helmet

//override the attackby screwdriver proc so that people can't remove the helmet
/obj/item/clothing/suit/space/void/autolok/attackby(obj/item/W as obj, mob/user as mob)

	if(!isliving(user))
		return

	if(istype(W, /obj/item/clothing/accessory) || istype(W, /obj/item/hand_labeler))
		return ..()

	if(user.get_inventory_slot(src) == slot_wear_suit)
		to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		return

	if(W.is_screwdriver())
		if(boots || tank || cooler)
			var/choice = input("What component would you like to remove?") as null|anything in list(boots,tank,cooler)
			if(!choice) return

			if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
				to_chat(user, "You pop \the [tank] out of \the [src]'s storage compartment.")
				tank.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.tank = null
			else if(choice == cooler)
				to_chat(user, "You pop \the [cooler] out of \the [src]'s storage compartment.")
				cooler.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.cooler = null
			else if(choice == boots)
				to_chat(user, "You detach \the [boots] from \the [src]'s boot mounts.")
				boots.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.boots = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return

	..()

/obj/item/clothing/head/helmet/space/void/autolok
	name = "AutoLok pressure helmet"
	desc = "A rather close-fitting helmet designed to protect the wearer from hazardous conditions. Automatically deploys when the suit's sensors detect an environment that is hazardous to the wearer."
	icon_state = "autolokhelmet"
	item_state = "autolokhelmet"
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt too
	icon = 'icons/obj/clothing/hats_vr.dmi'
	flags_inv = HIDEEARS|BLOCKHAIR //removed HIDEFACE/MASK/EYES flags so sunglasses or facemasks don't disappear. still gotta have BLOCKHAIR or it'll clip out tho.

/obj/item/clothing/head/helmet/space/void/autolok
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/head_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/helmet_vr.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/helmet_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_TESHARI			= 'icons/mob/species/teshari/helmet_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_TESHARI			= 'icons/obj/clothing/hats_vr.dmi'
		)
	sprite_sheets_refit = list()	//have to nullify this as well just to be thorough
