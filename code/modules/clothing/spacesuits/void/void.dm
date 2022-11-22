//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate", SLOT_ID_LEFT_HAND = "syndicate")
	heat_protection = HEAD
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE

//	flags_inv = HIDEEARS|BLOCKHAIR

	//Species-specific stuff.
	species_restricted = list(SPECIES_HUMAN, SPECIES_PROMETHEAN, SPECIES_ALRAUNE)
	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/clothing/species/unathi/helmet.dmi',
		SPECIES_UNATHI_DIGI = 'icons/mob/clothing/species/unathidigi/head.dmi',
		SPECIES_TAJ = 'icons/mob/clothing/species/tajaran/helmet.dmi',
		SPECIES_SKRELL = 'icons/mob/clothing/species/skrell/helmet.dmi'
		//Teshari have a general sprite sheet defined in modules/clothing/clothing.dm
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/hats.dmi',
		SPECIES_UNATHI_DIGI = 'icons/obj/clothing/species/unathi/hats.dmi',
		SPECIES_TAJ = 'icons/obj/clothing/species/tajaran/hats.dmi',
		SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/hats.dmi',
		SPECIES_TESHARI = 'icons/obj/clothing/species/teshari/hats.dmi',
		SPECIES_VOX = 'icons/obj/clothing/species/vox/hats.dmi'
		)

	light_overlay = "helmet_light"

/obj/item/clothing/suit/space/void
	name = "voidsuit"
	icon_state = "void"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "space_suit_syndicate", SLOT_ID_LEFT_HAND = "space_suit_syndicate")
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	slowdown = 1
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE

	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_PROMETHEAN)
	sprite_sheets_refit = list(
		SPECIES_UNATHI = 'icons/mob/clothing/species/unathi/suits.dmi',
		SPECIES_UNATHI_DIGI = 'icons/mob/clothing/species/unathidigi/suits.dmi',
		SPECIES_TAJ = 'icons/mob/clothing/species/tajaran/suits.dmi',
		SPECIES_SKRELL = 'icons/mob/clothing/species/skrell/suits.dmi'
		//Teshari have a general sprite sheet defined in modules/clothing/clothing.dm
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ				= 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/species/skrell/suits.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_UNATHI_DIGI     = 'icons/obj/clothing/species/unathi/suits.dmi',
		SPECIES_TESHARI			= 'icons/obj/clothing/species/teshari/suits.dmi',
		SPECIES_NEVREAN			= 'icons/obj/clothing/species/nevrean/suits.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/species/akula/suits.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/species/sergal/suits.dmi',
		SPECIES_ZORREN_FLAT		= 'icons/obj/clothing/species/fennec/suits.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/species/fox/suits.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/species/vulpkanin/suits.dmi',
		SPECIES_PROMETHEAN		= 'icons/obj/clothing/species/skrell/suits.dmi'
		)

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 12
	can_breach = 1

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.
	var/obj/item/tank/tank = null              // Deployable tank, if any.
	var/obj/item/suit_cooling_unit/cooler = null// Cooling unit, for FBPs.  Cannot be installed alongside a tank.

	action_button_name = "Toggle Helmet"

/obj/item/clothing/suit/space/void/examine(mob/user)
	. = ..()
	var/list/part_list = new
	for(var/obj/item/I in list(helmet,boots,tank,cooler))
		part_list += "\a [I]"
	. += "\The [src] has [english_list(part_list)] installed."
	if(tank && in_range(src,user))
		. += "<span class='notice'>The wrist-mounted pressure gauge reads [max(round(tank.air_contents.return_pressure()),0)] kPa remaining in \the [tank].</span>"

/obj/item/clothing/suit/space/void/refit_for_species(var/target_species)
	..()
	if(istype(helmet))
		helmet.refit_for_species(target_species)
	if(istype(boots))
		boots.refit_for_species(target_species)

/obj/item/clothing/suit/space/void/equipped(mob/M)
	..()

	var/mob/living/carbon/human/H = M

	if(!istype(H)) return

	if(H.wear_suit != src)
		return

	if(boots)
		if (H.equip_to_slot_if_possible(boots, SLOT_ID_SHOES))
			to_chat(M, "Your suit's magboots deploy with a click.")
			ADD_TRAIT(boots, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)

	if(helmet)
		if(H.head)
			to_chat(M, "You are unable to deploy your suit's helmet as \the [H.head] is in the way.")
		else if (H.equip_to_slot_if_possible(helmet, SLOT_ID_HEAD))
			to_chat(M, "Your suit's helmet deploys with a hiss.")
			ADD_TRAIT(helmet, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)

	if(tank)
		if(H.s_store) //In case someone finds a way.
			to_chat(M, "Alarmingly, the valve on your suit's installed tank fails to engage.")
		else if (H.equip_to_slot_if_possible(tank, SLOT_ID_SUIT_STORAGE))
			to_chat(M, "The valve on your suit's installed tank safely engages.")
			ADD_TRAIT(tank, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)

	if(cooler)
		if(H.s_store) //Ditto
			to_chat(M, "Alarmingly, the cooling unit installed into your suit fails to deploy.")
		else if (H.equip_to_slot_if_possible(cooler, SLOT_ID_SUIT_STORAGE))
			to_chat(M, "Your suit's cooling unit deploys.")
			ADD_TRAIT(cooler, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)

/obj/item/clothing/suit/space/void/unequipped(mob/user, slot, flags)
	. = ..()

	if(helmet)
		REMOVE_TRAIT(helmet, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
		if(helmet.loc != src)
			helmet.forceMove(src)

	if(boots)
		REMOVE_TRAIT(boots, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
		if(boots.loc != src)
			boots.forceMove(src)

	if(tank)
		REMOVE_TRAIT(tank, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
		if(tank.loc != src)
			tank.forceMove(src)

	if(cooler)
		REMOVE_TRAIT(cooler, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
		if(cooler.loc != src)
			cooler.forceMove(src)

/obj/item/clothing/suit/space/void/verb/toggle_helmet()

	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.wear_suit != src)
		return

	if(H.head == helmet)
		to_chat(H, "<span class='notice'>You retract your suit helmet.</span>")
		playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)
		helmet.forceMove(src)
		REMOVE_TRAIT(helmet, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
	else
		if(H.head)
			to_chat(H, "<span class='danger'>You cannot deploy your helmet while wearing \the [H.head].</span>")
			return
		if(H.equip_to_slot_if_possible(helmet, SLOT_ID_HEAD))
			ADD_TRAIT(helmet, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
			to_chat(H, "<span class='info'>You deploy your suit helmet, sealing you off from the world.</span>")
			playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)
	helmet.update_light(H)

/obj/item/clothing/suit/space/void/verb/toggle_magboots()
	set name = "Toggle Magboots"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living))
		return

	if(!boots)
		to_chat(usr, "There are no magboots installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.wear_suit != src)
		return

	if(H.shoes == boots)
		to_chat(H, "<span class='notice'>You retract your magboots.</span>")
		REMOVE_TRAIT(boots, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
		boots.forceMove(src)
	else
		if(H.equip_to_slot_if_possible(boots, SLOT_ID_SHOES))
			ADD_TRAIT(boots, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
			to_chat(H, "<span class='info'>You deploy your magboots.</span>")

// below is code for the action button method. im dumb. but it works? if you figure out a way to make it better tell me // hey peesh i made it better -hatter
/obj/item/clothing/suit/space/void/attack_self(mob/user)
	toggle_helmet()

/obj/item/clothing/suit/space/void/verb/eject_tank()

	set name = "Eject Voidsuit Tank/Cooler"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living))
		return

	if(!tank && !cooler)
		to_chat(usr, "There is no tank or cooling unit inserted.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.wear_suit != src)
		return

	var/obj/item/removing = null
	if(tank)
		removing = tank
		tank = null
	else
		removing = cooler
		cooler = null
	to_chat(H, "<span class='info'>You press the emergency release, ejecting \the [removing] from your suit.</span>")
	REMOVE_TRAIT(removing, TRAIT_NODROP, TOGGLE_CLOTHING_TRAIT)
	removing.forceMove(drop_location())

/obj/item/clothing/suit/space/void/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return

	if(istype(W,/obj/item/clothing/accessory) || istype(W, /obj/item/hand_labeler))
		return ..()

	if(is_being_worn())
		to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		return

	if(W.is_screwdriver())
		if(helmet || boots || tank)
			var/choice = input("What component would you like to remove?") as null|anything in list(helmet,boots,tank,cooler)
			if(!choice) return

			if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
				to_chat(user, "You pop \the [tank] out of \the [src]'s storage compartment.")
				tank.forceMove(get_turf(src))
				tank.clothing_flags &= ~EQUIP_IGNORE_DELIMB
				playsound(src, W.tool_sound, 50, 1)
				src.tank = null
			else if(choice == cooler)
				to_chat(user, "You pop \the [cooler] out of \the [src]'s storage compartment.")
				cooler.forceMove(get_turf(src))
				cooler.clothing_flags &= ~EQUIP_IGNORE_DELIMB
				playsound(src, W.tool_sound, 50, 1)
				src.cooler = null
			else if(choice == helmet)
				to_chat(user, "You detach \the [helmet] from \the [src]'s helmet mount.")
				helmet.forceMove(get_turf(src))
				helmet.clothing_flags &= ~EQUIP_IGNORE_DELIMB
				playsound(src, W.tool_sound, 50, 1)
				src.helmet = null
			else if(choice == boots)
				to_chat(user, "You detach \the [boots] from \the [src]'s boot mounts.")
				boots.forceMove(get_turf(src))
				boots.clothing_flags &= ~EQUIP_IGNORE_DELIMB
				playsound(src, W.tool_sound, 50, 1)
				src.boots = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return
	else if(istype(W,/obj/item/clothing/head/helmet/space))
		if(helmet)
			to_chat(user, "\The [src] already has a helmet installed.")
		else if(user.attempt_insert_item_for_installation(W, src))
			to_chat(user, "You attach \the [W] to \the [src]'s helmet mount.")
			helmet = W
			helmet.clothing_flags |= EQUIP_IGNORE_DELIMB
		return
	else if(istype(W,/obj/item/clothing/shoes/magboots))
		if(boots)
			to_chat(user, "\The [src] already has magboots installed.")
		else if(user.attempt_insert_item_for_installation(W, src))
			to_chat(user, "You attach \the [W] to \the [src]'s boot mounts.")
			boots = W
			boots.clothing_flags |= EQUIP_IGNORE_DELIMB
		return
	else if(istype(W,/obj/item/tank))
		if(tank)
			to_chat(user, "\The [src] already has an airtank installed.")
		else if(cooler)
			to_chat(user, "\The [src]'s suit cooling unit is in the way.  Remove it first.")
		else if(istype(W,/obj/item/tank/phoron))
			to_chat(user, "\The [W] cannot be inserted into \the [src]'s storage compartment.")
		else if(user.attempt_insert_item_for_installation(W, src))
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			tank = W
			tank.clothing_flags |= EQUIP_IGNORE_DELIMB
		return
	else if(istype(W,/obj/item/suit_cooling_unit))
		if(cooler)
			to_chat(user, "\The [src] already has a suit cooling unit installed.")
		else if(tank)
			to_chat(user, "\The [src]'s airtank is in the way.  Remove it first.")
		else if(user.attempt_insert_item_for_installation(W, src))
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			cooler = W
			cooler.clothing_flags |= EQUIP_IGNORE_DELIMB
		return

	..()
