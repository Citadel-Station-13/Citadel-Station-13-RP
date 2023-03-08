//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	siemens_coefficient = 0.9
	atom_flags = PHORONGUARD
	clothing_flags = THICKMATERIAL | ALLOW_SURVIVALFOOD

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	slowdown = 1.0
	allowed = list(/obj/item/tank/emergency/oxygen,/obj/item/pen,/obj/item/flashlight/pen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 0.9
	atom_flags = PHORONGUARD
	clothing_flags = THICKMATERIAL

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bio", SLOT_ID_LEFT_HAND = "bio")
	body_cover_flags = HEAD|FACE|EYES

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bio", SLOT_ID_LEFT_HAND = "bio")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security
	icon_state = "bio_security"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

//CMO's biosuit, blue stripe
/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "Plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bio", SLOT_ID_LEFT_HAND = "bio")
	inv_hide_flags = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

//Beekeeping Suit seems like it would belong here.
/obj/item/clothing/head/beekeeper
	name = "beekeeping hood"
	icon_state = "beekeeper"
	desc = "A wide brimmed hat with a mesh screen that protects the face from stinging insects."
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 0)
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_cover_flags = HEAD|FACE|EYES
	siemens_coefficient = 0.9
	atom_flags = PHORONGUARD
	clothing_flags = THICKMATERIAL | ALLOW_SURVIVALFOOD

/obj/item/clothing/suit/beekeeper
	name = "beekeeping suit"
	desc = "A thick suit that protects against stinging insects."
	icon_state = "beekeeper"
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	slowdown = 1.0
	allowed = list(/obj/item/tank/emergency/oxygen,/obj/item/pen,/obj/item/flashlight/pen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 0.9
	atom_flags = PHORONGUARD
	clothing_flags = THICKMATERIAL
