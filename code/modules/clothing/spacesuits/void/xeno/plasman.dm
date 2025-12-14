/obj/item/clothing/suit/space/void/plasman
	name = "phoronoid environmental protection suit"
	icon = 'icons/obj/plasmeme/suits.dmi'
	icon_state = "plasmaman_suit"
	icon_override = 'icons/mob/plasmeme/suits.dmi'
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring."
	weight = ITEM_WEIGHT_PHORONOID_SUIT
	encumbrance = ITEM_ENCUMBRANCE_PHORONOID_SUIT
	clothing_flags = ALLOWINTERNALS
	armor_type = /datum/armor/phoronoid
	can_breach = 0 //I don't agree with this personally, but hey, it was already here, so I can just not touch it.
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
	starts_with_helmet = TRUE
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman

/obj/item/clothing/suit/space/void/plasman/examine()
	. = ..()
	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		if((H._item_by_slot(SLOT_ID_SUIT) == src) && istype(H.species, /datum/species/phoronoid))
			. += SPAN_NOTICE("Free phoron depletion in surface tissues is currently [H.getOxyLoss()]%.")

/obj/item/clothing/head/helmet/space/void/plasman
	name = "phoronoid environmental protection helmet"
	icon = 'icons/obj/plasmeme/hats.dmi'
	icon_state = "plasmaman_helmet"
	icon_override = 'icons/mob/plasmeme/helmet.dmi'
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite."
	clothing_flags = ALLOWINTERNALS | FLEXIBLEMATERIAL
	armor_type = /datum/armor/phoronoid
	light_overlay = "plasmaman_overlay"
	weight = ITEM_WEIGHT_PHORONOID_HELMET
	encumbrance = ITEM_ENCUMBRANCE_PHORONOID_HELMET
	var/analyzing = FALSE

/obj/item/clothing/head/helmet/space/void/plasman/examine()
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to enable the atmospheric analysis suite.")

/obj/item/clothing/head/helmet/space/void/plasman/AltClick(mob/user)
	. = ..()
	analyzing = !analyzing
	to_chat(user, SPAN_NOTICE("The atmospheric analysis suite has been <b>[analyzing ? "enabled" : "disabled"]</b>."))

/obj/item/clothing/head/helmet/space/void/plasman/equipped(mob/user, slot, flags)
	..()
	if((slot == SLOT_ID_HEAD) && (user._item_by_slot(SLOT_ID_HEAD) == src))
		RegisterSignal(user, COMSIG_MOB_EXAMINATE, PROC_REF(doGasAnalysis))


/obj/item/clothing/head/helmet/space/void/plasman/unequipped(mob/user, slot, flags)
	..()
	UnregisterSignal(user, COMSIG_MOB_EXAMINATE)


/obj/item/clothing/head/helmet/space/void/plasman/proc/doGasAnalysis(mob/examiner, atom/target)
	if(istype(examiner, /mob/living/carbon/human) && analyzing)
		var/mob/living/carbon/human/H = examiner
		if((H._item_by_slot(SLOT_ID_HEAD) == src))
			analyze_gases(target, H, TRUE, TRUE)
//
// SEC
//
/obj/item/clothing/suit/space/void/plasman/sec
	icon_state = "plasmaman_suitsecurity"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is armored for security use."
	armor_type = /datum/armor/phoronoid/security
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/sec

/obj/item/clothing/suit/space/void/plasman/sec/detective
	icon_state = "plasmaman_suitdetective"
	desc = "A lightweight voidsuit designed to keep sleuthy phoronoids from reacting with oxygenated environments. This one is comes with noir jacket decor."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/sec/detective

/obj/item/clothing/suit/space/void/plasman/sec/warden
	icon_state = "plasmaman_suitwarden"

/obj/item/clothing/suit/space/void/plasman/sec/hos
	icon_state = "plasmaman_suithos"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is armored for the Head of Security!"
	armor_type = /datum/armor/phoronoid/security/head
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/sec/hos

/obj/item/clothing/suit/space/void/plasman/sec/hop
	icon_state = "plasmaman_suithop"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is armored for the Head of Personnel!"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/sec/hop


/obj/item/clothing/suit/space/void/plasman/sec/captain
	icon_state = "plasmaman_suitcaptain"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is armored for the Facility Director!"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/sec/captain


/obj/item/clothing/head/helmet/space/void/plasman/sec
	icon_state = "plasmaman_helmetsecurity"
	armor_type = /datum/armor/phoronoid/security
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is armored for security use."

/obj/item/clothing/head/helmet/space/void/plasman/sec/detective
	icon_state = "plasmaman_helmetdetective"
	desc = "A helmet designed by NT to keep sleuthy phoronoids from coming into contact with incompatible atmosphere. This one is adorned with an ill-fashioned fedora decal."

/obj/item/clothing/head/helmet/space/void/plasman/sec/hos
	icon_state = "plasmaman_helmethos"
	armor_type = /datum/armor/phoronoid/security/head
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is armored for the Head of Security!"

/obj/item/clothing/head/helmet/space/void/plasman/sec/hop
	icon_state = "plasmaman_helmethop"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is armored for the Head of Personnel!"

/obj/item/clothing/head/helmet/space/void/plasman/sec/captain
	icon_state = "plasmaman_helmetcaptain"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is armored for the Facility Director!"

//
// MEDICAL
//
/obj/item/clothing/suit/space/void/plasman/med
	icon_state = "plasmaman_suitmedical"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is painted in medical colors."
	armor_type = /datum/armor/phoronoid/medical
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/med

/obj/item/clothing/suit/space/void/plasman/med/rescue
	icon_state = "plasmaman_suitparamedic"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is painted in medical colors, and is thicker."
	armor_type = /datum/armor/phoronoid/medical/paramedic
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/med/rescue

/obj/item/clothing/suit/space/void/plasman/med/chemist
	icon_state = "plasmaman_suitchemist"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is painted in chemistry colors."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/med/chemist

/obj/item/clothing/suit/space/void/plasman/med/viro
	icon_state = "plasmaman_suitvirologist"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is painted in virology colors."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/med/viro

/obj/item/clothing/suit/space/void/plasman/med/cmo
	icon_state = "plasmaman_suitcmo"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is for the Chief Medical Officer!"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/med/cmo

/obj/item/clothing/head/helmet/space/void/plasman/med
	icon_state = "plasmaman_helmetmedical"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in medical colors."
	armor_type = /datum/armor/phoronoid/medical

/obj/item/clothing/head/helmet/space/void/plasman/med/rescue
	icon_state = "plasmaman_helmetparamedic"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in medical colors, and is thicker."
	armor_type = /datum/armor/phoronoid/medical/paramedic

/obj/item/clothing/head/helmet/space/void/plasman/med/chemist
	icon_state = "plasmaman_helmetchemist"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in chemistry colors."

/obj/item/clothing/head/helmet/space/void/plasman/med/viro
	icon_state = "plasmaman_helmetvirologist"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in virology colors."

/obj/item/clothing/head/helmet/space/void/plasman/med/cmo
	icon_state = "plasmaman_helmetcmo"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is for the Chief Medical Officer!"
	armor_type = /datum/armor/phoronoid/head

//
// SCIENCE
//

/obj/item/clothing/suit/space/void/plasman/science
	icon_state = "plasmaman_suitscience"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is painted in science colors."
	armor_type = /datum/armor/phoronoid/science
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/science


/obj/item/clothing/suit/space/void/plasman/science/explorer
	armor_type = /datum/armor/phoronoid/exploration
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/science/explorer

/obj/item/clothing/suit/space/void/plasman/science/rd
	icon_state = "plasmaman_suitrd"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is for the Research Director!"
	armor_type = /datum/armor/phoronoid/head
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/science/rd

/obj/item/clothing/head/helmet/space/void/plasman/science
	icon_state = "plasmaman_helmetscience"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in science colors."
	armor_type = /datum/armor/phoronoid/science

/obj/item/clothing/head/helmet/space/void/plasman/science/alt
	name = "phoronoid environmental protection bubble helmet"
	icon_state = "plasmaman_helmet_scialt"
	desc = "A lightweight voidsuit bubble helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in science colors."

/obj/item/clothing/head/helmet/space/void/plasman/science/explorer
	armor_type = /datum/armor/phoronoid/exploration

/obj/item/clothing/head/helmet/space/void/plasman/science/explorer/alt
	name = "phoronoid environmental protection bubble helmet"
	icon_state = "plasmaman_helmet_scialt"
	desc = "A lightweight voidsuit bubble helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in science colors."

/obj/item/clothing/head/helmet/space/void/plasman/science/rd
	icon_state = "plasmaman_helmetrd"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is for the Research Director!"
	armor_type = /datum/armor/phoronoid/head

//
// ENGINEERING
//

/obj/item/clothing/suit/space/void/plasman/engi
	icon_state = "plasmaman_suitengineer"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is in engineering colors, and radiation-proof."
	armor_type = /datum/armor/phoronoid/engineering
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/engi

/obj/item/clothing/suit/space/void/plasman/engi/atmos
	icon_state = "plasmaman_suitatmos"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is in atmospherics colors, and more resilient to higher temperatures."
	armor_type = /datum/armor/phoronoid/engineering
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/engi/atmos

/obj/item/clothing/suit/space/void/plasman/engi/ce
	icon_state = "plasmaman_suitce"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is for the Chief Engineer!"
	armor_type = /datum/armor/phoronoid/head
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/engi/ce

/obj/item/clothing/head/helmet/space/void/plasman/engi
	icon_state = "plasmaman_helmetengineer"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is in engineering colors, and radiation-proof."
	armor_type = /datum/armor/phoronoid/engineering

/obj/item/clothing/head/helmet/space/void/plasman/engi/atmos
	icon_state = "plasmaman_helmetatmos"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is in atmospherics colors, and more resilient to higher temperatures."
	armor_type = /datum/armor/phoronoid/engineering
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/void/plasman/engi/ce
	icon_state = "plasmaman_helmetce"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is for the Chief Engineer!"
	armor_type = /datum/armor/phoronoid/head
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

//
// CARGO
//

/obj/item/clothing/suit/space/void/plasman/cargo
	icon_state = "plasmaman_suitcargo"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is painted in cargo colors."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/cargo

/obj/item/clothing/suit/space/void/plasman/cargo/miner
	icon_state = "plasmaman_suitminer"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is for miners, and seems to have some light armor."
	armor_type = /datum/armor/phoronoid/miner
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/cargo/miner

/obj/item/clothing/head/helmet/space/void/plasman/cargo
	icon_state = "plasmaman_helmetcargo"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is painted in cargo colors."

/obj/item/clothing/head/helmet/space/void/plasman/cargo/miner
	icon_state = "plasmaman_helmetminer"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one is for miners, and seems to have some light armor."
	armor_type = /datum/armor/phoronoid/miner

//
// OTHER (Service, IAA, etc.)
//

/obj/item/clothing/suit/space/void/plasman/fancy
	icon_state = "plasmaman_suitlawyer"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one looks like a tuxedo, how formal."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/fancy

/obj/item/clothing/head/helmet/space/void/plasman/fancy
	icon_state = "plasmaman_helmetlawyer"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one has a tie dangling from the bottom."

/obj/item/clothing/suit/space/void/plasman/service
	icon_state = "plasmaman_suitservice"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/service

/obj/item/clothing/head/helmet/space/void/plasman/service
	icon_state = "plasmaman_helmetservice"

/obj/item/clothing/suit/space/void/plasman/botanist
	icon_state = "plasmaman_suitbotanist"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/botanist

/obj/item/clothing/head/helmet/space/void/plasman/botanist
	icon_state = "plasmaman_helmetbotanist"

/obj/item/clothing/suit/space/void/plasman/chaplain
	icon_state = "plasmaman_suitchaplain"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/chaplain

/obj/item/clothing/head/helmet/space/void/plasman/chaplain
	icon_state = "plasmaman_helmetchaplain"

/obj/item/clothing/suit/space/void/plasman/janitor
	icon_state = "plasmaman_suitjanitor"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/janitor

/obj/item/clothing/head/helmet/space/void/plasman/janitor
	icon_state = "plasmaman_helmetjanitor"

/obj/item/clothing/suit/space/void/plasman/assistant
	icon_state = "plasmaman_suitassistant"
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/assistant

/obj/item/clothing/head/helmet/space/void/plasman/assistant
	icon_state = "plasmaman_helmetassistant"
//
// CLOWN AND MIME (im separating these because i made these a while after the rest 4head)
//

/obj/item/clothing/suit/space/void/plasman/clown
	icon_state = "plasmaman_suitclown"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is violently neon-colored, with giant shoes."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/clown

/obj/item/clothing/head/helmet/space/void/plasman/clown
	icon_state = "plasmaman_helmetclown"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one has had its visor painted over, and a giant orange wig attached."
	light_overlay = "plasmaman_overlay_clown"

/obj/item/clothing/suit/space/void/plasman/mime
	icon_state = "plasmaman_suitmime"
	desc = "A lightweight voidsuit designed to keep phoronoids from reacting with oxygenated environments. Contains some sensors for basic vitals monitoring. This one is black and white, and compels you to be quiet."
	helmet_type = /obj/item/clothing/head/helmet/space/void/plasman/mime

/obj/item/clothing/head/helmet/space/void/plasman/mime
	icon_state = "plasmaman_helmetmime"
	desc = "A lightweight voidsuit helmet designed to keep phoronoids from reacting with oxygenated environments. Contains a basic external sensor suite. This one has had its visor painted over in the visage of a mime."
	light_overlay = "plasmaman_overlay_mime"

//
// ALT LOADOUT HELMETS (YKNOW I HAD TO OK)
//

/obj/item/clothing/head/helmet/space/void/plasman/sec/captain/alt
	icon_state = "plasmaman_helmetcaptain_alt"
	light_overlay = "plasmaman_overlay_alt"

/obj/item/clothing/head/helmet/space/void/plasman/sec/hos/alt1
	icon_state = "plasmaman_helmethos_alt"
	light_overlay = "plasmaman_overlay_alt"

/obj/item/clothing/head/helmet/space/void/plasman/sec/hos/alt2
	icon_state = "plasmaman_helmetspook"
	light_overlay = "plasmaman_overlay_FLAMEON" // look its fire ok i had to
