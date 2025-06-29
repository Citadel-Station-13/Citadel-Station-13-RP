/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file (Except for glasses, shoes, and masks.)
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"
*/
/* TEMPLATE
//ckey:Character Name
/obj/item/clothing/type/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "myicon"

*/
//Natje: Awen Henry
/obj/item/clothing/head/fluff/wolfgirl
    name = "Wolfgirl Hat"
    desc = "An odd, small hat with two strings attached to it."

    icon_state = "wolfgirlhat"
    icon = 'icons/vore/custom_clothes_vr.dmi'
    icon_override = 'icons/vore/custom_onmob_vr.dmi'

//Natje: Awen Henry
/obj/item/clothing/shoes/fluff/wolfgirl
    name = "Red Sandals"
    desc = "A pair of sandals that make you want to awoo!"

    icon_state = "wolfgirlsandals"
    icon = 'icons/vore/custom_clothes_vr.dmi'
    icon_override = 'icons/vore/custom_onmob_vr.dmi'

//! ## For general use
/obj/item/clothing/accessory/fluff/smilepin
	name = "Smiley Pin"
	desc = "A pin with a stupid grin on its face"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "smilepin"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	overlay_state = "" //They don't have one

/obj/item/clothing/accessory/fluff/heartpin
	name = "Love Pin"
	desc = "A cute heart pin."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "heartpin"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	overlay_state = "" //They don't have one


//! ## Event Costumes Below

/obj/item/clothing/head/helmet/fluff/freddy
	name = "Animatronic Suit Helmet"
	desc = "Votre toast, je peux vous le rendre."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "freddyhead"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "freddyhead_mob"
	permeability_coefficient = 0.01
	armor_type = /datum/armor/none
	inv_hide_flags = HIDEMASK|HIDEEARS
	cold_protection_cover = HEAD
	siemens_coefficient = 0.9

//Bonnie Head
/obj/item/clothing/head/helmet/fluff/freddy/bonnie
	desc = "Children's entertainer."
	icon_state = "bonniehead"
	item_state = "bonniehead_mob"

//Foxy Head
/obj/item/clothing/head/helmet/fluff/freddy/foxy
	desc = "I guess he doesn't like being watched."
	icon_state = "foxyhead"
	item_state = "foxyhead_mob"

//Chica Head
/obj/item/clothing/head/helmet/fluff/freddy/chica
	desc = "<b><font color=red>LET'S EAT!</font></b>"
	icon_state = "chicahead"
	item_state = "chicahead_mob"

//! ## Anamatronic Suits
/obj/item/clothing/suit/fluff/freddy
	name = "Animatronic Suit"
	desc = "Votre toast, je peux vous le rendre."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "freddysuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "freddysuit_mob"

	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight,/obj/item/tank)
	armor_type = /datum/armor/none
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	siemens_coefficient = 0.9

//Bonnie Suit
/obj/item/clothing/suit/fluff/freddy/bonnie
	desc = "Children's entertainer."
	icon_state = "bonniesuit"
	item_state = "bonniesuit_mob"

//Foxy Suit
/obj/item/clothing/suit/fluff/freddy/foxy
	desc = "I guess he doesn't like being watched."
	icon_state = "foxysuit"
	item_state = "foxysuit_mob"


//Chica Suit
/obj/item/clothing/suit/fluff/freddy/chica
	desc = "<b><font color=red>LET'S EAT!</font></b>"
	icon_state = "chicasuit"
	item_state = "chicasuit_mob"

//HOS Hardsuit
/obj/item/clothing/suit/space/void/security/fluff/hos // ToDo: Rig version.
	name = "\improper prototype voidsuit"
	desc = "A customized security voidsuit made to match the Head of Security's obession with black. Has additional composite armor."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "rig-hos"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "rig-hos_mob"

	species_restricted = null

//HOS Hardsuit Helmet
/obj/item/clothing/head/helmet/space/void/security/fluff/hos // ToDo: Rig version.
	name = "\improper prototype voidsuit helmet"
	desc = "A customized security voidsuit helmet customized to include the Head of Security's signature hat. Has additional composite armor."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "rig0-hos"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "rig0-hos_mob"
	armor_type = /datum/armor/security/hos
	species_restricted = null

/obj/item/storage/belt/utility/fluff/vulpine
	name = "vulpine belt"
	desc = "A tool-belt in Atmos colours."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "vulpine_belt"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "vulpine_belt_mob"

	max_items = 9

/obj/item/storage/belt/utility/fluff/vulpine/legacy_spawn_contents()
	. = ..()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/stack/cable_coil(src, 30, null, "red")

/obj/item/clothing/shoes/black/cuffs
	name = "gilded leg wraps"
	desc = "Ankle coverings for digitigrade creatures. Gilded!"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "gildedcuffs"

	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	item_icons = list()

	body_cover_flags = 0

/obj/item/clothing/shoes/black/cuffs/red
	name = "red leg wraps"
	desc = "Ankle coverings for digitigrade creatures. Red!"
	icon_state = "redcuffs"

/obj/item/clothing/shoes/black/cuffs/blue
	name = "blue leg wraps"
	desc = "Ankle coverings for digitigrade creatures. Blue!"
	icon_state = "bluecuffs"

//DS9

/obj/item/clothing/suit/storage/trek/ds9
	name = "Padded Overcoat"
	desc = "The overcoat worn by all officers of the 2380s."
	icon_state = "trek_ds9_coat"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "trek_ds9_coat_mob"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.50
	allowed = list(
		/obj/item/flashlight, /obj/item/atmos_analyzer,
		/obj/item/radio, /obj/item/tank/emergency/oxygen,
		/obj/item/reagent_containers/hypospray, /obj/item/healthanalyzer,
		/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle
		)
	armor_type = /datum/armor/security/light_formalwear

/obj/item/clothing/suit/storage/trek/ds9/equipped(mob/user, slot, flags)
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		if(H.species.get_species_id() == SPECIES_ID_VOX)
			icon_override = 'icons/mob/clothing/species/vox/suits.dmi'
		else
			icon_override = 'icons/vore/custom_clothes_vr.dmi'
	update_worn_icon()

/obj/item/clothing/suit/storage/trek/ds9/admiral // Only for adminuz
	name = "Admiral Overcoat"
	desc = "Admirality specialty coat to keep flag officers fashionable and protected."
	icon_state = "trek_ds9_coat_adm"
	item_state = "trek_ds9_coat_adm_mob"
	armor_type = /datum/armor/security/hos

//For general use maybe
/obj/item/clothing/suit/storage/hooded/wintercoat/jessie
	name = "Handmade Winter Suit"
	desc = "A durable, but somewhat ragged lower portion of a snow suit fitted for a wolftaur."
	icon = 'icons/mob/clothing/taursuits_wolf.dmi'
	icon_state = "jessiecoat"
	item_state = "jessiecoat"

//Jackets For General Use. Sprited by Joji.
/obj/item/clothing/suit/storage/fluff/jacket //Not the toggle version since it uses custom toggle code to update the on-mob icon.
	name = "Field Jacket"
	desc = "A standard Earth military field jacket made of comfortable cotton."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "fjacket"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "fjacket_mob"
	var/unbuttoned = 0

/obj/item/clothing/suit/storage/fluff/jacket/verb/toggle()
	set name = "Toggle coat buttons"
	set category = VERB_CATEGORY_OBJECT
	set src in usr

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return 0

	switch(unbuttoned)
		if(0)
			icon_state = "[initial(icon_state)]_open"
			item_state = "[initial(item_state)]_open"
			unbuttoned = 1
			to_chat(usr, "You unbutton the coat.")
		if(1)
			icon_state = "[initial(icon_state)]"
			item_state = "[initial(item_state)]"
			unbuttoned = 0
			to_chat(usr, "You button up the coat.")
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/fluff/jacket/field //Just here so it can be seen and easily recognized under /spawn.
	name = "Field Jacket"

/obj/item/clothing/suit/storage/fluff/jacket/air_cavalry
	name = "Air Cavalry Jacket"
	desc = "A jacket worn by the 1st Cavalry Division on Earth."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "acjacket"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "acjacket_mob"

/obj/item/clothing/suit/storage/fluff/jacket/air_force
	name = "Air Force Jacket"
	desc = "A jacket worn by the Earth Air Force."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "afjacket"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "afjacket_mob"

/obj/item/clothing/suit/storage/fluff/jacket/navy
	name = "Navy Jacket"
	desc = "A jacket worn by the Earth's Navy. It's adorned with reflective straps."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "navyjacket"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "navyjacket_mob"

/obj/item/clothing/suit/storage/fluff/jacket/special_forces
	name = "Special Forces Jacket"
	desc = "A durable jacket worn by the Earth's special forces."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "sfjacket"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "sfjacket_mob"

//General use
/obj/item/clothing/head/fluff/headbando
	name = "basic headband"
	desc = "Perfect for martial artists, sweaty rogue operators, and tunnel gangsters."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "headbando"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "headbando"

/obj/item/clothing/suit/storage/fluff/gntop
	name = "GN crop jacket"
	desc = "A nifty little jacket. At least it keeps your shoulders warm."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "gntop"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "gntop"

//General use
/obj/item/clothing/suit/storage/fluff/loincloth
	name = "Loincloth"
	desc = "A primitive piece of oak-brown clothing wrapped firmly around the waist. A few bones line the edges. Comes with a primitive outfit to boot."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "loincloth"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "loincloth"

//Aztectornado:Tron inspired Siren outfit
/obj/item/clothing/gloves/fluff/siren
	name = "Siren Gloves"
	desc = "A set of white and neon blue gloves."
	description_fluff = "Like its jumpsuit companion, the Ward Takahashi Siren gloves feature multiple sensors for usage in augmented reality. The gloves operate fine even without a paired jumpsuit, offering optimal AR menu control and haptic feedback."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "tronsiren_gloves"
	item_state = "tronsiren_gloves_mob"

/obj/item/clothing/shoes/boots/fluff/siren
	name = "Siren Boots"
	desc = "A set of white boots with neon lighting."
	description_fluff = "Unlike the rest of the Ward Takahashi Siren lineup, the boots are simply boots. However, they go great with the rest of the outfit, and are quite comfortable."

	icon_state = "tronsiren_shoes"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_onmob_vr.dmi'

//Mewchild: Phi Vietsi
/obj/item/clothing/gloves/ring/seal/signet/fluff/vietsi
	name = "Phi Vietsi's Bone Signet Ring"
	desc = "A signet ring belonging to Phi Vietsi, carved from the bones of something long extinct, as a ward against bad luck."
	var/signet_name = "Phi Vietsi"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "vietsi_ring"

/obj/item/clothing/gloves/ring/seal/signet/fluff/vietsi/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s Bone Signet Ring"
	desc = "A signet ring belonging to [signet_name], carved from the bones of something long extinct, as a ward against bad luck."

//Heroman3003:Lauren Zackson
/obj/item/clothing/accessory/collar/fluff/goldenstring
	name = "golden string"
	desc = "It appears to just be a length of gold-colored string attached to a simple plastic clasp, meant to be worn around the neck"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	icon_state = "goldenstring"
	item_state = "goldenstring"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_TIE
