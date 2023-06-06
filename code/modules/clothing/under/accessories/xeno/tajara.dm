//Do not question I am not fixing ALL THE ICONS it works just leave it!

/obj/item/clothing/accessory/tajaran
	icon = 'icons/mob/clothing/species/tajaran/ties.dmi'
	icon_override = 'icons/obj/clothing/species/tajaran/ties.dmi'

//Scarves
/obj/item/clothing/accessory/tajaran/scarf
	name = "brown fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is brown."
	icon_state = "furscarf_brown"
	item_state = "furscarf_brown"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/tajaran/scarf/lbrown
	name = "light brown fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is light brown."
	icon_state = "furscarf_lbrown"
	item_state = "furscarf_lbrown"

/obj/item/clothing/accessory/tajaran/scarf/cinnamon
	desc = "A furred scarf, a common tajaran vanity item, this one is cinnamon."
	name = "cinnamon fur scarf"
	icon_state = "furscarf_cinnamon"
	item_state = "furscarf_cinnamon"

/obj/item/clothing/accessory/tajaran/scarf/blue
	desc = "A furred scarf, a common tajaran vanity item, this one is blue."
	name = "blue fur scarf"
	icon_state = "furscarf_blue"
	item_state = "furscarf_blue"

/obj/item/clothing/accessory/tajaran/scarf/silver
	name = "silver fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is silver."
	icon_state = "furscarf_silver"
	item_state = "furscarf_silver"

/obj/item/clothing/accessory/tajaran/scarf/black
	name = "black fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is black."
	icon_state = "furscarf_black"
	item_state = "furscarf_black"

/obj/item/clothing/accessory/tajaran/scarf/ruddy
	name = "ruddy fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is ruddy."
	icon_state = "furscarf_ruddy"
	item_state = "furscarf_ruddy"

/obj/item/clothing/accessory/tajaran/scarf/orange
	name = "orange fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is orange."
	icon_state = "furscarf_lasaga"
	item_state = "furscarf_lasaga"

/obj/item/clothing/accessory/tajaran/scarf/cream
	name = "cream fur scarf"
	desc = "A furred scarf, a common tajaran vanity item, this one is cream."
	icon_state = "furscarf_cream"
	item_state = "furscarf_cream"

/obj/item/clothing/accessory/tajaran/summershirt
	name = "adhomian summerwear shirt"
	desc = "A simple piece of adhomian summerwear made with linen."
	icon_state = "summer-shirt"
	item_state = "summer-shirt"

/obj/item/clothing/accessory/tajaran_wrap
	name = "male marriage wrap"
	desc = "A holy cloth wrap that signifies marriage amongst tajara, it has white and gold markings. This one is meant for the husband."
	icon = 'icons/mob/clothing/species/tajaran/ties.dmi'
	icon_override = 'icons/obj/clothing/species/tajaran/ties.dmi'
	icon_state = "wrap_male"
	item_state = "wrap_male"

/obj/item/clothing/accessory/tajaran_wrap/female
	name = "female marriage wrap"
	desc = "A holy cloth wrap that signifies marriage amongst tajara, it has blue and light blue markings. This one is meant for the wife."
	icon_state = "wrap_female"
	item_state = "wrap_female"

//Cloaks
//No sprites for tesh and vox. No I'm not spriting them
/obj/item/clothing/accessory/tponcho/tajarancloak
	name = "Adhomian common cloak"
	desc = "A tajaran cloak made with the middle class in mind, fancy but nothing special."
	icon = 'icons/mob/clothing/species/tajaran/ties.dmi'
	icon_override = 'icons/obj/clothing/species/tajaran/ties.dmi'
	icon_state = "taj_commoncloak"
	item_state = "taj_commoncloak"
	var/fire_resist = T0C+100
	allowed = list(/obj/item/tank/emergency/oxygen)
	armor_type = /datum/armor/none
	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.9
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/tponcho/tajarancloak/fancy
	name = "Adhomian fancy cloak"
	desc = "A cloak fashioned from the best materials, meant for tajara of high standing."
	icon_state = "taj_fancycloak"
	item_state = "taj_fancycloak"

/obj/item/clothing/accessory/tponcho/tajarancloak/maroon
	name = "Adhomian maroon cloak"
	desc = "A simple maroon colored Adhomian cloak."
	icon_state = "maroon_cloak"
	item_state = "maroon_cloak"

/obj/item/clothing/accessory/tponcho/tajarancloak/amohda
	name = "Amohdan cloak"
	desc = "Originally used by the Amohdan swordsmen before the First Revolution, this cloak is now commonly worn by the island population."
	icon_state = "amohda_cloak"
	item_state = "amohda_cloak"

/obj/item/clothing/accessory/tponcho/tajarancloak/winter
	name = "Adhomian winter cloak"
	desc = "A simple wool cloak used during the early days of the lesser winter."
	icon_state = "winter_cloak"
	item_state = "winter_cloak"

/obj/item/clothing/accessory/tponcho/tajarancloak/royalist
	name = "Adhomian royalist cloak"
	desc = "An Adhomian cloak with an asymmetric design. The symbol of the New Kingdom of Adhomai is at its back."
	icon_state = "royalist_cloak"
	item_state = "royalist_cloak"

/obj/item/clothing/accessory/tponcho/tajarancloak/fancy
	name = "Fancy adhomian cloak"
	desc = "A fancy black Adhomian cloak."
	icon_state = "hb_cloak"
	item_state = "hb_cloak"

//Has issues

/obj/item/clothing/accessory/tajaran/nka_waistcoat
	name = "noble adhomian waistcoat"
	desc = "A fancy waistcoat worn by the New Kingdom's nobility. Likely a hand-me-down."
	icon_state = "nka_waistcoat"
	item_state = "nka_waistcoat"

/obj/item/clothing/accessory/tajaran/nka_vest
	name = "noble adhomian vest"
	desc = "A fancy vest worn by the New Kingdom's nobility. Likely a hand-me-down."
	icon_state = "nka_vest"
	item_state = "nka_vest"
