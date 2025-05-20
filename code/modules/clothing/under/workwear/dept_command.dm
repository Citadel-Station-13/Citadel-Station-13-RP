/**
 * The captain and bridge crew. This is NOT for department heads put them in their own department file.
 */

/**
 * Captain uniforms
 */

/obj/item/clothing/under/rank/captain
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Facility Director\"."
	name = "Facility Director's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_command/captain.dmi'
	icon_state = "captain"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/captain/skirt_pleated
	name = "captain's pleated skirt"
	icon = 'icons/clothing/uniform/workwear/dept_command/captain_skirt.dmi'
	icon_state = "captain_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/captainformal
	name = "Facility Director's formal uniform"
	desc = "A Facility Director's formal-wear, for special occasions."
	icon = 'icons/clothing/uniform/workwear/dept_command/captain_formal.dmi'
	icon_state = "captain_formal"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/dress/dress_cap
	name = "Facility Director's dress uniform"
	desc = "Feminine fashion for the style conscious Facility Director."
	icon = 'icons/clothing/uniform/workwear/dept_command/dress_cap.dmi'
	icon_state = "dress_cap"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "Facility Director's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon = 'icons/clothing/uniform/workwear/dept_command/green_suit.dmi'
	icon_state = "green_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gimmick/rank/captain/suit/skirt
	name = "Facility Director's skirt suit"
	icon = 'icons/clothing/uniform/workwear/dept_command/green_suit_skirt.dmi'
	icon_state = "green_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Bridge Officer uniforms
 */
/obj/item/clothing/under/bridgeofficer
	name = "bridge officer uniform"
	desc = "A jumpsuit for those ranked high enough to stand at the bridge, but not high enough to touch any buttons."
	icon = 'icons/clothing/uniform/workwear/dept_command/bridgeofficer.dmi'
	icon_state = "bridgeofficer"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/bridgeofficerskirt
	name = "bridge officer skirt"
	desc = "A jumpskirt for those ranked high enough to stand at the bridge, but not high enough to touch any buttons."
	icon = 'icons/clothing/uniform/workwear/dept_command/bridgeofficerskirt.dmi'
	icon_state = "bridgeofficerskirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
