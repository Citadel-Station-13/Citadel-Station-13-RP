//
// Because of our custom change in update_icons, we cannot rely upon the normal
// method of switching sprites when refitting (which is to have the referitter
// set the value of icon_override).  Therefore we use the sprite sheets method
// instead.
//

/obj/item/clothing/head/helmet/space/void
	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/clothing/species/akula/helmet.dmi',
		SPECIES_NEVREAN     = 'icons/mob/clothing/species/nevrean/helmet.dmi',
		SPECIES_PROMETHEAN  = 'icons/mob/clothing/species/skrell/helmet.dmi',
		SPECIES_SERGAL      = 'icons/mob/clothing/species/sergal/helmet.dmi',
		SPECIES_SKRELL      = 'icons/mob/clothing/species/skrell/helmet.dmi',
		SPECIES_TAJ         = 'icons/mob/clothing/species/tajaran/helmet.dmi',
		SPECIES_TESHARI     = 'icons/mob/clothing/species/teshari/head.dmi',
		SPECIES_UNATHI      = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_VOX         = 'icons/mob/clothing/species/vox/helmet.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/helmet.dmi',
		SPECIES_XENOHYBRID  = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_ZORREN_FLAT = 'icons/mob/clothing/species/fennec/helmet.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/clothing/species/fox/helmet.dmi',
		)

	sprite_sheets_obj = list(
		SPECIES_TAJ         = 'icons/obj/clothing/species/tajaran/hats.dmi',
		SPECIES_SKRELL      = 'icons/obj/clothing/species/skrell/hats.dmi',
		SPECIES_UNATHI      = 'icons/obj/clothing/species/unathi/hats.dmi',
		SPECIES_TESHARI     = 'icons/obj/clothing/species/teshari/hats.dmi',
		SPECIES_NEVREAN     = 'icons/obj/clothing/species/nevrean/hats.dmi',
		SPECIES_AKULA       = 'icons/obj/clothing/species/akula/hats.dmi',
		SPECIES_SERGAL      = 'icons/obj/clothing/species/sergal/hats.dmi',
		SPECIES_ZORREN_FLAT = 'icons/obj/clothing/species/fennec/hats.dmi',
		SPECIES_ZORREN_HIGH = 'icons/obj/clothing/species/fox/hats.dmi',
		SPECIES_VULPKANIN   = 'icons/obj/clothing/species/vulpkanin/hats.dmi',
		SPECIES_PROMETHEAN  = 'icons/obj/clothing/species/skrell/hats.dmi',
		SPECIES_XENOHYBRID  = 'icons/obj/clothing/species/unathi/hats.dmi',
		SPECIES_VOX         = 'icons/obj/clothing/species/vox/hats.dmi',
		)

/obj/item/clothing/suit/space/void
	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/clothing/species/akula/suits.dmi',
		SPECIES_NEVREAN     = 'icons/mob/clothing/species/nevrean/suits.dmi',
		SPECIES_PROMETHEAN  = 'icons/mob/clothing/species/skrell/suits.dmi',
		SPECIES_SERGAL      = 'icons/mob/clothing/species/sergal/suits.dmi',
		SPECIES_SKRELL      = 'icons/mob/clothing/species/skrell/suits.dmi',
		SPECIES_TAJ         = 'icons/mob/clothing/species/tajaran/suits.dmi',
		SPECIES_TESHARI     = 'icons/mob/clothing/species/teshari/suits.dmi',
		SPECIES_UNATHI      = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_VOX         = 'icons/mob/clothing/species/vox/suits.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/suits.dmi',
		SPECIES_XENOHYBRID  = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_ZORREN_FLAT = 'icons/mob/clothing/species/fennec/suits.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/clothing/species/fox/suits.dmi',
		)

	sprite_sheets_obj = list(
		SPECIES_AKULA       = 'icons/obj/clothing/species/akula/suits.dmi',
		SPECIES_NEVREAN     = 'icons/obj/clothing/species/nevrean/suits.dmi',
		SPECIES_PROMETHEAN  = 'icons/obj/clothing/species/skrell/suits.dmi',
		SPECIES_SERGAL      = 'icons/obj/clothing/species/sergal/suits.dmi',
		SPECIES_SKRELL      = 'icons/obj/clothing/species/skrell/suits.dmi',
		SPECIES_TAJ         = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_TESHARI     = 'icons/obj/clothing/species/teshari/suits.dmi',
		SPECIES_UNATHI      = 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_VOX         = 'icons/obj/clothing/species/vox/suits.dmi',
		SPECIES_VULPKANIN   = 'icons/obj/clothing/species/vulpkanin/suits.dmi',
		SPECIES_ZORREN_FLAT = 'icons/obj/clothing/species/fennec/suits.dmi',
		SPECIES_ZORREN_HIGH = 'icons/obj/clothing/species/fox/suits.dmi',
		)

	// This is a hack to prevent the item_state variable on the suits from taking effect
	// when the item is equipped in outer clothing slot.
	// This variable is normally used to set the icon_override when the suit is refitted,
	// however the species spritesheet now means we no longer need that anyway!
	sprite_sheets_refit = list()

/obj/item/clothing/suit/space/void/explorer
	desc = "A classy red voidsuit for the needs of any semi-retro-futuristic spaceperson! This one is rather loose fitting."
	species_restricted = list(
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_APIDAEN,
		SPECIES_AURIL,
		SPECIES_DREMACHIR,
		SPECIES_HUMAN,
		SPECIES_NEVREAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_SKRELL,
		SPECIES_TAJ,
		SPECIES_TESHARI,
		SPECIES_UNATHI,
		SPECIES_VASILISSAN,
		SPECIES_VETALA_PALE,
		SPECIES_VETALA_RUDDY,
		SPECIES_VOX,
		SPECIES_VULPKANIN,
		SPECIES_XENOCHIMERA,
		SPECIES_XENOHYBRID,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH,
	)

/obj/item/clothing/suit/space/void/explorer/Initialize(mapload)
	. = ..()
	sprite_sheets += sprite_sheets_refit

/obj/item/clothing/head/helmet/space/void/explorer
	desc = "A helmet that matches a red voidsuit! So classy."
	species_restricted = list(
		SPECIES_AKULA,
		SPECIES_ALRAUNE,
		SPECIES_APIDAEN,
		SPECIES_AURIL,
		SPECIES_DREMACHIR,
		SPECIES_HUMAN,
		SPECIES_NEVREAN,
		SPECIES_RAPALA,
		SPECIES_SERGAL,
		SPECIES_SKRELL,
		SPECIES_TAJ,
		SPECIES_TESHARI,
		SPECIES_UNATHI,
		SPECIES_VASILISSAN,
		SPECIES_VETALA_PALE,
		SPECIES_VETALA_RUDDY,
		SPECIES_VOX,
		SPECIES_VULPKANIN,
		SPECIES_XENOCHIMERA,
		SPECIES_XENOHYBRID,
		SPECIES_ZORREN_FLAT,
		SPECIES_ZORREN_HIGH,
	)

/obj/item/clothing/head/helmet/space/void/explorer/Initialize(mapload)
	. = ..()
	sprite_sheets += sprite_sheets_refit


/obj/item/clothing/suit/space/void/autolok
	name = "AutoLok pressure suit"
	desc = "A high-tech snug-fitting pressure suit. Fits any species. It offers very little physical protection, \
	but is equipped with sensors that will automatically deploy the integral helmet to protect the wearer."
	icon_state = "autoloksuit"
	item_state = "autoloksuit"
	armor = list(melee = 15, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 100, rad = 80)
	slowdown = 0.5
	siemens_coefficient = 1
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX) //this thing can autoadapt
	breach_threshold = 6 //this thing is basically tissue paper
	w_class = ITEMSIZE_NORMAL //if it's snug, high-tech, and made of relatively soft materials, it should be much easier to store!

/obj/item/clothing/suit/space/void/autolok
	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_FENNEC      = 'icons/mob/clothing/species/vulpkanin/suits.dmi',
		SPECIES_HUMAN       = 'icons/mob/clothing/spacesuits.dmi',
		SPECIES_SERGAL      = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_SKRELL      = 'icons/mob/clothing/species/skrell/suits.dmi',
		SPECIES_TAJ         = 'icons/mob/clothing/species/tajaran/suits.dmi',
		SPECIES_TESHARI     = 'icons/mob/clothing/species/teshari/suits.dmi',
		SPECIES_UNATHI      = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/suits.dmi',
		SPECIES_XENOHYBRID  = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/clothing/species/vulpkanin/suits.dmi',
		)

/obj/item/clothing/suit/space/void/autolok/Initialize(mapload)
	. = ..()
	helmet = new /obj/item/clothing/head/helmet/space/void/autolok //autoinstall the helmet

//override the attackby screwdriver proc so that people can't remove the helmet
/obj/item/clothing/suit/space/void/autolok/attackby(obj/item/W as obj, mob/user as mob)

	if(!isliving(user))
		return

	if(istype(W, /obj/item/clothing/accessory) || istype(W, /obj/item/hand_labeler))
		return ..()

	if(user.get_inventory_slot(src) == slot_wear_suit)
		to_chat(user, SPAN_WARNING("You cannot modify \the [src] while it is being worn."))
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
	desc = "A rather close-fitting helmet designed to protect the wearer from hazardous conditions. \
	Automatically deploys when the suit's sensors detect an environment that is hazardous to the wearer."
	icon_state = "autolokhelmet"
	item_state = "autolokhelmet"
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt too
	flags_inv = HIDEEARS|BLOCKHAIR //removed HIDEFACE/MASK/EYES flags so sunglasses or facemasks don't disappear. still gotta have BLOCKHAIR or it'll clip out tho.

/obj/item/clothing/head/helmet/space/void/autolok
	sprite_sheets = list(
		SPECIES_AKULA       = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_FENNEC      = 'icons/mob/clothing/species/vulpkanin/helmet.dmi',
		SPECIES_HUMAN       = INV_HEAD_DEF_ICON,
		SPECIES_SERGAL      = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_SKRELL      = 'icons/mob/clothing/species/skrell/helmet.dmi',
		SPECIES_TAJ         = 'icons/mob/clothing/species/tajaran/helmet.dmi',
		SPECIES_TESHARI     = 'icons/mob/clothing/species/teshari/head.dmi',
		SPECIES_UNATHI      = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_VULPKANIN   = 'icons/mob/clothing/species/vulpkanin/helmet.dmi',
		SPECIES_XENOHYBRID  = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_ZORREN_HIGH = 'icons/mob/clothing/species/vulpkanin/helmet.dmi',
		)

	sprite_sheets_obj = list(
		SPECIES_AKULA       = 'icons/obj/clothing/hats.dmi',
		SPECIES_FENNEC      = 'icons/obj/clothing/hats.dmi',
		SPECIES_SERGAL      = 'icons/obj/clothing/hats.dmi',
		SPECIES_SKRELL      = 'icons/obj/clothing/hats.dmi',
		SPECIES_TAJ         = 'icons/obj/clothing/hats.dmi',
		SPECIES_TESHARI     = 'icons/obj/clothing/hats.dmi',
		SPECIES_UNATHI      = 'icons/obj/clothing/hats.dmi',
		SPECIES_VULPKANIN   = 'icons/obj/clothing/hats.dmi',
		SPECIES_XENOHYBRID  = 'icons/obj/clothing/hats.dmi',
		SPECIES_ZORREN_HIGH = 'icons/obj/clothing/hats.dmi',
	)

	sprite_sheets_refit = list()	//have to nullify this as well just to be thorough
