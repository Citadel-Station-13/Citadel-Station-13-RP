/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_state = "backpack"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = INVENTORY_STANDARD_SPACE
	var/flippable = 0
	var/side = 0 //0 = right, 1 = left
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/storage/backpack/attackby(obj/item/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()

/obj/item/storage/backpack/equipped(var/mob/user, var/slot)
	if (slot == SLOT_ID_BACK && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user, slot)

/*
/obj/item/storage/backpack/dropped(mob/user, flags, atom/newLoc)
	if (loc == user && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user)
*/

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_NORMAL * 14 // 56
	storage_cost = INVENTORY_STANDARD_SPACE + 1

/obj/item/storage/backpack/holding/duffle
	name = "dufflebag of holding"
	icon_state = "holdingduffle"

/obj/item/storage/backpack/holding/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage/backpack/holding))
		to_chat(user, "<span class='warning'>The Bluespace interfaces of the two devices conflict and malfunction.</span>")
		//qdel(W) - fuck this holy shit
		return
	. = ..()

/obj/item/storage/backpack/holding/singularity_act(obj/singularity/S, current_size)
	var/turf/lastLoc = get_turf(src)
	. = ..()
	if(lastLoc)
		var/dist = max((current_size - 2),1)
		log_game("Bag of holding detonated at [COORD(lastLoc)]")
		explosion(lastLoc, (dist), (dist*2), (dist*4))

//Please don't clutter the parent storage item with stupid hacks.
/*/obj/item/storage/backpack/holding/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(istype(W, /obj/item/storage/backpack/holding))
		return 1
	return ..()*/ //- let's not

/obj/item/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "giftbag", SLOT_ID_LEFT_HAND = "giftbag")
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 100 // can store a ton of shit!
	item_state_slots = null

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"

/obj/item/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "A silent backpack made for those silent workers. Silence Co."
	icon_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "Facility Director's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon_state = "captainpack"

/obj/item/storage/backpack/captain/talon
	name = "talon captain's backpack"
	desc = "It's a special backpack made exclusively for the Talon's captain."
/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"

/obj/item/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."
	icon_state = "scipack"

/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "hydpack"

/obj/item/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon_state = "genpack"

/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."
	icon_state = "viropack"

/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."
	icon_state = "chempack"

/obj/item/storage/backpack/voyager
	name = "voyager backpack"
	desc = "A leather pack designed for expeditions, covered in multi-purpose pouches and pockets."
	icon_state = "explorerpack"

/*
 * Duffle Types
 */

/obj/item/storage/backpack/dufflebag
	name = "dufflebag"
	desc = "A large dufflebag for holding extra things."
	icon_state = "duffle"
	slowdown = 1
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE

/obj/item/storage/backpack/dufflebag/syndie
	name = "black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies. This one appears to be made out of lighter material than usual."
	icon_state = "duffle-syndie"
	slowdown = 0

/obj/item/storage/backpack/dufflebag/syndie/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra tactical medical supplies. This one appears to be made out of lighter material than usual."
	icon_state = "duffle-syndiemed"

/obj/item/storage/backpack/dufflebag/syndie/ammo
	name = "ammunition dufflebag"
	desc = "A large dufflebag for holding extra weapons ammunition and supplies. This one appears to be made out of lighter material than usual."
	icon_state = "duffle-syndieammo"

/obj/item/storage/backpack/dufflebag/captain
	name = "Facility Director's dufflebag"
	desc = "A large dufflebag for holding extra captainly goods."
	icon_state = "duffle-captain"

/obj/item/storage/backpack/dufflebag/captain/talon
	name = "talon captain's dufflebag"
	desc = "A large dufflebag for holding extra loot."

/obj/item/storage/backpack/dufflebag/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra medical supplies."
	icon_state = "duffle-med"

/obj/item/storage/backpack/dufflebag/chemistry
	name = "chemistry duffle bag"
	desc = "A large duffle bag for holding extra chemical substances."
	icon_state = "duffle-chemistry"

/obj/item/storage/backpack/dufflebag/genetics
	name = "geneticist's duffel bag"
	desc = "A large duffel bag for holding extra genetic mutations."
	icon_state = "duffle-genetics"
/obj/item/storage/backpack/dufflebag/emt
	name = "EMT dufflebag"
	desc = "A large dufflebag for holding extra medical supplies. This one has reflective stripes!"
	icon_state = "duffle-emt"

/obj/item/storage/backpack/dufflebag/virology
	name = "virologist's duffle bag"
	desc = "A large duffle bag for holding extra viral bottles."
	icon_state = "duffle-virology"

/obj/item/storage/backpack/dufflebag/sec
	name = "security dufflebag"
	desc = "A large dufflebag for holding extra security supplies and ammunition."
	icon_state = "duffle-sec"

/obj/item/storage/backpack/dufflebag/eng
	name = "industrial dufflebag"
	desc = "A large dufflebag for holding extra tools and supplies."
	icon_state = "duffle-eng"

/obj/item/storage/backpack/dufflebag/sci
	name = "science dufflebag"
	desc = "A large dufflebag for holding circuits and beakers."
	icon_state = "duffle-sci"

/obj/item/storage/backpack/dufflebag/hydroponics
	name = "hydroponic's duffle bag"
	desc = "A large duffle bag for holding extra gardening tools."
	icon_state = "duffle-hydroponics"

/obj/item/storage/backpack/dufflebag/voyager
	name = "voyager duffle bag"
	desc = "A large dufflebag for expeditions, covered in multi-purpose pouches and pockets."
	icon_state = "duffle-explorer"

/obj/item/storage/backpack/dufflebag/clown
	name = "clown's duffle bag"
	desc = "A large duffle bag for holding lots of funny gags!"
	icon_state = "duffle-clown"

//! ## Satchel Types

/obj/item/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "briefcase", SLOT_ID_LEFT_HAND = "briefcase")

/obj/item/storage/backpack/satchel/withwallet
	starts_with = list(/obj/item/storage/wallet/random)

/obj/item/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "engiepack", SLOT_ID_LEFT_HAND = "engiepack")

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medicalpack", SLOT_ID_LEFT_HAND = "medicalpack")

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "viropack", SLOT_ID_LEFT_HAND = "viropack")

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "chempack", SLOT_ID_LEFT_HAND = "chempack")

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "genpack", SLOT_ID_LEFT_HAND = "genpack")

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-sci"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "toxpack", SLOT_ID_LEFT_HAND = "toxpack")

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "securitypack", SLOT_ID_LEFT_HAND = "securitypack")

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/cap
	name = "Facility Director's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel-cap"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "captainpack", SLOT_ID_LEFT_HAND = "captainpack")

/obj/item/storage/backpack/satchel/cap/talon
	name = "Talon captain's satchel"
	desc = "An exclusive satchel for the Talon's captain."

/obj/item/storage/backpack/satchel/voyager
	name = "voyager satchel"
	desc = "A leather satchel designed for expeditions."
	icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/bone
	name = "bone satchel"
	desc = "A grotesque satchel made of sinew and bone."
	icon_state = "satchel-bone"


//ERT backpacks.
/obj/item/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon_state = "ert_commander"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "securitypack", SLOT_ID_LEFT_HAND = "securitypack")

//Commander
/obj/item/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."

//Security
/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	icon_state = "ert_security"

//Engineering
/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	icon_state = "ert_engineering"

//Medical
/obj/item/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."
	icon_state = "ert_medical"

/*
 * Courier Bags
 */

/obj/item/storage/backpack/messenger
	name = "messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon_state = "courierbag"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "backpack", SLOT_ID_LEFT_HAND = "backpack")

/obj/item/storage/backpack/messenger/chem
	name = "chemistry messenger bag"
	desc = "A serile backpack worn over one shoulder.  This one is in Chemsitry colors."
	icon_state = "courierbagchem"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "chempack", SLOT_ID_LEFT_HAND = "chempack")

/obj/item/storage/backpack/messenger/med
	name = "medical messenger bag"
	desc = "A sterile backpack worn over one shoulder used in medical departments."
	icon_state = "courierbagmed"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medicalpack", SLOT_ID_LEFT_HAND = "medicalpack")

/obj/item/storage/backpack/messenger/viro
	name = "virology messenger bag"
	desc = "A sterile backpack worn over one shoulder.  This one is in Virology colors."
	icon_state = "courierbagviro"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "viropack", SLOT_ID_LEFT_HAND = "viropack")

/obj/item/storage/backpack/messenger/tox
	name = "research messenger bag"
	desc = "A backpack worn over one shoulder.  Useful for holding science materials."
	icon_state = "courierbagsci"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "toxpack", SLOT_ID_LEFT_HAND = "toxpack")

/obj/item/storage/backpack/messenger/com
	name = "command messenger bag"
	desc = "A special backpack worn over one shoulder.  This one is made specifically for officers."
	icon_state = "courierbagcom"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "captainpack", SLOT_ID_LEFT_HAND = "captainpack")

/obj/item/storage/backpack/messenger/com/talon
	name = "captain's messenger bag"
	desc = "A special backpack worn over one shoulder.  This one bears the insignia of the ITV Talon's captain."

/obj/item/storage/backpack/messenger/engi
	name = "engineering messenger bag"
	icon_state = "courierbagengi"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "engiepack", SLOT_ID_LEFT_HAND = "engiepack")

/obj/item/storage/backpack/messenger/hyd
	name = "hydroponics messenger bag"
	desc = "A backpack worn over one shoulder.  This one is designed for plant-related work."
	icon_state = "courierbaghyd"

/obj/item/storage/backpack/messenger/sec
	name = "security messenger bag"
	desc = "A tactical backpack worn over one shoulder. This one is in Security colors."
	icon_state = "courierbagsec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "securitypack", SLOT_ID_LEFT_HAND = "securitypack")

/obj/item/storage/backpack/messenger/black
	icon_state = "courierbagblk"

//RIG Spines
/obj/item/storage/backpack/rig
	name = "resource integration gear"
	desc = "An advanced system that mounts to the user's spine to serve as a load bearing structure with medical utilities. More complex variants have a wider array of functions and uses."
	icon_state = "civilian_rig"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "backpack", SLOT_ID_LEFT_HAND = "backpack")

/*
/obj/item/storage/backpack/rig/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/storage/backpack/rig/process(mob/living/M)
	if(M.health <= M.maxHealth)
		update_icon()

/obj/item/storage/backpack/rig/update_icon(mob/living/M)
	if(M.stat > 1) // Dead
		icon_state = "[initial(icon_state)]_0"
		item_state = "[initial(icon_state)]_0"
		M.update_inv_back()
	else if(round((M.health/M.getMaxHealth())*100) <= 25)
		icon_state = "[initial(icon_state)]_25"
		item_state = "[initial(icon_state)]_25"
		M.update_inv_back()
	else if(round((M.health/M.getMaxHealth())*100) <= 50)
		icon_state = "[initial(icon_state)]_50"
		item_state = "[initial(icon_state)]_50"
		M.update_inv_back()
	else if(round((M.health/M.getMaxHealth())*100) <= 75)
		icon_state = "[initial(icon_state)]_75"
		item_state = "[initial(icon_state)]_75"
		M.update_inv_back()
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(icon_state)]"
		M.update_inv_back()
*/

//Purses
/obj/item/storage/backpack/purse
	name = "purse"
	desc = "A small, fashionable bag typically worn over the shoulder."
	icon_state = "purse"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lgpurse", SLOT_ID_LEFT_HAND = "lgpurse")
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 5

//Parachutes
/obj/item/storage/backpack/parachute
	name = "parachute"
	desc = "A specially made backpack, designed to help one survive jumping from incredible heights. It sacrifices some storage space for that added functionality."
	icon_state = "parachute"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "backpack", SLOT_ID_LEFT_HAND = "backpack")
	max_storage_space = ITEMSIZE_COST_NORMAL * 5

/obj/item/storage/backpack/parachute/examine(mob/user)
	. = ..()
	if(get_dist(src, user) <= 1)
		if(parachute)
			. += " It seems to be packed."
		else
			. += " It seems to be unpacked."

/obj/item/storage/backpack/parachute/handleParachute()
	parachute = FALSE	//If you parachute in, the parachute has probably been used.

/obj/item/storage/backpack/parachute/verb/pack_parachute()

	set name = "Pack/Unpack Parachute"
	set category = "Object"
	set src in usr

	if(!istype(src.loc, /mob/living))
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.back == src)
		to_chat(H, "<span class='warning'>How do you expect to work on \the [src] while it's on your back?</span>")
		return

	if(!parachute)	//This packs the parachute
		H.visible_message("<span class='notice'>\The [H] starts to pack \the [src]!</span>", \
					"<span class='notice'>You start to pack \the [src]!</span>", \
					"You hear the shuffling of cloth.")
		if(do_after(H, 50))
			H.visible_message("<span class='notice'>\The [H] finishes packing \the [src]!</span>", \
					"<span class='notice'>You finish packing \the [src]!</span>", \
					"You hear the shuffling of cloth.")
			parachute = TRUE
		else
			H.visible_message("<span class='notice'>\The [src] gives up on packing \the [src]!</span>", \
					"<span class='notice'>You give up on packing \the [src]!</span>")
			return
	else			//This unpacks the parachute
		H.visible_message("<span class='notice'>\The [src] starts to unpack \the [src]!</span>", \
					"<span class='notice'>You start to unpack \the [src]!</span>", \
					"You hear the shuffling of cloth.")
		if(do_after(H, 25))
			H.visible_message("<span class='notice'>\The [src] finishes unpacking \the [src]!</span>", \
					"<span class='notice'>You finish unpacking \the [src]!</span>", \
					"You hear the shuffling of cloth.")
			parachute = FALSE
		else
			H.visible_message("<span class='notice'>\The [src] decides not to unpack \the [src]!</span>", \
					"<span class='notice'>You decide not to unpack \the [src]!</span>")
	return

/obj/item/storage/backpack/satchel/ranger
	name = "ranger satchel"
	desc = "A satchel designed for the Go Go ERT Rangers series to allow for slightly bigger carry capacity for the ERT-Rangers.\
	 Unlike the show claims, it is not a phoron-enhanced satchel of holding with plot-relevant content."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_satchel"

/obj/item/storage/backpack/ert/para
	name = "PARA trophy rack"
	desc = "A special trophy rack bearing the device of an all-seeing eye; the symbol of the PMD."
	icon_state = "para_ert_pack"

/obj/item/storage/backpack/saddlebag
	name = "Horse Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	var/taurtype = /datum/sprite_accessory/tail/taur/horse //Acceptable taur type to be wearing this
	var/no_message = "You aren't the appropriate taur type to wear this!"

/obj/item/storage/backpack/saddlebag/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H
	if(istype(H) && istype(H.tail_style, taurtype))
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	else
		to_chat(H, "<span class='warning'>[no_message]</span>")
		return 0

/* If anyone wants to make some... this is how you would.
/obj/item/storage/backpack/saddlebag/spider
	name = "Drider Saddlebags"
	item_state = "saddlebag_drider"
	icon_state = "saddlebag_drider"
	var/taurtype = /datum/sprite_accessory/tail/taur/spider
*/

/obj/item/storage/backpack/saddlebag_common //Shared bag for other taurs with sturdy backs
	name = "Taur Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back_taur.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	var/icon_base = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	var/no_message = "You aren't the appropriate taur type to wear this!"

/obj/item/storage/backpack/saddlebag_common/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H
	var/datum/sprite_accessory/tail/taur/TT = H.tail_style
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/horse))
		item_state = "[icon_base]_Horse"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/wolf))
		item_state = "[icon_base]_Wolf"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/cow))
		item_state = "[icon_base]_Cow"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/lizard))
		item_state = "[icon_base]_Lizard"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/feline))
		item_state = "[icon_base]_Feline"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/drake))
		item_state = "[icon_base]_Drake"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/otie))
		item_state = "[icon_base]_Otie"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/deer))
		item_state = "[icon_base]_Deer"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	else
		to_chat(H, "<span class='warning'>[no_message]</span>")
		return 0

/obj/item/storage/backpack/saddlebag_common/robust //Shared bag for other taurs with sturdy backs
	name = "Robust Saddlebags"
	desc = "A saddle that holds items. Seems robust."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back_taur.dmi'
	item_state = "robustsaddle"
	icon_state = "robustsaddle"
	icon_base = "robustsaddle"

/obj/item/storage/backpack/saddlebag_common/vest //Shared bag for other taurs with sturdy backs
	name = "Taur Duty Vest"
	desc = "An armored vest with the armor modules replaced with various handy compartments with decent storage capacity. Useless for protection though."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back_taur.dmi'
	item_state = "taurvest"
	icon_state = "taurvest"
	icon_base = "taurvest"
	max_storage_space = INVENTORY_STANDARD_SPACE
	slowdown = 0

/obj/item/storage/backpack/dufflebag/fluff //Black dufflebag without syndie buffs.
	name = "plain black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon_state = "duffle-syndie"

/obj/item/storage/backpack/rebel
	name = "rebel backpack"
	desc = "A sturdy canvas bag designed to withstand harsh environmental conditions."
	icon_state = "backpack_rebel"
