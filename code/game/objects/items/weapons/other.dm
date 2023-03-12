//TODO: Organize this file into more appropriate files. -Zandario

/obj/item/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	force = 3.0
	throw_force = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_SMALL
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/rsp
	name = "\improper Rapid-Seed-Producer (RSP)"
	desc = "A device used to rapidly deploy seeds."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 0
	var/mode = 1
	w_class = ITEMSIZE_NORMAL

/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	atom_flags = NOCONDUCT
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HOLSTER
	throw_force = 0
	throw_speed = 4
	throw_range = 20

/obj/item/soap/nanotrasen
	desc = "A NanoTrasen-brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

/obj/item/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/soap/deluxe/Initialize(mapload)
	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/soap/primitive
	desc = "Lye and fat processed into a solid state. This hand crafted bar is unscented and uneven."
	icon_state = "soapprim"

/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throw_force = 3
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HOLSTER
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/spam_flag = 0

/obj/item/bikehorn/golden
	name = "golden bike horn"
	desc = "Golden? Clearly, it's made with bananium! Honk!"
	icon_state = "gold_horn"
	item_state = "gold_horn"
	var/flip_cooldown = 0

/*
/obj/item/bikehorn/golden/attack()
	if(flip_cooldown < world.time)
		flip_mobs()
	return ..()

/obj/item/bikehorn/golden/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(flip_cooldown < world.time)
		flip_mobs()
	..()

/obj/item/bikehorn/golden/proc/flip_mobs(mob/living/carbon/M, mob/user)
	var/turf/T = get_turf(src)
	for(M in ohearers(7, T))
		if(ishuman(M) && M.can_hear())
			var/mob/living/carbon/human/H = M
			if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
				continue
		M.emote("flip")
	flip_cooldown = world.time + 7
*/

/obj/item/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throw_force = 1
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HOLSTER
	throw_speed = 4
	throw_range = 5

/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentleman."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)
	force = 5.0
	throw_force = 7.0
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_STEEL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/cane/concealed
	var/concealed_blade

/obj/item/cane/concealed/Initialize(mapload)
	. = ..()
	var/obj/item/material/butterfly/switchblade/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.attack_self()

/obj/item/cane/concealed/attack_self(mob/user)
	. = ..()
	if(.)
		return
	var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
	if(concealed_blade)
		user.visible_message(
			SPAN_WARNING("[user] has unsheathed \a [concealed_blade] from [T.his] [src]!"),
			SPAN_WARNING("You unsheathe \the [concealed_blade] from \the [src]."),
			SPAN_HEAR("You hear a blade being drawn."),
		)
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
		user.drop_item_to_ground(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		concealed_blade = null

/obj/item/cane/concealed/attackby(obj/item/material/butterfly/W, mob/user)
	if(!src.concealed_blade && istype(W))
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
		user.visible_message(
			SPAN_WARNING("[user] has sheathed \a [W] into [T.his] [src]!"),
			SPAN_WARNING("You sheathe \the [W] into \the [src]."),
			SPAN_HEAR("You hear a blade being sheathed."),
		)
		update_icon()
	else
		..()

/obj/item/cane/concealed/update_icon()
	if(concealed_blade)
		name = initial(name)
		icon_state = initial(icon_state)
		item_state = initial(icon_state)
	else
		name = "cane shaft"
		icon_state = "nullrod"
		item_state = "foldcane"

/obj/item/cane/whitecane
	name = "white cane"
	desc = "A white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "whitecane"

/obj/item/cane/whitecane/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HELP)
		user.visible_message(SPAN_NOTICE("\The [user] has lightly tapped [target] on the ankle with their white cane!"))
		return
	return ..()

//Code for Telescopic White Cane writen by Gozulio

/obj/item/cane/whitecane/collapsible
	name = "telescopic white cane"
	desc = "A telescopic white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane1in"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
		)
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 3
	var/on = 0

/obj/item/cane/whitecane/collapsible/attack_self(mob/user)
	. = ..()
	if(.)
		return
	on = !on
	if(on)
		user.visible_message(
			SPAN_NOTICE("\The [user] extends the white cane."),
			SPAN_WARNING("You extend the white cane."),
			SPAN_HEAR("You hear an ominous click."),
		)
		icon_state = "whitecane1out"
		item_state_slots = list(SLOT_ID_RIGHT_HAND = "whitecane", SLOT_ID_LEFT_HAND = "whitecane")
		w_class = ITEMSIZE_NORMAL
		force = 5
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] collapses the white cane."),
			SPAN_WARNING("You collapse the white cane."),
			SPAN_HEAR("You hear a click."),
		)
		icon_state = "whitecane1in"
		item_state_slots = list(SLOT_ID_RIGHT_HAND = null, SLOT_ID_LEFT_HAND = null)
		w_class = ITEMSIZE_SMALL
		force = 3
		attack_verb = list("hit", "poked", "prodded")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	return TRUE

/obj/item/cane/crutch
	name ="crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon_state = "crutch"
	item_state = "crutch"

/obj/item/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'
	drop_sound = 'sound/items/drop/disk.ogg'
	pickup_sound =  'sound/items/pickup/disk.ogg'

/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL

/*
/obj/item/game_kit
	name = "Gaming Kit"
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = ITEMSIZE_HUGE
*/

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = ITEMSIZE_LARGE

/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throw_force = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/caution/attackby(obj/item/D, mob/user)
	if(D.is_wirecutter())
		to_chat(user, SPAN_NOTICE("You snap the handle of \the [src] with \the [D].  It's too warped to stand on its own now."))
		user.put_in_hands(new /obj/item/clothing/suit/armor/caution)
		qdel(src)
	else
		return ..()

/obj/item/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"

/obj/item/caution/cone/candy
	desc = "This cone is trying to warn you of something! It has been painted to look like candy corn."
	name = "candy cone"
	icon_state = "candycone"

/*/obj/item/syndicate_uplink
	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/radio/origradio = null
	flags = ONBELT
	w_class = ITEMSIZE_SMALL
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	matter = list("metal" = 100
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 3)*/

/obj/item/SWF_uplink
	name = "station-bounced radio"
	desc = "Used to communicate, it appears."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/radio/origradio = null
	slot_flags = SLOT_BELT
	item_state = "radio"
	throw_force = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 20
	matter = list(MAT_STEEL = 100)
	origin_tech = list(TECH_MAGNET = 1)

/obj/item/staff
	name = "wizards staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
	)
	force = 3.0
	throw_force = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	attack_verb = list("bludgeoned", "whacked", "disciplined")

/obj/item/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

/obj/item/staff/gentcane
	name = "Gentlemans Cane"
	desc = "An ebony can with an ivory tip."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"

/obj/item/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stick"
	item_state = "cane"
	force = 3.0
	throw_force = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL

/obj/item/module
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	item_state = "std_mod"
	w_class = ITEMSIZE_SMALL
	var/mtype = 1 // 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	item_state = "std_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	item_state = "std_mod"
	desc = "Heavy-duty switching circuits for power control."
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/module/power_control/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/multitool))
		var/obj/item/circuitboard/ghettosmes/newcircuit = new/obj/item/circuitboard/ghettosmes(user.loc)
		qdel(src)
		user.put_in_hands(newcircuit)


/obj/item/module/id_auth
	name = "\improper ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

/obj/item/module/cell_power
	name = "power cell regulator module"
	icon_state = "power_mod"
	item_state = "std_mod"
	desc = "A converter and regulator allowing the use of power cells."

/obj/item/module/cell_power
	name = "power cell charger module"
	icon_state = "power_mod"
	item_state = "std_mod"
	desc = "Charging circuits for power cells."

/*
/obj/item/cigarpacket
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = ITEMSIZE_TINY
	throw_force = 2
	var/cigarcount = 6
	flags = ONBELT
	*/

/obj/item/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine

/obj/item/pai_cable/Destroy()
		machine = null
		return ..()

///////////////////////////////////////Stock Parts /////////////////////////////////

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "Spooky!"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/research
	name = "research debugging device"
	desc = "Instant research tool. For testing purposes only."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = list(TECH_MATERIAL = 19, TECH_ENGINEERING = 19, TECH_PHORON = 19, TECH_POWER = 19, TECH_BLUESPACE = 19, TECH_BIO = 19, TECH_COMBAT = 19, TECH_MAGNET = 19, TECH_DATA = 19, TECH_ILLEGAL = 19, TECH_ARCANE = 19, TECH_PRECURSOR = 19)

//Yay Saddles.
/obj/item/saddle
	name = "saddle"
	desc = "A portable seat designed to be mounted on trained animals. You shouldn't be seeing this version!"
	icon = 'icons/obj/items.dmi'
	icon_state = "saddle"
	w_class = ITEMSIZE_LARGE

/obj/item/saddle/horse
	desc = "A portable seat designed to be mounted on trained animals. This leather design originates from Old Earth, where it was primarily used on horses."

/obj/item/saddle/shank
	name = "goliath hide saddle"
	desc = "A portable seat designed to be mounted on trained animals. This one is fashioned out of goliath hide and bone, and seems to be designed for a very angular beast."
	icon_state = "saddle_lavaland"

//Ashlander Specific Crafting Item - I'll eventually just make an item .dm for these guys at this rate.
//This item will replace soulstones in Lavaland recipes/features.
/datum/category_item/catalogue/anomalous/scorian_religion/elder_stone
	name = "Scorian Religion - Elder Stones"
	desc = "Originally depicted in Scorian carvings and cave paintings discovered at various dig sites around Surt, \
	actual samples of these curious gems only recently became available. These gems, whose name most closely translates \
	to 'Elder Stone' in Galactic Common, are considered items of intense religious significance to Scorian tribes. \
	Outlanders who have been seen in possession of elder stones are frequently treated with hostility by the Scorian people, \
	leading to several diplomatic incidents in recent months. Elder stones possess subtle anomalous properties, most notably \
	a musical chiming tone, similar to the constant ringing of a bell. They are considered especially valuable by anomalous \
	study groups and anthropological initiatives alike."
	value = CATALOGUER_REWARD_MEDIUM

/obj/item/elderstone
	name = "elder stone"
	desc = "This strange gem is considered sacred by the inhabitants of Surt. Jealously protected by the tribes, these stones exhibit anomalous properties - primarily a faintly audible chiming ring."
	icon = 'icons/obj/items.dmi'
	icon_state = "elderstone"
	w_class = ITEMSIZE_SMALL
	catalogue_data = list(/datum/category_item/catalogue/anomalous/scorian_religion/elder_stone)
