/obj/item/clothing/shoes/boots
	name = "boots"
	desc = "Generic boots."
	icon_state = "workboots"
	armor_type = /datum/armor/shoes/boots
	damage_force = 3
	can_hold_knife = 1
	step_volume_mod = 1.2

/obj/item/clothing/shoes/boots/cowboy
	name = "cowboy boots"
	desc = "Lacking a durasteel horse to ride."
	icon_state = "cowboy"

/obj/item/clothing/shoes/boots/cowboy/classic
	name = "classic cowboy boots"
	desc = "A classic looking pair of durable cowboy boots."
	icon_state = "cowboy_classic"

/obj/item/clothing/shoes/boots/cowboy/snakeskin
	name = "snakeskin cowboy boots"
	desc = "A pair of cowboy boots made from python skin."
	icon_state = "cowboy_snakeskin"

/obj/item/clothing/shoes/boots/jackboots
	name = "jackboots"
	desc = "Standard-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	siemens_coefficient = 0.7
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'


/obj/item/clothing/shoes/boots/jackboots/toeless
	name = "toe-less jackboots"
	desc = "Modified pair of jackboots, particularly friendly to those species whose toes hold claws."
	icon_state = "digiboots"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	species_restricted = null

/obj/item/clothing/shoes/boots/jackboots/knee
	name = "knee-length jackboots"
	desc = "Taller synthleather boots with an artificial shine."
	icon_state = "kneeboots"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")

/obj/item/clothing/shoes/boots/jackboots/toeless/knee
	name = "toe-less knee-length jackboots"
	desc = "Modified pair of taller boots, particularly friendly to those species whose toes hold claws."
	icon_state = "digikneeboots"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	species_restricted = null

/obj/item/clothing/shoes/boots/jackboots/thigh
	name = "thigh-length jackboots"
	desc = "Even taller synthleather boots with an artificial shine."
	icon_state = "thighboots"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")

/obj/item/clothing/shoes/boots/jackboots/toeless/thigh
	name = "toe-less thigh-length jackboots"
	desc = "Modified pair of even taller boots, particularly friendly to those species whose toes hold claws."
	icon_state = "digithighboots"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	species_restricted = null

/obj/item/clothing/shoes/boots/workboots
	name = "workboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon_state = "workboots"
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/workboots/toeless
	name = "toe-less workboots"
	desc = "A pair of toeless work boots designed for use in industrial settings. Modified for species whose toes have claws."
	icon_state = "workbootstoeless"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "workboots", SLOT_ID_LEFT_HAND = "workboots")
	species_restricted = null

/obj/item/clothing/shoes/boots/winter
	name = "winter boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	cold_protection_cover = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection_cover = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	snow_speed = -1
	step_volume_mod = 0.8

/obj/item/clothing/shoes/boots/winter/security
	name = "security winter boots"
	desc = "A pair of winter boots. These ones are lined with grey fur, and coloured an angry red."
	icon_state = "winterboots_sec"
	armor_type = /datum/armor/security/light_formalwear

/obj/item/clothing/shoes/boots/winter/science
	name = "science winter boots"
	desc = "A pair of winter boots. These ones are lined with white fur, and are trimmed with scientific advancement!"
	icon_state = "winterboots_sci"

/obj/item/clothing/shoes/boots/winter/command
	name = "Facility Director's winter boots"
	desc = "A pair of winter boots. They're lined with dark fur, and trimmed in the colours of superiority."
	icon_state = "winterboots_cap"

/obj/item/clothing/shoes/boots/winter/engineering
	name = "engineering winter boots"
	desc = "A pair of winter boots. These ones are lined with orange fur and are trimmed in the colours of disaster."
	icon_state = "winterboots_eng"

/obj/item/clothing/shoes/boots/winter/atmos
	name = "atmospherics winter boots"
	desc = "A pair of winter boots. These ones are lined with beige fur, and are trimmed in breath taking colours."
	icon_state = "winterboots_atmos"

/obj/item/clothing/shoes/boots/winter/medical
	name = "medical winter boots"
	desc = "A pair of winter boots. These ones are lined with white fur, and are trimmed like 30cc of dexalin"
	icon_state = "winterboots_med"

/obj/item/clothing/shoes/boots/winter/mining
	name = "mining winter boots"
	desc = "A pair of winter boots. These ones are lined with greyish fur, and their trim is golden!"
	icon_state = "winterboots_mining"

/obj/item/clothing/shoes/boots/winter/supply
	name = "supply winter boots"
	desc = "A pair of winter boots. These ones are lined with the galactic cargonia colors!"
	icon_state = "winterboots_sup"

/obj/item/clothing/shoes/boots/winter/hydro
	name = "hydroponics winter boots"
	desc = "A pair of winter boots. These ones are lined with brown fur, and their trim is ambrosia green"
	icon_state = "winterboots_hydro"

/obj/item/clothing/shoes/boots/winter/explorer
	name = "explorer winter boots"
	desc = "Steel-toed winter boots for mining or exploration in hazardous environments. Very good at keeping toes warm and uncrushed."
	icon_state = "explorer"
	armor_type = /datum/armor/exploration/soft

// Allows the wearer to climb cliffs, which could allow for shortcuts or sequence-breaking.
/obj/item/clothing/shoes/boots/winter/climbing
	name = "climbing winter boots"
	desc = "A pair of winter boots, with metal bracing attached to assist in climbing rocky terrain."
	icon_state = "climbing_boots"
	rock_climbing = TRUE

/obj/item/clothing/shoes/boots/tactical
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	icon_state = "jungle"
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/duty
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	icon_state = "duty"
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/jungle
	name = "jungle boots"
	desc = "A pair of durable brown boots. Waterproofed for use planetside."
	icon_state = "jungle"
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/boots/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	armor_type = /datum/armor/shoes/boots/swat
	clothing_flags = NOSLIP
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/boots/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat"
	icon_state = "swat"
	damage_force = 5
	armor_type = /datum/armor/shoes/boots/swat
	clothing_flags = NOSLIP
	siemens_coefficient = 0.6

	cold_protection_cover = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection_cover = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

//Stolen from CM, refurbished to be less terrible.
/obj/item/clothing/shoes/boots/marine
	name = "combat boots"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time.  It can hold a Strategical knife."
	icon_state = "jackboots"
	armor_type = /datum/armor/shoes/boots/swat
	siemens_coefficient = 0.6

/obj/item/clothing/shoes/cowboyboots/black
	name = "black cowboy boots"
	desc = "A pair of black cowboy boots, pretty easy to scuff up."
	icon_state = "cowboyboots_black"

/obj/item/clothing/shoes/boots/swat/para
	name = "PARA boots"
	desc = "PMD issued boots, stamped with protective seals and spells."
	item_action_name = "Enable Boot Sigils"

	var/blessed = FALSE

/obj/item/clothing/shoes/boots/swat/para/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(user.mind.isholy && !blessed)
		blessed = TRUE
		clothing_flags |= NOSLIP
		to_chat(user, "<font color=#4F49AF>You repeat the incantations etched into the boots.</font>")
	else
		blessed = FALSE
		clothing_flags &= ~NOSLIP
		to_chat(user, "<font color=#4F49AF>You dispel the incantations etched into the boots for now.</font>")

	if(!user.mind.isholy)
		to_chat(user, "<font color='red'>You're not sure what language this is.</font>")

/obj/item/clothing/shoes/boots/laconic
	name = "laconic field boots"
	desc = "These flexible boots cover the wearer's calves. An additional protective kneepad is integrated, perhaps to assist in collecting specimens in the field."
	icon_state = "laconic"

/obj/item/clothing/shoes/boots/half_moon
	name = "Half Moon boots"
	desc = "Perfect boots for crossing Mare Serenitatis. Flexible and tight, these boots ensure the wearer will be leaving a solid impression without sacrificing mobility."
	icon_state = "half_moon"

//More Warhammer Fun
/obj/item/clothing/shoes/boots/utilitarian
	name = "utilitarian military boots"
	desc = "These boots seem to have been designed for a cloven foot. They're honestly pretty uncomfortable to wear."
	icon = 'icons/clothing/suit/armor/utilitarian.dmi'
	icon_state = "tauboots"
	siemens_coefficient = 0.7
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/shoes/boots/baroque
	name = "baroque military boots"
	desc = "Small icons of religious significance have been carved into the soles, spreading holiness wherever the wearer treads."
	icon = 'icons/clothing/suit/armor/baroque.dmi'
	icon_state = "sisterboots"
	siemens_coefficient = 0.7
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/shoes/boots/paladin
	name = "elite paladin boots"
	desc = "These sturdy leather boots have been augmented with tarnished steel plate armor. The soles have been refurbished many times."
	icon = 'icons/clothing/suit/armor/medieval/paladin.dmi'
	icon_state = "paladinboot"
	siemens_coefficient = 0.7
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/shoes/boots/paladin_fake
	name = "elite paladin boots"
	desc = "These sturdy leather boots have been augmented with tarnished steel plate armor. The soles have been refurbished many times."
	icon = 'icons/clothing/suit/armor/medieval/paladin.dmi'
	icon_state = "paladinboot"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/shoes/boots/duty/alt
	icon = 'icons/clothing/shoes/boots/duty.dmi'
	icon_state = "altduty"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/shoes/boots/duty/alt/knee
	name = "knee-high duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine. These ones come up to just below the knee."
	icon_state = "altduty_long"

/obj/item/clothing/shoes/boots/duty/alt/heel
	name = "heeled knee-high duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine. These ones feature a pronounced heel and stop just below the knee."
	icon_state = "altduty_heel"

/obj/item/clothing/shoes/boots/darkcleric
	name = "dark cleric boots"
	desc = "These well-worn leather boots have seen many a mile in service to a forgotten god."
	icon = 'icons/clothing/shoes/boots/darkcleric.dmi'
	icon_state = "darkcleric"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
