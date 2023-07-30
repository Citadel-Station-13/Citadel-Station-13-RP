//Suits
/obj/item/clothing/suit/tajaran/furs //Why does this hind the tail?
	name = "heavy furs"
	desc = "A traditional Zhan-Khazan garment."
	icon_state = "zhan_furs"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/clothing/head/tajaranold/scarf //This stays in /suits because it goes with the furs above
	name = "headscarf"
	desc = "A scarf of coarse fabric. Seems to have ear-holes."
	icon_state = "zhan_scarf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "beret_white", SLOT_ID_LEFT_HAND = "beret_white")
	body_cover_flags = HEAD|FACE
	body_cover_flags = HEAD|FACE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

/obj/item/clothing/suit/armor/amohda // Changed to be generic
	name = "Adhomian swordsman armor"
	desc = "A suit of armor used by tajaran swordsmen."
	icon = 'icons/obj/clothing/species/tajaran/suits.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/suits.dmi'
	icon_state = "amohdan_armor"
	item_state = "amohdan_armor"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/gun,/obj/item/material/sword)
	inv_hide_flags = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	species_restricted = list(SPECIES_TAJ)
	armor_type = /datum/armor/general/medieval
	weight = ITEM_WEIGHT_TAJARAN_SWORDSMAN_ARMOR
	encumbrance = ITEM_ENCUMBRANCE_TAJARAN_SWORDSMAN_ARMOR
	siemens_coefficient = 0.35

//Coats no hoods
/obj/item/clothing/suit/storage/toggle/tajaran/coat/medical
	name = "Adhomian medical coat"
	desc = "A sterile insulated coat made of leather stitched over fur."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "medcoat"
	blood_overlay_type = "coat"
	body_cover_flags = UPPER_TORSO|ARMS
	inv_hide_flags = HIDEHOLSTER
	allowed = list(/obj/item/analyzer,/obj/item/stack/medical,/obj/item/dnainjector,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/healthanalyzer,/obj/item/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor_type = /datum/armor/suit/labcoat

/obj/item/clothing/suit/storage/toggle/tajaran/coat/wool
	name = "Adhomian wool coat"
	desc = "An adhomian coat, this one is a design commonly found among the Rhazar'Hrujmagh people."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "zhan_coat"

/obj/item/clothing/suit/storage/toggle/tajaran/coat/raakti_shariim
	name = "\improper Raakti Shariim coat"
	desc = "A blue adhomian wool coat with lilac purple accents and pale-gold insignia, signifying a Constable of the NKA's Raakti Shariim."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "raakti_shariim_coat"

/obj/item/clothing/suit/storage/toggle/tajaran/coat
	name = "Tajaran naval coat"
	desc = "A thick wool coat from Adhomai."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "navalcoat"

//no toggles
/obj/item/clothing/suit/storage/tajaran/jacket
	name = "Adhomian surplus jacket"
	desc = "An olive surplus jacket worn by the forces of the People's Republic of Adhomai's Grand People's Army."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "greenservice"
	item_state = "greenservice"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/armored/tajaran/pra_jacket
	name = "Adhomian surplus jacket"
	desc = "An olive surplus jacket worn by the forces of the People's Republic of Adhomai's Grand People's Army."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.50
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/jacket/dpra_jacket
	name = "DPRA jacket"
	desc = "A jacket based on the DPRA Army's old equipment when they were still a militant insurgency movement."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "dpra_jacket"
	item_state = "dpra_jacket"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/jacket/fancy
	name = "Fancy royalist jacket"
	desc = "An adhomian jacket frequently worn by the New Kingdom's nobility."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "nka_Jacket"
	item_state = "nka_Jacket"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/coat/fancycoat
	name = "Fancy black ladies coat"
	desc = "A long tailed coat, commonly worn by woman in the New Kingdom."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "ladies_coat"
	item_state = "ladies_coat"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/coat/fancycoat/red
	name = "Fancy red ladies coat"
	icon_state = "ladies_coat_red"
	item_state = "ladies_coat_red"

/obj/item/clothing/suit/storage/tajaran/coat/finecoat
	name = "Fine brown coat"
	desc = "A fancy, warm coat suitable for a noble."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "finecoat"
	item_state = "finecoat"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/coat/finecoat/blue
	name = "fine blue coat"
	icon_state = "finecoat_blue"
	item_state = "finecoat_blue"

/obj/item/clothing/suit/storage/nka/tajaran/merchant_navy
	name = "his majesty's mercantile flotilla captain coat"
	desc = "A fancy coat worn by captains of the New Kingdom's mercantile navy. It offers extra protection against space wind."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "capjacket"
	item_state = "capjacket"

/obj/item/clothing/suit/storage/tajaran/coat
	name = "Adhomian hunting coat"
	desc = "A coat made of adhomian pelts. Commonly used by hunters."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "hunter_coat"
	item_state = "hunter_coat"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/suit/storage/tajaran/jacket/archeologist
	name = "Adhomian archeologist jacket"
	desc = "A leather jacket used by Adhomian archeologists."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "explorer_jacket"
	item_state = "explorer_jacket"

/obj/item/clothing/suit/storage/hooded/tajaran/surgery
	name = "Adhomian surgeon garb"
	desc = "An utilitarian Adhomian surgeon's garb, with its design hardly changed from the First Revolution."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "tajscrubs"
	hoodtype = /obj/item/clothing/head/hood/tajaran/surgery
	species_restricted = list(SPECIES_TAJ)

//Cloaks
/obj/item/clothing/suit/storage/hooded/tajaran/cloak
	name = "Adhomian maroon cloak"
	desc = "A simple maroon colored Adhomian cloak."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "maroon_cloak"
	body_cover_flags = UPPER_TORSO
	hoodtype = /obj/item/clothing/head/hood/tajaran/cloak

/obj/item/clothing/suit/storage/hooded/tajaran/cloak/gruff
	name = "Gruff cloak"
	desc = "A cloak designated for the lowest classes of tajara."
	icon_state = "taj_cloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	inv_hide_flags = HIDETAIL
	hoodtype = /obj/item/clothing/head/hood/tajaran/cloak/gruff

/obj/item/clothing/suit/storage/hooded/tajaran/cloak/amohda
	name = "Amohdan cloak"
	desc = "Originally used by the Amohdan swordsmen before the First Revolution, this cloak is now commonly worn by the island population."
	icon_state = "amohda_cloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|HEAD
	hoodtype = /obj/item/clothing/head/hood/tajaran/cloak/amohda

/obj/item/clothing/suit/storage/hooded/tajaran/cloak/winter
	name = "Adhomian winter cloak"
	desc = "A simple wool cloak used during the early days of the lesser winter."
	icon_state = "winter_cloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = TN60C
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	hoodtype = /obj/item/clothing/head/hood/tajaran/cloak/winter

/obj/item/clothing/suit/storage/hooded/tajaran/cloak/royalist
	name = "Adhomian royalist cloak"
	desc = "An Adhomian cloak with an asymmetric design. The symbol of the New Kingdom of Adhomai is at its back."
	icon_state = "royalist_cloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	hoodtype = /obj/item/clothing/head/hood/tajaran/cloak/royalist

/obj/item/clothing/suit/storage/hooded/tajaran/cloak/fancy
	name = "Fancy adhomian cloak"
	desc = "A fancy black Adhomian cloak."
	icon_state = "hb_cloak"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	hoodtype = /obj/item/clothing/head/hood/tajaran/cloak/fancy

//Hoods
/obj/item/clothing/head/hood/tajaran/cloak
	name  = "Adhomian maroon cloak hood"
	desc = "A hood attached to a Maroon cloak"
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "maroon_cloakhood"
	item_state = "maroon_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/hood/tajaran/cloak/gruff
	name = "Gruff cloak hood"
	desc = "A hood attached to a Gruff cloak"
	desc = "A hood designated for the lowest classes of tajara."
	icon_state = "taj_cloakhood"
	item_state = "taj_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/hood/tajaran/surgery
	name = "Adhomian surgeon mask"
	desc = "A surgical mask attached to a surgeon garb."
	icon = 'icons/obj/clothing/species/tajaran/coats.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/coats.dmi'
	icon_state = "tajscrubs_hood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR
	species_restricted = list(SPECIES_TAJ)

/obj/item/clothing/head/hood/tajaran/cloak/amohda
	name = "Amohdan cloak hood"
	desc = "A hood attached to a Amohdan cloak"
	icon_state = "amohda_cloakhood"
	item_state = "amohda_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/hood/tajaran/cloak/winter
	name = "Adhomian winter cloak hood"
	desc = "A hood attached to a Winter cloak"
	icon_state = "winter_cloakhood"
	item_state = "winter_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = TN60C

/obj/item/clothing/head/hood/tajaran/cloak/royalist
	name = "Adhomian royalist cloak hood"
	desc = "A hood attached to a Roaylist cloak"
	icon_state = "royalist_cloakhood"
	item_state = "royalist_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR

/obj/item/clothing/head/hood/tajaran/cloak/fancy
	name = "Fancy adhomian cloak"
	desc = "A hood attached to a Fancy cloak"
	icon_state = "hb_cloakhood"
	item_state = "hb_cloakhood"
	body_cover_flags = HEAD
	inv_hide_flags = HIDEEARS|BLOCKHAIR

//Armor plates

/obj/item/clothing/suit/armor/tajaran/cuirass
	name = "Adhomian cuirass"
	desc = "A reinforced cuirass used by the forces of the new Kingdom of Adhomai."
	icon = 'icons/obj/clothing/species/tajaran/suits.dmi'
	icon_override = 'icons/mob/clothing/species/tajaran/suits.dmi'
	icon_state = "cuirass"
	item_state = "cuirass"
	armor_type = /datum/armor/general/medieval/light
