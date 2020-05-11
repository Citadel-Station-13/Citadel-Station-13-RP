// PLASMEME SUITS, PROBABLY SHITCODE. GOD HELP ME

/obj/item/clothing/suit/space/plasman
	name = "Phoronoid containment suit"
	icon = 'modular_citadel/icons/obj/plasmeme/suits.dmi'
	icon_state = "plasmaman_suit"
	icon_override = 'modular_citadel/icons/mob/plasmeme/suit.dmi'
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. Seems like it doesn't protect from much else."
	slowdown = 1
	item_flags = AIRTIGHT
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	allowed = list(/obj/item/tank)
	can_breach = 0 // w h y ?
	valid_accessory_slots = (\
		ACCESSORY_SLOT_UTILITY\
		|ACCESSORY_SLOT_WEAPON\
		|ACCESSORY_SLOT_ARMBAND\
		|ACCESSORY_SLOT_DECOR\
		|ACCESSORY_SLOT_MEDAL\
		|ACCESSORY_SLOT_TIE\
		|ACCESSORY_SLOT_OVER)
	restricted_accessory_slots = (\
		ACCESSORY_SLOT_UTILITY\
		|ACCESSORY_SLOT_WEAPON\
		|ACCESSORY_SLOT_ARMBAND\
		|ACCESSORY_SLOT_TIE\
		|ACCESSORY_SLOT_OVER) // snowflake decorating i guess

/obj/item/clothing/head/helmet/space/plasman
	name = "Phoronoid containment helmet"
	icon = 'modular_citadel/icons/obj/plasmeme/hats.dmi'
	icon_state = "plasmaman_helmet"
	icon_override = 'modular_citadel/icons/mob/plasmeme/helmet.dmi'
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. Comes with a little light built in!"
	item_flags = AIRTIGHT | FLEXIBLEMATERIAL
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	light_overlay = "plasmaman_overlay"

//
// SEC
//
/obj/item/clothing/suit/space/plasman/sec
	icon_state = "plasmaman_suitsecurity"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for security use."
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 0)

/obj/item/clothing/suit/space/plasman/sec/warden
	icon_state = "plasmaman_suitwarden"

/obj/item/clothing/suit/space/plasman/sec/hos
	icon_state = "plasmaman_suithos"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for the Head of Security!"
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 100, rad = 0)

/obj/item/clothing/suit/space/plasman/sec/hop
	icon_state = "plasmaman_suithop"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for the Head of Personnel!"

/obj/item/clothing/suit/space/plasman/sec/captain
	icon_state = "plasmaman_suitcaptain"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for the Colony Director!"

/obj/item/clothing/head/helmet/space/plasman/sec
	icon_state = "plasmaman_helmetsecurity"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 0)
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for security use."

/obj/item/clothing/head/helmet/space/plasman/sec/hos
	icon_state = "plasmaman_helmethos"
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 100, rad = 0)
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for the Head of Security!"

/obj/item/clothing/head/helmet/space/plasman/sec/hop
	icon_state = "plasmaman_helmethop"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for the Head of Personnel!"

/obj/item/clothing/head/helmet/space/plasman/sec/captain
	icon_state = "plasmaman_helmetcaptain"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is armored for the Colony Director!"

//
// MEDICAL
//
/obj/item/clothing/suit/space/plasman/med
	icon_state = "plasmaman_suitmedical"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in medical colors."

/obj/item/clothing/suit/space/plasman/med/rescue
	icon_state = "plasmaman_suitparamedic"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in medical colors, and is thicker."
	armor = list(melee = 30, bullet = 5, laser = 20, energy = 5, bomb = 25, bio = 100, rad = 50)

/obj/item/clothing/suit/space/plasman/med/chemist
	icon_state = "plasmaman_suitchemist"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in chemistry colors."

/obj/item/clothing/suit/space/plasman/med/viro
	icon_state = "plasmaman_suitvirologist"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in virology colors."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 40)

/obj/item/clothing/suit/space/plasman/med/cmo
	icon_state = "plasmaman_suitcmo"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for the Chief Medical Officer!"

/obj/item/clothing/head/helmet/space/plasman/med
	icon_state = "plasmaman_helmetmedical"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in medical colors."

/obj/item/clothing/head/helmet/space/plasman/med/rescue
	icon_state = "plasmaman_helmetparamedic"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in medical colors, and is thicker."
	armor = list(melee = 30, bullet = 5, laser = 20, energy = 5, bomb = 25, bio = 100, rad = 50)

/obj/item/clothing/head/helmet/space/plasman/med/chemist
	icon_state = "plasmaman_helmetchemist"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in chemistry colors."

/obj/item/clothing/head/helmet/space/plasman/med/viro
	icon_state = "plasmaman_helmetvirologist"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in virology colors."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 40)

/obj/item/clothing/head/helmet/space/plasman/med/cmo
	icon_state = "plasmaman_helmetcmo"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for the Chief Medical Officer!"

//
// SCIENCE
//

/obj/item/clothing/suit/space/plasman/science
	icon_state = "plasmaman_suitscience"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in science colors."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 100, rad = 100)

/obj/item/clothing/suit/space/plasman/science/explorer
	armor = list(melee = 40, bullet = 15, laser = 25,energy = 35, bomb = 30, bio = 100, rad = 70)

/obj/item/clothing/suit/space/plasman/science/rd
	icon_state = "plasmaman_suitrd"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for the Research Director!"
	armor = list(melee = 45, bullet = 5, laser = 45, energy = 80, bomb = 60, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/space/plasman/science
	icon_state = "plasmaman_helmetscience"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in science colors."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/space/plasman/science/explorer
	armor = list(melee = 40, bullet = 15, laser = 25,energy = 35, bomb = 30, bio = 100, rad = 70)

/obj/item/clothing/head/helmet/space/plasman/science/rd
	icon_state = "plasmaman_helmetrd"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for the Research Director!"
	armor = list(melee = 45, bullet = 5, laser = 45, energy = 80, bomb = 60, bio = 100, rad = 100)

//
// ENGINEERING
//

/obj/item/clothing/suit/space/plasman/engi
	icon_state = "plasmaman_suitengineer"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is in engineering colors, and radiation-proof."
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 100)

/obj/item/clothing/suit/space/plasman/engi/atmos
	icon_state = "plasmaman_suitatmos"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is in atmospherics colors, and more resilient to higher temperatures."
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 60)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/plasman/engi/ce
	icon_state = "plasmaman_suitce"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for the Chief Engineer!"
	armor = list(melee = 30, bullet = 15, laser = 10, energy = 10, bomb = 30, bio = 100, rad = 100)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/plasman/engi
	icon_state = "plasmaman_helmetengineer"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is in engineering colors, and radiation-proof."
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/space/plasman/engi/atmos
	icon_state = "plasmaman_helmetatmos"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is in atmospherics colors, and more resilient to higher temperatures."
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 5, bomb = 10, bio = 100, rad = 60)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/plasman/engi/ce
	icon_state = "plasmaman_helmetce"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for the Chief Engineer!"
	armor = list(melee = 30, bullet = 15, laser = 10, energy = 10, bomb = 30, bio = 100, rad = 100)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

//
// CARGO
//

/obj/item/clothing/suit/space/plasman/cargo
	icon_state = "plasmaman_suitcargo"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in cargo colors."

/obj/item/clothing/suit/space/plasman/cargo/miner
	icon_state = "plasmaman_suitminer"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for miners, and seems to have some light armor."
	armor = list(melee = 50, bullet = 5, laser = 20, energy = 5, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/plasman/cargo
	icon_state = "plasmaman_helmetcargo"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is painted in cargo colors."

/obj/item/clothing/head/helmet/space/plasman/cargo/miner
	icon_state = "plasmaman_helmetminer"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is for miners, and seems to have some light armor."
	armor = list(melee = 50, bullet = 5, laser = 20, energy = 5, bomb = 55, bio = 100, rad = 20)

//
// OTHER (Service, IAA, etc.)
//

/obj/item/clothing/suit/space/plasman/fancy
	icon_state = "plasmaman_suitlawyer"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one looks like a tuxedo, how formal."

/obj/item/clothing/head/helmet/space/plasman/fancy
	icon_state = "plasmaman_helmetlawyer"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one has a tie dangling from the bottom."

/obj/item/clothing/suit/space/plasman/service
	icon_state = "plasmaman_suitservice"

/obj/item/clothing/head/helmet/space/plasman/service
	icon_state = "plasmaman_helmetservice"

/obj/item/clothing/suit/space/plasman/botanist
	icon_state = "plasmaman_suitbotanist"

/obj/item/clothing/head/helmet/space/plasman/botanist
	icon_state = "plasmaman_helmetbotanist"

/obj/item/clothing/suit/space/plasman/chaplain
	icon_state = "plasmaman_suitchaplain"

/obj/item/clothing/head/helmet/space/plasman/chaplain
	icon_state = "plasmaman_helmetchaplain"

/obj/item/clothing/suit/space/plasman/janitor
	icon_state = "plasmaman_suitjanitor"

/obj/item/clothing/head/helmet/space/plasman/janitor
	icon_state = "plasmaman_helmetjanitor"

//
// CLOWN AND MIME (im separating these because i made these a while after the rest 4head)
//

/obj/item/clothing/suit/space/plasman/clown
	icon_state = "plasmaman_suitclown"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is violently neon-colored, with giant shoes."

/obj/item/clothing/head/helmet/space/plasman/clown
	icon_state = "plasmaman_helmetclown"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one has had its visor painted over, and a giant orange wig attached."
	light_overlay = "plasmaman_overlay_clown"

/obj/item/clothing/suit/space/plasman/mime
	icon_state = "plasmaman_suitmime"
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one is black and white, and compels you to be quiet."

/obj/item/clothing/head/helmet/space/plasman/mime
	icon_state = "plasmaman_helmetmime"
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. This one has had its visor painted over in the visage of a mime."
	light_overlay = "plasmaman_overlay_mime"

//
// ALT LOADOUT HELMETS (YKNOW I HAD TO OK)
//

/obj/item/clothing/head/helmet/space/plasman/sec/captain/alt
	icon_state = "plasmaman_helmetcaptain_alt"
	light_overlay = "plasmaman_overlay_alt"

/obj/item/clothing/head/helmet/space/plasman/sec/hos/alt1
	icon_state = "plasmaman_helmethos_alt"
	light_overlay = "plasmaman_overlay_alt"

/obj/item/clothing/head/helmet/space/plasman/sec/hos/alt2
	icon_state = "plasmaman_helmetspook"
	light_overlay = "plasmaman_overlay_FLAMEON" // look its fire ok i had to