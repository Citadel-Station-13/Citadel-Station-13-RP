//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	clothing_flags = 0
	inv_hide_flags = HIDEFACE|BLOCKHAIR
	permeability_coefficient = 0.01
	armor = list(melee = 65, bullet = 50, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 50)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Facility Director's armor"
	desc = "A bulky, heavy-duty piece of exclusive corporate armor. YOU are in charge!"
	icon_state = "caparmor"
	w_class = ITEMSIZE_HUGE
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	clothing_flags = 0
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/energy, /obj/item/gun/ballistic, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,/obj/item/handcuffs)
	slowdown = 1.5
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	siemens_coefficient = 0.7

//Deathsquad suit
/obj/item/clothing/head/helmet/space/deathsquad
	name = "deathsquad helmet"
	desc = "That's not red paint. That's real blood."
	icon_state = "deathsquad"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-black-red", SLOT_ID_LEFT_HAND = "syndicate-helm-black-red")
	armor = list(melee = 65, bullet = 55, laser = 35,energy = 20, bomb = 30, bio = 100, rad = 60)
	clothing_flags = THICKMATERIAL
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 0.6

//how is this a space helmet?
/obj/item/clothing/head/helmet/space/deathsquad/beret
	name = "officer's beret"
	desc = "An armored beret commonly used by special operations officers."
	icon_state = "beret_badge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret", SLOT_ID_LEFT_HAND = "beret")
	armor = list(melee = 65, bullet = 55, laser = 35,energy = 20, bomb = 30, bio = 30, rad = 30)
	clothing_flags = 0
	inv_hide_flags = BLOCKHAIR
	siemens_coefficient = 0.9

//Space santa outfit suit
/obj/item/clothing/head/helmet/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	clothing_flags = 0
	inv_hide_flags = BLOCKHAIR
	body_cover_flags = HEAD

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	slowdown = 0
	clothing_flags = 0
	allowed = list(/obj/item) //for stuffing exta special presents

//Space pirate outfit
/obj/item/clothing/head/helmet/space/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	clothing_flags = 0
	inv_hide_flags = BLOCKHAIR
	body_cover_flags = 0
	siemens_coefficient = 0.9

/obj/item/clothing/suit/space/pirate //Whhhhyyyyyyy???
	name = "pirate coat"
	desc = "Yarr."
	icon_state = "pirate"
	w_class = ITEMSIZE_NORMAL
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency/oxygen)
	slowdown = 0
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0.9
	inv_hide_flags = HIDETAIL|HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|ARMS

//Orange emergency space suit
/obj/item/clothing/head/helmet/space/emergency
	name = "Emergency Space Helmet"
	icon_state = "syndicate-helm-orange"
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "Emergency Softsuit"
	icon_state = "syndicate-orange"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	slowdown = 4

//Russian Emergency Suit
/obj/item/clothing/head/helmet/space/emergency/russian
	name = "Sovjet Emergency Space Helmet"
	icon_state = "russian"
	desc = "A simple helmet with a built in light, smells like mothballs."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency/russian
	name = "Sovjet Emergency Softsuit"
	icon_state = "russian"
	desc = "A chunky antique softsuit distributed to members of the Indo-Russian Diaspora. After all this time, it looks pretty fragile."
	slowdown = 4
