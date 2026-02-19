// todo: completely rework this stupid shit, why are mech paint kits in here?
/obj/item/kit
	icon_state = "modkit"
	icon = 'icons/obj/device.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/new_name = "custom item"
	var/new_desc = "A custom item."
	var/new_fluff = "A custom item."
	var/new_icon
	var/new_icon_file
	var/new_icon_override_file
	var/uses = 1        // Uses before the kit deletes itself.
	var/list/allowed_types = list()

/obj/item/kit/examine()
	. = ..()
	. += "It has [uses] use\s left."

/obj/item/kit/proc/use(var/amt, var/mob/user)
	uses -= amt
	playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
	if(uses < 1)
		qdel(src)

/obj/item/kit/proc/can_customize(var/obj/item/I)
	return is_type_in_list(I, allowed_types)

/obj/item/kit/proc/set_info(var/kit_name, var/kit_desc, var/kit_fluff, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	new_name = kit_name
	new_desc = kit_desc
	new_fluff = kit_fluff
	new_icon = kit_icon
	new_icon_file = kit_icon_file
	new_icon_override_file = kit_icon_override_file

	for(var/path in splittext(additional_data, ", "))
		allowed_types |= text2path(path)

/obj/item/kit/proc/customize(var/obj/item/I, var/mob/user)
	if(can_customize(I))
		I.name = new_name ? new_name : I.name
		I.desc = new_desc ? new_desc : I.desc
		I.description_fluff = new_fluff ? new_fluff : I.description_fluff
		I.icon = new_icon_file ? new_icon_file : I.icon
		I.icon_override = new_icon_override_file ? new_icon_override_file : I.icon_override
		if(new_icon)
			I.icon_state = new_icon
		var/obj/item/clothing/under/U = I
		if(istype(U))
			U.snowflake_worn_state = I.icon_state
			U.update_rolldown()
		use(1, user)

// Generic use
/obj/item/attackby(obj/item/tool, mob/user, list/params, clickchain_flags, damage_multiplier, datum/event_args/actor/clickchain/clickchain)
	if(istype(tool, /obj/item/kit))
		var/obj/item/kit/K = tool
		K.customize(src, user)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

// Root hardsuit kit defines.
// Icons for modified hardsuits need to be in the proper .dmis because suit cyclers may cock them up.
/obj/item/kit/suit
	name = "voidsuit modification kit"
	desc = "A kit for modifying a voidsuit."
	uses = 2
	var/new_light_overlay

/obj/item/kit/suit/can_customize(var/obj/item/I)
	return istype(I, /obj/item/clothing/head/helmet/space/void) || istype(I, /obj/item/clothing/suit/space/void) || istype(I, /obj/item/clothing/suit/storage/hooded)

/obj/item/kit/suit/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	..()

	new_light_overlay = additional_data


/obj/item/kit/suit/customize(var/obj/item/I, var/mob/user)
	if(can_customize(I))
		if(istype(I, /obj/item/clothing/head/helmet/space/void))
			var/obj/item/clothing/head/helmet/space/void/helmet = I
			helmet.name = "[new_name] suit helmet"
			helmet.desc = new_desc
			helmet.description_fluff = new_fluff
			helmet.icon_state = "[new_icon]_helmet"
			helmet.item_state = "[new_icon]_helmet"
			if(new_icon_file)
				helmet.icon = new_icon_file
			if(new_icon_override_file)
				helmet.icon_override = new_icon_override_file
			if(new_light_overlay)
				helmet.light_overlay = new_light_overlay
			to_chat(user, "You set about modifying the helmet into [helmet].")
			var/mob/living/carbon/human/H = user
			if(istype(H))
				helmet.species_restricted = list(H.species.get_bodytype_legacy(H))
		else if(istype(I, /obj/item/clothing/suit/storage/hooded))
			var/obj/item/clothing/suit/storage/hooded/suit = I
			suit.name = "[new_name] suit"
			suit.desc = new_desc
			suit.description_fluff = new_fluff
			suit.icon_state = "[new_icon]_suit"
			suit.toggleicon = "[new_icon]_suit"
			suit.item_state = "[new_icon]_suit"
			var/obj/item/clothing/head/hood/S = suit.hood
			S.icon_state = "[new_icon]_helmet"
			S.item_state = "[new_icon]_helmet"
			if(new_icon_file)
				suit.icon = new_icon_file
				S.icon = new_icon_file
			if(new_icon_override_file)
				suit.icon_override = new_icon_override_file
				S.icon_override = new_icon_override_file
			to_chat(user, "You set about modifying the suit into [suit].")
//			var/mob/living/carbon/human/H = user
//			if(istype(H))
//				suit.species_restricted = list(H.species.get_bodytype_legacy(H)) Does not quite make sense for something usually very pliable.
		else
			var/obj/item/clothing/suit/space/void/suit = I
			suit.name = "[new_name] voidsuit"
			suit.desc = new_desc
			suit.description_fluff = new_fluff
			suit.icon_state = "[new_icon]_suit"
			suit.item_state = "[new_icon]_suit"
			if(new_icon_file)
				suit.icon = new_icon_file
			if(new_icon_override_file)
				suit.icon_override = new_icon_override_file
			to_chat(user, "You set about modifying the suit into [suit].")
			var/mob/living/carbon/human/H = user
			if(istype(H))
				suit.species_restricted = list(H.species.get_bodytype_legacy(H))
		use(1,user)

/obj/item/clothing/head/helmet/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/kit/suit))
		var/obj/item/kit/suit/kit = O
		kit.customize(src, user)
		return
	return ..()

/obj/item/clothing/suit/space/void/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/kit/suit))
		var/obj/item/kit/suit/kit = O
		kit.customize(src, user)
		return
	return ..()

/obj/item/clothing/suit/storage/hooded/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/kit/suit))
		var/obj/item/kit/suit/kit = O
		kit.customize(src, user)
		return
	return ..()

/obj/item/kit/suit/hardsuit
	name = "hardsuit modification kit"
	desc = "A kit for modifying a rigsuit."
	uses = 1

/obj/item/kit/suit/hardsuit/customize(var/obj/item/I, var/mob/user)
	var/obj/item/hardsuit/HARDSUIT = I
	HARDSUIT.suit_state = new_icon
	HARDSUIT.item_state = new_icon
	HARDSUIT.suit_type = "customized [initial(HARDSUIT.suit_type)]"
	HARDSUIT.name = "[new_name]"
	HARDSUIT.desc = new_desc
	HARDSUIT.description_fluff = new_fluff
	HARDSUIT.icon = new_icon_file
	HARDSUIT.icon_state = new_icon
	HARDSUIT.icon_override = new_icon_override_file
	for(var/obj/item/piece in list(HARDSUIT.gloves,HARDSUIT.helmet,HARDSUIT.boots,HARDSUIT.chest))
		if(!istype(piece))
			continue
		piece.name = "[HARDSUIT.suit_type] [initial(piece.name)]"
		piece.desc = "It seems to be part of a [HARDSUIT.name]."
		piece.icon_state = "[HARDSUIT.suit_state]"
		if(istype(piece, /obj/item/clothing/shoes))
			piece.icon = 'icons/mob/clothing/custom_items_rig_boots.dmi'
			piece.icon_override = 'icons/mob/clothing/custom_items_rig_boots.dmi'
		if(istype(piece, /obj/item/clothing/suit))
			piece.icon = 'icons/mob/clothing/custom_items_rig_suits.dmi'
			piece.icon_override = 'icons/mob/clothing/custom_items_rig_suits.dmi'
		if(istype(piece, /obj/item/clothing/head))
			piece.icon = 'icons/mob/clothing/custom_items_rig_helmet.dmi'
			piece.icon_override = 'icons/mob/clothing/custom_items_rig_helmet.dmi'
		if(istype(piece, /obj/item/clothing/gloves))
			piece.icon = 'icons/mob/clothing/custom_items_rig_gloves.dmi'
			piece.icon_override = 'icons/mob/clothing/custom_items_rig_gloves.dmi'
	if(HARDSUIT.helmet && istype(HARDSUIT.helmet, /obj/item/clothing/head/helmet) && new_light_overlay)
		var/obj/item/clothing/head/helmet/H = HARDSUIT.helmet
		H.light_overlay = new_light_overlay
	use(1,user)

/obj/item/kit/suit/hardsuit/can_customize(var/obj/item/I)
	return istype(I, /obj/item/hardsuit)

/obj/item/hardsuit/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/kit/suit))
		var/obj/item/kit/suit/hardsuit/kit = O
		kit.customize(src, user)
		return
	return ..()

/obj/item/kit/suit/hardsuit/debug/Initialize(mapload)
	. = ..()
	set_info("debug suit", "This is a test", "debug", CUSTOM_ITEM_OBJ, CUSTOM_ITEM_MOB)

/obj/item/kit/paint
	name = "mecha customisation kit"
	desc = "A kit containing all the needed tools and parts to repaint a mech."
	var/removable = null

/obj/item/kit/paint/can_customize(var/obj/vehicle/sealed/mecha/M)
	if(!istype(M))
		return 0

	for(var/type in allowed_types)
		if(type == M.initial_icon)
			return 1

/obj/item/kit/paint/set_info(var/kit_name, var/kit_desc, var/kit_icon, var/kit_icon_file = CUSTOM_ITEM_OBJ, var/kit_icon_override_file = CUSTOM_ITEM_MOB, var/additional_data)
	..()

	allowed_types = splittext(additional_data, ", ")


/obj/item/kit/paint/examine()
	. = ..()
	. += "This kit will convert an exosuit into: [new_name]."
	. += "This kit can be used on the following exosuit models:"
	for(var/exotype in allowed_types)
		. += "- [capitalize(exotype)]"

/obj/item/kit/paint/customize(var/obj/vehicle/sealed/mecha/M, var/mob/user)
	if(!can_customize(M))
		to_chat(user, "That kit isn't meant for use on this class of exosuit.")
		return

	if(M.occupant_legacy)
		to_chat(user, "You can't customize a mech while someone is piloting it - that would be unsafe!")
		return

	user.visible_message("[user] opens [src] and spends some quality time customising [M].")
	M.name = new_name
	M.desc = new_desc
	M.description_fluff = new_fluff
	M.initial_icon = new_icon
	if(new_icon_file)
		M.icon = new_icon_file
	M.update_icon()
	use(1, user)

//Ripley APLU kits.
/obj/item/kit/paint/ripley
	name = "\"Classic\" APLU customisation kit"
	new_name = "APLU \"Classic\""
	new_desc = "An antique APLU that visibly bears the weight of time."
	new_fluff = "A very retro APLU unit; didn't they retire these back in 2453?"
	new_icon = "ripley-old"
	allowed_types = list("ripley")

/obj/item/kit/paint/ripley/death
	name = "\"Reaper\" APLU customisation kit"
	new_name = "APLU \"Reaper\""
	new_desc = "This APLU bears a sinister black and red paint job."
	new_fluff = "A grim power loader with a threatening profile. Why do those clamps have spikes?"
	new_icon = "deathripley"
	allowed_types = list("ripley","firefighter")

/obj/item/kit/paint/ripley/flames_red
	name = "\"Firestarter\" APLU customisation kit"
	new_name = "APLU \"Firestarter\""
	new_desc = "An APLU with a red flame paint job."
	new_fluff = "A standard APLU exosuit with stylish orange flame decals."
	new_icon = "ripley_flames_red"

/obj/item/kit/paint/ripley/flames_blue
	name = "\"Burning Chrome\" APLU customisation kit"
	new_name = "APLU \"Burning Chrome\""
	new_desc = "An APLU with a blue flame paint job."
	new_fluff = "A standard APLU exosuit with stylish blue flame decals."
	new_icon = "ripley_flames_blue"

/obj/item/kit/paint/ripley/pirate
	name = "\"Brigand\" APLU customisation kit"
	new_name = "APLU \"Brigand\""
	new_desc = "A vandalized APLU bearing the Jolly Roger."
	new_fluff = "An up-armored power loader design often favored by pirates. Its bulky frame and implacability help it function as mobile cover during boarding actions."
	new_icon = "pirate"

/obj/item/kit/paint/ripley/junker
	name = "\"Scrapper\" APLU customisation kit"
	new_name = "APLU \"Scrapper\""
	new_desc = "An APLU that shows signs of multiple refits and improvised maintenance procedures."
	new_fluff = "Even the simple power loader is considered a luxury on the Frontier. Some colonies have maintained one single model for decades."
	new_icon = "ripley_junker"

/obj/item/kit/paint/ripley/battered
	name = "\"Battle Damaged\" APLU customisation kit"
	new_name = "APLU \"Battle Damaged\""
	new_desc = "This APLU is intensely damaged. It's amazing that it can still move."
	new_fluff = "Overconfident Roboticists and pilots will often rush into combat with a power loader. It is a testament to the design that some can still operate in this condition."
	new_icon = "ripley_battered"

/obj/item/kit/paint/ripley/medical
	name = "\"Caduceus\" APLU customisation kit"
	new_name = "APLU \"Caduceus\""
	new_desc = "An APLU whose medical themed paint job designates it as a triage unit."
	new_fluff = "Power loaders are slow and bulky, making them poor fits for medical work. Sometimes, however, they may be all that's available."
	new_icon = "ripley_med"

/obj/item/kit/paint/ripley/sovjet
	name = "\"Old Red\" APLU customisation kit"
	new_name = "APLU \"Old Red\""
	new_desc = "An aged APLU painted in the heraldry of an Old Earth nation."
	new_fluff = "Gorlex branded power loaders often bore the scars of the Indo-Russian Diaspora. Some of these antiques are still in circulation."
	new_icon = "soviet"

/obj/item/kit/paint/ripley/arnold
	name = "\"Arnold\" APLU customisation kit"
	new_name = "APLU \"Arnold\""
	new_desc = "An APLU with a jungle green camo paint job."
	new_fluff = "Power loaders are loud, slow, and clunky. Poorly suited for jungle operations of any kind, this camo paint job is likely only cosmetic."
	new_icon = "ripley_camo"

/obj/item/kit/paint/ripley/clown
	name = "\"CR3AM-P13\" APLU customisation kit"
	new_name = "APLU \"CR3AM-P13\""
	new_desc = "A comedically painted APLU with an authentic, oversized clown wig."
	new_fluff = "Before the cessation of open trade led to the development of the H.O.N.K., Nanotrasen frequently sold Columbina old power loaders to serve as supplemental security units."
	new_icon = "clowny"

/obj/item/kit/paint/ripley/dreadnought
	name = "\"SAR-C0PH\" APLU customisation kit"
	new_name = "APLU \"SAR-C0PH\""
	new_desc = "A curiously modified APLU chassis. Its cockpit has been welded shut and you can hear sloshing inside."
	new_fluff = "In conjunction with Vey-Med, Nanotrasen briefly experimented with permanently interring paralyzed or critically wounded operatives in mecha. The program was allegedly disbanded following strong public outcry."
	new_icon = "dreadnought"

// Gygax kits.
/obj/item/kit/paint/gygax
	name = "\"Silhouette\" Gygax customisation kit"
	new_name = "Gygax \"Silhouette\""
	new_desc = "A Gygax with an ominous black gleam."
	new_fluff = "An ominous Gygax exosuit modelled after the fictional corporate 'death squads' made popular in the pulp action-thrillers of 2554."
	new_icon = "darkgygax"
	allowed_types = list("gygax_adv")

/obj/item/kit/paint/gygax/blue
	name = "\"Ocean Blue\" Gygax customisation kit"
	new_name = "Gygax \"Ocean Blue\""
	new_desc = "A Gygax with a blue paint job."
	new_fluff = "A bulky Gygax with a soothing blue paint job, reminiscent of the sea at midday, or a calm sky."
	new_icon = "gygax_blue"

/obj/item/kit/paint/gygax/green
	name = "\"Forest Green\" Gygax customisation kit"
	new_name = "Gygax \"Forest Green\""
	new_desc = "A Gygax with a green paint job."
	new_fluff = "A bulky Gygax with a verdant green paint job, reminiscent of waving branches, or wild grass."
	new_icon = "gygax_green"

/obj/item/kit/paint/gygax/turtle
	name = "\"Furtive Tortoise\" Gygax customisation kit"
	new_name = "Gygax \"Furtive Tortoise\""
	new_desc = "A Gygax with a cartoonish, deceptively simple paint job."
	new_fluff = "This cartoonish paint job is based off of a long forgotten Spider Clan propaganda series. The turtle depicted by this paint job, Furtive, was the no-nonsense leader."
	new_icon = "gygax_turtle"

/obj/item/kit/paint/gygax/mad_jack
	name = "\"Mad Jack\" Gygax customisation kit"
	new_name = "Gygax \"Mad Jack\""
	new_desc = "A shockingly garish Gygax with hardwood plating screwed on top of the actual armor."
	new_fluff = "This Gygax has been decorated with an additional layer of hardwood plating. There is something menacing about the way the cyclopean eye on the chest stares at you."
	new_icon = "gygax_rs"

/obj/item/kit/paint/gygax/osbourne
	name = "\"Osbourne\" Gygax customisation kit"
	new_name = "Gygax \"Osbourne\""
	new_desc = "A shockingly garish Gygax with hardwood plating screwed on top of the actual armor."
	new_fluff = "This Gygax has been decorated with an additional layer of hardwood plating. The green eye and orange texturing are reminiscent of volatile pumpkins, for some reason."
	new_icon = "gygax_gg"

/obj/item/kit/paint/gygax/carp
	name = "\"Ishmael\" Gygax customisation kit"
	new_name = "Gygax \"Ishmael\""
	new_desc = "A Gygax painted Space Carp purple. A menacing face has been painted on the glacis."
	new_fluff = "This Gygax resembles the fierce Space Carp heraldry worn by ace pilot 'Ishmael' after their famed defense of Barker IV Orbital Station Sigma. 'Ishmael' operated in intensely hazardous EVA conditions to neutralize an overwhelmingly large migration of carp, saving the facility."
	new_icon = "gygax_carp"

// Durand kits.
/obj/item/kit/paint/durand
	name = "\"Classic\" Durand customisation kit"
	new_name = "Durand \"Classic\""
	new_desc = "An antique Durand that visibly bears the weight of time."
	new_fluff = "An older model of Durand combat exosuit, this particular series was retired due to its tendency to occasionally rotate the pilot's torso 180 degrees."
	new_icon = "durand_old"
	allowed_types = list("durand")

/obj/item/kit/paint/durand/paladin
	name = "\"Crusader\" Durand customisation kit"
	new_name = "Durand \"Crusader\""
	new_desc = "A Durand painted in stark whites and golds. It seems to radiate purity."
	new_fluff = "This Durand's gleaming white plating and golden highlights radiate holiness and justice. Use it to smite evil wheresoever you find it. Be mindful of ledges - this Durand provides no protection against falls."
	new_icon = "paladin"

/obj/item/kit/paint/durand/turtle
	name = "\"Sneaky Tortoise\" Durand customisation kit"
	new_name = "Durand \"Sneaky Tortoise\""
	new_desc = "A Durand with a deceptively simple, cartoonish paint job."
	new_fluff = "This cartoonish paint job is based off of a long forgotten Spider Clan propaganda series. The turtle depicted by this paint job, Sneaky, was apparently real party dude."
	new_icon = "durand_turtle"

//H.O.N.K. kits.
/obj/item/kit/paint/honker
	name = "\"'Hot' Rod\" H.O.N.K. customisation kit"
	new_name = "H.O.N.K. \"'Hot' Rod\""
	new_desc = "A HONK mech decorated with an audacious black paint job augmented by brilliant flames."
	new_fluff = "The sweet flames painted onto this H.O.N.K. chassis are distressingly realistic, and impart even more hilarity than usual. If you look at it for long enough, you start to realize that small depictions of mimes appear to be burning in the flames."
	new_icon = "honker_flaming"
	allowed_types = list("honker")

//Mauler Kits
/obj/item/kit/paint/mauler
	name = "\"8-Ball\" Mauler customisation kit"
	new_name = "Marauder \"8-Ball\""
	new_desc = "An aged Mauler with multiple aesthetic modifications - most notably a large 8-Ball decal on the glacis."
	new_fluff = "At the peak of the Phoron War, this legendary exosuit saw much use during a variety of Frontier mercenary operations. 8-Ball was presumed lost alongside the rest of its mercenary company in 2497. Due to its participation in the junta on Editius and numerous other war crimes, a Nanotrasen backed bounty for the capture and return of 8-Ball and its pilot remains open to this day."
	new_icon = "eightball"
	allowed_types = list("mauler")

////////////
//Fighters//
////////////


///Skrell//

//Allure
/obj/item/kit/paint/fighter/allure/royalty
	name = "\"Royalty\" Allure customisation kit"
	new_name = "Allure \"Royalty\""
	new_desc = "A limited edition purple design with gold inlay that embodies the same colorations and pattern designs of royalty skrellian during the time of the Allure's initial release."
	new_icon = "allure_royalty"
	allowed_types = list("allure")


//Hephestus Industries

//Duke
/obj/item/kit/paint/fighter/duke/deepblue
	name = "\"Deep Blue\" Duke customisation kit"
	desc = "A fairly common repaint kit for the Duke heavy fighter, designed and sold by Hephaestus Industries. A small pamphlet is stored within that reads: 'This kit pays homage to one of the first supercomputing systems that dared to push the boundaries of what it meant to think. Think 40 steps ahead of your enemy with this paint kit, just as Deep Blue did so many years ago.'"
	new_name = "Duke \"Deep Blue\""
	new_desc = "A Duke heavy fighter decorated with the common 'Deep Blue' customization kit, both designed and sold by Hephaestus Industries. This paint scheme pays homage to one of the first supercomputing systems that dared to push the boundaries of what it meant to think. Think 40 steps ahead of your enemy with these colorations, just as Deep Blue did so many years ago."
	new_icon = "duke_db"
	allowed_types = list("duke")

/obj/item/kit/paint/fighter/duke/clockwork
	name = "\"Clockwork\" Duke customisation kit"
	desc = "An uncommon repaint kit for the Duke heavy fighter, designed and sold by Hephaestus Industries. A sticker is attached to the container that reads: 'Return to traditional machinery with this brass clockwork design! Textured paint with accurate colorations and reflectiveness to brass makes this a must-have if you're looking to fight in fashion!'"
	new_name = "Duke \"Clockwork\""
	new_desc = "A Duke heavy fighter decorated with the rare 'Clockwork' customization kit, both designed and sold by Hephaestus Industries. Textured paint with accurate colorations and reflectiveness to brass makes this Duke Heavy Fighter stand out amongst the competition in any conflict."
	new_icon = "duke_cw"
	allowed_types = list("duke")
