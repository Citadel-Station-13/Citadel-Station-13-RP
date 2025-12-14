/**
 * Leftovers of the HoP and Pilots. Everything else has a different file in the dept_civilian folder. This department is broken up because its not a traditional single purpose department. IAA may be clowns but they dont wear Clown outfits.
 */

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_civilian/hop.dmi'
	icon_state = "hop"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/head_of_personnel/skirt_pleated
	name = "head of personnel's pleated skirt"
	desc = "A semi formal uniform given only to Heads of Personnel."
	icon = 'icons/clothing/uniform/workwear/dept_civilian/hop_skirt.dmi'
	icon_state = "hop_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/head_of_personnel_whimsy
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	name = "head of personnel's suit"
	icon = 'icons/clothing/uniform/workwear/dept_civilian/hopwhimsy.dmi'
	icon_state = "hopwhimsy"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style conscious HoP."
	icon = 'icons/clothing/uniform/workwear/dept_civilian/dress_hop.dmi'
	icon_state = "dress_hop"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_hr
	name = "human resources director uniform"
	desc = "Superior class for the nosy H.R. Director."
	icon = 'icons/clothing/uniform/workwear/dept_civilian/huresource.dmi'
	icon_state = "huresource"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon = 'icons/clothing/uniform/workwear/dept_civilian/teal_suit.dmi'
	icon_state = "teal_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit/skirt
	name = "head of personnel's skirt suit"
	icon = 'icons/clothing/uniform/workwear/dept_civilian/teal_suit_skirt.dmi'
	icon_state = "teal_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Pilots
/obj/item/clothing/under/rank/pilot1
	name = "\improper Nanotrasen flight suit"
	desc = "A blue and grey Nanotrasen flight suit. Warm and practical, it feels cozy."
	icon = 'icons/clothing/uniform/workwear/dept_civilian/flight1.dmi'
	icon_state = "flight1"
	starting_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/pilot2
	name = "\improper Nanotrasen flight suit"
	desc = "A dark blue Nanotrasen flight suit. Warm and practical, several patches are scattered across it."
	icon = 'icons/clothing/uniform/workwear/dept_civilian/flight2.dmi'
	icon_state = "flight2"
	starting_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot2)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
