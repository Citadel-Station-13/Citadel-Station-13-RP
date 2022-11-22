/obj/item/clothing/head/helmet/space/void/zaddat
	name = "\improper Hegemony Shroud helmet"
	desc = "A Hegemony-designed utilitarian environment suit helmet, still common among the Spacer Zaddat."
	icon_state = "zaddat_hegemony"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate", SLOT_ID_LEFT_HAND = "syndicate")
	heat_protection = HEAD
	body_parts_covered = HEAD|FACE|EYES
	slowdown = 0.5
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 100) //hey look! some rad protection!
	siemens_coefficient = 1

	species_restricted = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN) //on request from maintainer

/obj/item/clothing/suit/space/void/zaddat
	name = "\improper Hegemony Shroud"
	desc = "A Hegemony environment suit, still favored by the Spacer Zaddat because of its durability and ease of manufacture."
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	siemens_coefficient = 1
	allowed = list(/obj/item/flashlight,/obj/item/tank)
	icon_state = "zaddat_hegemony"
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat //shrouds come with helmets built-in
	var/has_been_customized = FALSE

	species_restricted = list(SPECIES_ZADDAT, SPECIES_PROMETHEAN)

	breach_threshold = 12

/obj/item/clothing/suit/space/void/zaddat/verb/custom_suit()
	set name = "Customize Shroud"
	set category = "Object"
	set desc = "Pick an appearence for your Shroud."

	var/mob/M = usr
	var/suit_style = null

	if(has_been_customized)
		to_chat(M, "This Shroud has already been customized!")
		return 0

	suit_style = input(M, "Which suit style would you like?") in list("Engineer", "Spacer", "Knight", "Royal", "Fashion", "Bishop", "Hegemony", "Rugged", "Ancient", "Freefarer", "Healer", "Breaker", "Clockwork", "Retro", "Business")
	switch(suit_style)
		if("Engineer")
			name = "\improper Engineer's Guild Shroud"
			base_name = "\improper Engineer's Guild Shroud"
			desc = "This rugged Shroud was created by the Xozi Engineering Guild."
			icon_state = "zaddat_engie"
			item_state = "zaddat_engie"
			if(helmet)
				helmet.name = "\improper Engineer's Guild Shroud helmet"
				helmet.desc = "A Shroud helmet designed for good visibility in low-light environments."
				helmet.icon_state = "zaddat_engie"
				helmet.item_state = "zaddat_engie"
		if("Spacer")
			name = "\improper Spacer's Guild Shroud"
			base_name = "\improper Spacer's Guild Shroud"
			desc = "The blue plastic Shroud worn by members of the Zaddat Spacer's Guild."
			icon_state = "zaddat_spacer"
			item_state = "zaddat_spacer"
			if(helmet)
				helmet.name = "\improper Spacer's Guild Shroud helmet"
				helmet.desc = "A cool plastic-and-glass helmet designed after popular adventure fiction."
				helmet.icon_state = "zaddat_spacer"
				helmet.item_state = "zaddat_spacer"
		if("Knight")
			name = "\improper Knight's Shroud"
			base_name = "\improper Knight's Shroud"
			desc = "This distinctive steel-plated Shroud was popularized by the Noble Guild."
			icon_state = "zaddat_knight"
			item_state = "zaddat_knight"
			if(helmet)
				helmet.name = "\improper Knight's Shroud helm"
				helmet.desc = "This spaceworthy helmet was patterned after the knight's helmets used by Zaddat before their discovery by the Unathi."
				helmet.icon_state = "zaddat_knight"
				helmet.item_state = "zaddat_knight"
		if("Royal")
			name = "\improper Royal Shroud"
			base_name = "\improper Royal Shroud"
			desc = "This distinctive steel-plated, golden trimmed Shroud is suited only for the most remarkable in the Noble Guild."
			icon_state = "zaddat_royal"
			item_state = "zaddat_royal"
			if(helmet)
				helmet.name = "\improper Royal Shroud helm"
				helmet.desc = "This spaceworthy helmet was patterned after the king's and queen's helmets used by Zaddat before their discovery by the Unathi."
				helmet.icon_state = "zaddat_royal"
				helmet.item_state = "zaddat_royal"
		if("Fashion")
			name = "\improper Avazi House Shroud"
			base_name = "\improper Avazi House Shroud"
			desc = "The designers of the Avazi Fashion House are among the most renowned in Zaddat society, and their Shroud designs second to none."
			icon_state = "zaddat_fashion"
			item_state = "zaddat_fashion"
			if(helmet)
				helmet.name = "\improper Avazi House Shroud helmet"
				helmet.desc = "The Avazi Fashion House recently designed this popular Shroud helmet, designed to pleasingly frame a Zaddat's face."
				helmet.icon_state = "zaddat_fashion"
				helmet.item_state = "zaddat_fashion"
		if("Bishop")
			name = "\improper Bishop-patterned Shroud"
			base_name = "\improper Bishop-patterned Shroud"
			desc = "The bold designers of the Dzaz Fashion House chose to make this Bishop-themed Shroud design as a commentary on the symbiotic nature of Vanax and human culture. Allegedly."
			icon_state = "zaddat_bishop"
			item_state = "zaddat_bishop"
			if(helmet)
				helmet.name = "\improper Bishop-patterned Shroud helmet"
				helmet.desc = "The Shroud helmet that inspired a dozen lawsuits."
				helmet.icon_state = "zaddat_bishop"
				helmet.item_state = "zaddat_bishop"
		if("Rugged")
			name = "\improper rugged Shroud"
			base_name = "\improper rugged Shroud"
			desc = "This Shroud was patterned after from First Contact era human voidsuits."
			icon_state = "zaddat_rugged"
			item_state = "zaddat_rugged"
			if(helmet)
				helmet.name = "\improper rugged Shroud helmet"
				helmet.desc = "Supposedly, this helmet should make humans more comfortable and familiar with the Zaddat."
				helmet.icon_state = "zaddat_rugged"
				helmet.item_state = "zaddat_rugged"
		if("Ancient")
			name = "ancient Shroud"
			base_name = "ancient Shroud"
			desc = "History is spoken through scars, this Shroud wears many, and has seen the test of time."
			icon_state = "zaddat_ancient"
			item_state = "zaddat_ancient"
			if(helmet)
				helmet.name = "ancient Shroud helmet"
				helmet.desc = "This old, durable, rusted helmet bears a long crack across the visor, along with many other nicks and scratches along it's plating. Your mind stirrs with memories the longer you look into it."
				helmet.icon_state = "zaddat_ancient"
				helmet.item_state = "zaddat_ancient"
		if("Freefarer")
			name = "\improper Freefarer Shroud"
			base_name = "\improper Freefarer Shroud"
			desc = "For the ones who want to see more in the universe than what's right in front of them, the Freefarer Shroud is a fine partner in your ventures."
			icon_state = "zaddat_freefarer"
			item_state = "zaddat_freefarer"
			if(helmet)
				helmet.name = "\improper Freefarer Shroud helm"
				helmet.desc = "Modeled after more modern voidsuit designs, this sleek Shoud Helmet is built for the stars."
				helmet.icon_state = "zaddat_freefarer"
				helmet.item_state = "zaddat_freefarer"
		if("Healer")
			name = "\improper Healer Shroud"
			base_name = "\improper Healer Shroud"
			desc = "A much more modern Shroud than many, this suit was designed for mobility and comfort for those who risk their lives to save others."
			icon_state = "zaddat_healer"
			item_state = "zaddat_healer"
			if(helmet)
				helmet.name = "\improper Healer Shroud helm"
				helmet.desc = "Modeled after more modern voidsuit designs, this sleek Shoud Helmet is built for high visibility in emergency situations."
				helmet.icon_state = "zaddat_healer"
				helmet.item_state = "zaddat_healer"
		if("Breaker")
			name = "\improper Breaker Shroud"
			base_name = "\improper Breaker Shroud"
			desc = "Built with durability and intimidation in mind, the military grade 'Breaker' Shroud is typically reserved for combat qualified individuals."
			icon_state = "zaddat_breaker"
			item_state = "zaddat_breaker"
			if(helmet)
				helmet.name = "\improper Breaker Shroud helm"
				helmet.desc = "Well armored and well crafted, modeled after human military grade voidsuits."
				helmet.icon_state = "zaddat_breaker"
				helmet.item_state = "zaddat_breaker"
		if("Clockwork")
			name = "\improper Clockwork Shroud"
			base_name = "\improper Clockwork Shroud"
			desc = "For the more sophisticated of Zaddat, this elegant brass Clockwork Shroud wears many vibrant red ribbons, making one hell of a fashion statement."
			icon_state = "zaddat_clockwork"
			item_state = "zaddat_clockwork"
			if(helmet)
				helmet.name = "\improper Clockwork Shroud helm"
				helmet.desc = "Tight brass with a vibrant red visor, an unforgettable look."
				helmet.icon_state = "zaddat_clockwork"
				helmet.item_state = "zaddat_clockwork"
		if("Retro")
			name = "\improper Retro Shroud"
			base_name = "\improper Retro Shroud"
			desc = "A standout one of a kind modern take on the classic EVA suit. What it lacks in plating it makes up for in style."
			icon_state = "zaddat_retro"
			item_state = "zaddat_retro"
			if(helmet)
				helmet.name = "\improper Retro Shroud helm"
				helmet.desc = "Built for comfort and simplicity, the Retro Shroud is a good blend between mobility and protection."
				helmet.icon_state = "zaddat_retro"
				helmet.item_state = "zaddat_retro"
		if("Business")
			name = "\improper Business Shroud"
			base_name = "\improper Business Shroud"
			desc = "A slim fitting suit fashioned after Earthen Tuxedos, supposedly this is what you need to wear to get to the top."
			icon_state = "zaddat_business"
			item_state = "zaddat_business"
			if(helmet)
				helmet.name = "\improper Business Shroud helm"
				helmet.desc = "A classic style helmet with a dashing red bowtie clipped on. Some say it looks silly, but you know what's REALLY in style these days."
				helmet.icon_state = "zaddat_business"
				helmet.item_state = "zaddat_business"

	to_chat(M, "You finish customizing your Shroud. Looking good!")
	has_been_customized = TRUE
	M.regenerate_icons()
	return 1
