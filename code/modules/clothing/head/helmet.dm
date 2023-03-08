/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	valid_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	clothing_flags = THICKMATERIAL
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)
	inv_hide_flags = HIDEEARS|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEMSIZE_NORMAL
	ear_protection = 1
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'

/obj/item/clothing/head/helmet/oricon
	name = "\improper Orion Confederation Government helmet"
	desc = "A helmet painted in Peacekeeper blue. Stands out like a sore thumb."
	icon_state = "helmet_sol"
	armor = list(melee = 50, bullet = 50, laser = 50,energy = 25, bomb = 30, bio = 0, rad = 0)
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/oricon/command
	name = "command helmet"
	desc = "A helmet with 'Orion Confederation Government' printed on the back in gold lettering."
	icon_state = "helmet_command"

/obj/item/clothing/head/helmet/oricon/security
	name = "security helmet"
	desc = "A helmet with 'MASTER AT ARMS' printed on the back in silver lettering."
	icon_state = "helmet_security"

/obj/item/clothing/head/helmet/nt
	name = "\improper NanoTrasen helmet"
	desc = "A helmet with 'CORPORATE SECURITY' printed on the back in red lettering."
	icon_state = "helmet_nt"

/obj/item/clothing/head/helmet/pcrc
	name = "\improper PCRC helmet"
	desc = "A helmet with 'PRIVATE SECURITY' printed on the back in cyan lettering."
	icon_state = "helmet_pcrc"

/obj/item/clothing/head/helmet/tac
	name = "tactical helmet"
	desc = "A tan helmet made from advanced ceramic. Comfortable and robust."
	icon_state = "helmet_tac"
	armor = list(melee = 50, bullet = 60, laser = 60, energy = 45, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/merc
	name = "combat helmet"
	desc = "A heavily reinforced helmet painted with red markings. Feels like it could take a lot of punishment."
	icon_state = "helmet_merc"
	armor = list(melee = 70, bullet = 70, laser = 70, energy = 35, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	valid_accessory_slots = null
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/riot/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		to_chat(user, "You raise the visor on the riot helmet.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the riot helmet.")
	update_worn_icon()	//so our mob-overlays update

/obj/item/clothing/head/helmet/laserproof
	name = "ablative helmet"
	desc = "It's a helmet specifically designed to protect against energy projectiles."
	icon_state = "helmet_reflec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "helmet", SLOT_ID_LEFT_HAND = "helmet")
	armor = list(melee = 10, bullet = 10, laser = 80 ,energy = 50, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.1
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/bulletproof
	name = "bullet-resistant helmet"
	desc = "It's a helmet specifically designed to protect against ballistic projectiles."
	icon_state = "helmet_bulletproof"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "helmet", SLOT_ID_LEFT_HAND = "helmet")
	armor = list(melee = 10, bullet = 80, laser = 10 ,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/combat
	name = "combat helmet"
	desc = "It's a general purpose combat helmet, designed to protect against typical dangers to your head."
	icon_state = "helmet_combat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "helmet", SLOT_ID_LEFT_HAND = "helmet")
	armor = list(melee = 50, bullet = 50, laser = 50 ,energy = 30, bomb = 30, bio = 0, rad = 0)
	inv_hide_flags = HIDEEARS|HIDEEYES|BLOCKHEADHAIR
	siemens_coefficient = 0.6
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/flexitac
	name = "tactical light helmet"
	desc = "A tan helmet made from advanced ceramic with an integrated tactical flashlight."
	icon_state = "flexitac"
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.6
	brightness_on = 6
	light_overlay = "helmet_light_dual_green"
	action_button_name = "Toggle Head-light"
	min_cold_protection_temperature = T0C - 20
	cold_protection = HEAD

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained SWAT Officers."
	icon_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	inv_hide_flags = HIDEEARS|HIDEEYES|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/alien
	name = "alien helmet"
	desc = "It's quite larger than your head, but it might still protect it."
	icon_state = "alienhelmet"
	siemens_coefficient = 0.4
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 0, rad = 40)
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/alien/tank
	name = "alien warhelm"
	armor = list(melee = 70, bullet = 70, laser = 70, energy = 70, bomb = 70, bio = 0, rad = 40)

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "vhelmet", SLOT_ID_LEFT_HAND = "vhelmet")
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	siemens_coefficient = 1
	valid_accessory_slots = null

//Obsolete, but retained for posterity.
/*
/obj/item/clothing/head/helmet/gladiator/ashlander
	name = "ashlander kranos"
	desc = "This weathered helmet bears a collection of acidic pits and claw marks."
	armor = list(melee = 5, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
*/

/obj/item/clothing/head/helmet/ashlander
	name = "ashen lamellar helmet"
	desc = "This bronze helmet is wrapped in Goliath hide. Dull bronze plates connected by dry sinew are mounted to the exterior for protection."
	icon = 'icons/clothing/suit/ashlander.dmi'
	icon_state = "lamellarhelm"
	armor = list(melee = 15, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/helmet/tactical
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")

	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	inv_hide_flags = HIDEEARS|BLOCKHAIR
	siemens_coefficient = 0.7
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "head_m", SLOT_ID_LEFT_HAND = "head_m")
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	inv_hide_flags = HIDEEARS|HIDEEYES|BLOCKHEADHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/eraticator
	name = "Eraticator Head"
	desc = "The 'head' of an Eraticator Artillery Platform, ripped off of the chassis. May be worn for totemic purposes."
	icon_state = "eraticator-head"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "helmet", SLOT_ID_LEFT_HAND = "helmet")
	armor = list(melee = 10, bullet = 80, laser = 10 ,energy = 10, bomb = 0, bio = 0, rad = 0)
	inv_hide_flags = HIDEEARS|HIDEEYES|BLOCKHEADHAIR
	siemens_coefficient = 0.7
	valid_accessory_slots = null

/obj/item/clothing/head/helmet/roman
	name = "Roman Galea"
	desc = "A reproduction helmet fashioned to look like an ancient Roman Galea. It affords the same protections as standard helmets."
	icon_state = "roman"

/obj/item/clothing/head/helmet/romancent
	name = "Roman Crested Galea"
	desc = "A reproduction helmet fashioned to look like an ancient Roman Galea. It affords the same protections as standard helmets."
	icon_state = "roman_c"

/obj/item/clothing/head/helmet/samurai
	name = "kabuto"
	desc = "An authentic antique, this helmet from old Earth belongs to an ancient martial tradition. The advent of firearms made this style of protection obsolete. Unfortunately, this remains the case."
	icon_state = "kabuto"
	armor = list(melee = 100, bullet = 00, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)

//Non-hardsuit ERT helmets.
/obj/item/clothing/head/helmet/ert
	name = "emergency response team helmet"
	desc = "An in-atmosphere helmet worn by members of the NanoTrasen Emergency Response Team. Protects the head from impacts."
	icon_state = "erthelmet_cmd"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-green", SLOT_ID_LEFT_HAND = "syndicate-helm-green")
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	valid_accessory_slots = null

//Commander
/obj/item/clothing/head/helmet/ert/command
	name = "emergency response team commander helmet"
	desc = "An in-atmosphere helmet worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "emergency response team security helmet"
	desc = "An in-atmosphere helmet worn by security members of the NanoTrasen Emergency Response Team. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "An in-atmosphere helmet worn by engineering members of the NanoTrasen Emergency Response Team. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "emergency response team medical helmet"
	desc = "A set of armor worn by medical members of the NanoTrasen Emergency Response Team. Has red and white highlights."
	icon_state = "erthelmet_med"


//PARA Armor
/obj/item/clothing/head/helmet/para
	name = "Oculus Malum visor"
	desc = "This specialty visor, nicknamed the 'MAW' by PMD agents, grants trained Agents the ability to view Paracausal events without suffering memetic hazards."
	icon_state = "para_ert_helmet"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-green", SLOT_ID_LEFT_HAND = "syndicate-helm-green")
	armor = list(melee = 60, bullet = 60, laser = 60,energy = 60, bomb = 20, bio = 0, rad = 0)
	valid_accessory_slots = null
	action_button_name = "Cycle MAW"

	flash_protection = FLASH_PROTECTION_MAJOR

	var/blessed = TRUE

/obj/item/clothing/head/helmet/para/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state) && user.mind.isholy && blessed)
		blessed = FALSE
		flash_protection = FLASH_PROTECTION_NONE
		src.icon_state = "[icon_state]_up"
		to_chat(user, "<font color=#4F49AF>The helmet's protective sigil fades as you raise the OM visor.</font>")
	else
		blessed = TRUE
		flash_protection = FLASH_PROTECTION_MAJOR
		src.icon_state = initial(icon_state)
		to_chat(user, "<font color=#4F49AF>The helmet's protective sigil glows as you lower the OM visor.</font>")
	update_worn_icon()	//so our mob-overlays update

	if(!user.mind.isholy)
		flash_protection = FLASH_PROTECTION_NONE
		blessed = FALSE
		to_chat(user, "<font color=#4F49AF>The OM visor doesn't respond to you.</font>")

/obj/item/clothing/head/helmet/para/inquisitor
	name = "PMD Inquistor's Hat"
	desc = "This wide brimmed hat projects authority and a vaguely mystical presence. It also grants its bearer the ability to view Paracausal events without suffering memetic hazards."
	icon_state = "witchhunterhat"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_black", SLOT_ID_LEFT_HAND = "beret_black")
	armor = list(melee = 40, bullet = 30, laser = 30,energy = 10, bomb = 10, bio = 0, rad = 0)
	action_button_name = "Enable Wards"

/obj/item/clothing/head/helmet/para/inquisitor/attack_self(mob/user as mob)
	if(user.mind.isholy && blessed)
		blessed = FALSE
		flash_protection = FLASH_PROTECTION_NONE
		to_chat(user, "<font color=#4F49AF>The hat's protective sigils fade as you dispel them.</font>")
	else
		blessed = TRUE
		flash_protection = FLASH_PROTECTION_MAJOR
		to_chat(user, "<font color=#4F49AF>The hat's protective sigil glows as you visualize the activation word.</font>")

	if(!user.mind.isholy)
		flash_protection = FLASH_PROTECTION_NONE
		blessed = FALSE
		to_chat(user, "<font color=#4F49AF>The hat does not respond to you.</font>")

/obj/item/clothing/head/helmet/bike_helmet
	name = "riding helmet"
	desc = "Safety gear designed to protect the head from impacts. It's a bit dorky."
	icon_state = "sport"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

	color = "#ffffff"

/obj/item/clothing/head/helmet/bike_helmet/random/Initialize(mapload)
	. = ..()
	color = rgb(rand(1,255),rand(1,255),rand(1,255))

/obj/item/clothing/head/helmet/oricon
	name = "\improper Orion Confederation Government helmet"
	desc = "A helmet painted in Peacekeeper blue. Stands out like a sore thumb."

/obj/item/clothing/head/helmet/oricon/command
	name = "\improper Orion Central commander helmet"
	desc = "A helmet with 'Orion Confederation Government' printed on the back in gold lettering."

/obj/item/clothing/head/helmet/combat/JSDF
	name = "marine helmet"
	desc = "If you wanna to keep your brain inside yo' head, you'd best put this on!"
	icon_state = "unsc_helm"
	item_state = "unsc_helm"
	icon = 'icons/obj/clothing/hats.dmi'

/obj/item/clothing/head/helmet/combat/imperial
	name = "imperial soldier helmet"
	desc = "Veni, vidi, vici; I came, I saw, I conquered."
	icon_state = "ge_helm"
	icon = 'icons/obj/clothing/hats.dmi'

/obj/item/clothing/head/helmet/combat/imperial/centurion
	name = "imperial centurion helmet"
	desc = "Vendi, vidi, visa; I came, I saw, I realised this hat was too expensive."
	icon_state = "ge_helmcent"
	icon = 'icons/obj/clothing/hats.dmi'

//Pirate
/obj/item/clothing/head/helmet/pirate
	name = "defaced helmet"
	desc = "A helmet whose prior lettering has been defaced and painted over."
	icon_state = "helmet_pirate"

//Cyberpunk
/obj/item/clothing/head/helmet/cyberpunk
	name = "cyberpunk goggles"
	desc = "These armored goggles help to augment the sight of the wearer. Initially designed to allow the user to enter a fully immersive digital environment, they have since been phased out in favor of NIFs and personal VR suites."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "cyberpunkgoggle"

//Strange Plate Armor
/obj/item/clothing/head/helmet/kettle
	name = "KTL plate helmet"
	desc = "These rare helmets are believed to originate from an isolationist human society on the Eastern Rim. The meaning of the designation is unknown, leading to the popular moniker 'Kettle'."
	icon_state = "kettle"

/obj/item/clothing/head/helmet/kettle/eyes
	icon_state = "kettle_eyes"

//More Warhammer Fun
/obj/item/clothing/head/helmet/utilitarian
	name = "utilitarian military helmet"
	desc = "This high tech helmet provides plenty of battlefield telemetry and aim assistance. It is designed to protect the wearer almost exclusively from ranged attacks."
	icon = 'icons/clothing/suit/armor/utilitarian.dmi'
	icon_state = "tauhelm"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndicate-helm-green", SLOT_ID_LEFT_HAND = "syndicate-helm-green")
	armor = list(melee = 15, bullet = 40, laser = 60, energy = 30, bomb = 20, bio = 0, rad = 0)
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/helmet/duraskull
	name = "durasteel skull mask"
	desc = "The process of working durasteel into such a shape is no small feat. Whoever commissioned this wanted to send a serious message."
	icon = 'icons/clothing/head/duraskull.dmi'
	icon_state = "ahelm"
	armor = list(melee = 40, bullet = 40, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
