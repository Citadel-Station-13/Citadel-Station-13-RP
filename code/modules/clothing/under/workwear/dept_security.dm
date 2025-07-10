/**
 * Security department clothing
 */

//Prisoners are technically members of the security department.
/obj/item/clothing/under/color/prison
	name = "prison jumpsuit"
	desc = "It's standardized prisoner-wear. Its suit sensors are permanently set to the \"Tracking\" position."
	icon = 'icons/clothing/uniform/workwear/dept_security/prison.dmi'
	icon_state = "prison"
	has_sensors = UNIFORM_HAS_LOCKED_SENSORS
	sensor_mode = 3
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/color/prison/skirt
	name = "prison pleated skirt"
	icon = 'icons/clothing/uniform/workwear/dept_security/prison_skirt.dmi'
	icon_state = "prison_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Warden
 */

/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_security/warden.dmi'
	icon_state = "warden"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/warden/skirt
	name = "warden's jumpskirt"
	desc = "Standard feminine fashion for a Warden. It is made of sturdier material than standard jumpskirts. It has the word \"Warden\" written on the shoulders."
	icon = 'icons/clothing/uniform/workwear/dept_security/wardenf.dmi'
	icon_state = "wardenf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/warden_fem
	name = "warden's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	icon = 'icons/clothing/uniform/workwear/dept_security/warden_fem.dmi'
	icon_state = "warden_fem"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/warden/skirt_pleated
	name = "warden's pleated skirt"
	desc = "A pleated skirt made up of a slightly sturdier material than your average jumpsuit. It has the word 'Warden' writton on the shoulders."
	icon = 'icons/clothing/uniform/workwear/dept_security/rwarden_skirt.dmi'
	icon_state = "rwarden_skirt"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/warden/corp
	name = "warden's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection. It has the word \"Warden\" on the shoulders."
	armor_type = /datum/armor/station/padded
	icon = 'icons/clothing/uniform/workwear/dept_security/warden_corporate.dmi'
	icon_state = "warden_corporate"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/warden/corp_fem
	name = "warden's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection. It has the word \"Warden\" on the shoulders."
	icon = 'icons/clothing/uniform/workwear/dept_security/warden_corporate_fem.dmi'
	icon_state = "warden_corporate_fem"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon = 'icons/clothing/uniform/workwear/dept_security/wardenblueclothes.dmi'
	icon_state = "wardenblueclothes"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/warden/navyblue_fem
	name = "warden's uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	icon = 'icons/clothing/uniform/workwear/dept_security/wardenblueclothes_fem.dmi'
	icon_state = "wardenblueclothes_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Security
 */

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/security.dmi'
	icon_state = "security"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/security/skirt
	name = "security officer's jumpskirt"
	desc = "Standard feminine fashion for Security Officers.  It's made of sturdier material than the standard jumpskirts."
	icon = 'icons/clothing/uniform/workwear/dept_security/securityf.dmi'
	icon_state = "securityf"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/security_fem
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/security_fem.dmi'
	icon_state = "security_fem"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/security/skirt_pleated
	name = "security officer's pleated skirt"
	desc = "A pleated skirt made up of a slightly sturdier material than most jumpsuits, allowing more robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/sec_skirt.dmi'
	icon_state = "sec_skirt"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/security/turtleneck
	name = "security turtleneck"
	desc = "It's a stylish turtleneck made of a robust nanoweave. Nobody said the Law couldn't be fashionable."
	icon = 'icons/clothing/uniform/workwear/dept_security/turtle_sec.dmi'
	icon_state = "turtle_sec"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_TESHARI)

/obj/item/clothing/under/rank/security/turtleneck_fem
	name = "security turtleneck"
	desc = "It's a stylish turtleneckf made of a robust nanoweave. Nobody said the Law couldn't be fashionable."
	icon = 'icons/clothing/uniform/workwear/dept_security/turtle_sec_fem.dmi'
	icon_state = "turtle_sec_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_TESHARI)

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon = 'icons/clothing/uniform/workwear/dept_security/dispatch.dmi'
	icon_state = "dispatch"
	armor_type = /datum/armor/station/padded
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/redshirt2.dmi'
	icon_state = "redshirt2"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/security2_fem
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/redshirt2_fem.dmi'
	icon_state = "redshirt2_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/security/corp
	name = "security officer's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/sec_corporate.dmi'
	icon_state = "sec_corporate"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/security/corp_fem
	name = "security officer's corporate uniform"
	desc = "A corporate standard uniform made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/sec_corporate_fem.dmi'
	icon_state = "sec_corporate_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon = 'icons/clothing/uniform/workwear/dept_security/officerblueclothes.dmi'
	icon_state = "officerblueclothes"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/security/navyblue_fem
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon = 'icons/clothing/uniform/workwear/dept_security/officerblueclothes_fem.dmi'
	icon_state = "officerblueclothes_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon = 'icons/clothing/uniform/workwear/dept_security/swatunder.dmi'
	icon_state = "swatunder"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Detective
 */

/obj/item/clothing/under/det
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective.dmi'
	icon_state = "detective"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)

/obj/item/clothing/under/det_fem
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective_fem.dmi'
	icon_state = "detective_fem"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/det/grey
	name = "detective's tan suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective2.dmi'
	icon_state = "detective2"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)

/obj/item/clothing/under/det/grey_fem
	name = "detective's tan suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective2_fem.dmi'
	icon_state = "detective2_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/det/grey/skirt_pleated
	name = "detective's grey pleated skirt"
	desc = "A sertous-looking pleated skirt paired with a freshly-pressed white shirt and a gold-clipped tie."
	icon = 'icons/clothing/uniform/workwear/dept_security/greydet_skirt.dmi'
	icon_state = "greydet_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/det/black
	name = "detective's spiffy suit"
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective3.dmi'
	icon_state = "detective3"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/vest)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)

/obj/item/clothing/under/det/black_fem
	name = "detective's spiffy suit"
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective3_fem.dmi'
	icon_state = "detective3_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/vest)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/det/corporate
	name = "detective's corporate jumpsuit"
	desc = "A more modern uniform for corporate investigators."
	icon = 'icons/clothing/uniform/workwear/dept_security/det_corporate.dmi'
	icon_state = "det_corporate"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/det/corporate_fem
	name = "detective's corporate jumpsuit"
	desc = "A more modern uniform for coroprate investigators."
	icon = 'icons/clothing/uniform/workwear/dept_security/det_corporate_fem.dmi'
	icon_state = "det_corporate_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Reuses spritesheet
/obj/item/clothing/under/det/waistcoat
	name = "detective's semi-tidy suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie, faux-gold tie clip, and waistcoat."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective.dmi'
	icon_state = "detective"
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip, /obj/item/clothing/accessory/wcoat)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)

//Reuses spritesheet
/obj/item/clothing/under/det/waistcoat_fem
	name = "detective's semi-tidy suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie, faux-gold tie clip, and waistcoat."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective_fem.dmi'
	icon_state = "detective_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/blue_clip, /obj/item/clothing/accessory/wcoat)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Reuses spritesheet
/obj/item/clothing/under/det/grey/waistcoat
	name = "detective's serious suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, complete with a red striped tie and waistcoat."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective2.dmi'
	icon_state = "detective2"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/wcoat)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)

//Reuses spritesheet
/obj/item/clothing/under/det/grey/waistcoat_fem
	name = "detective's serious suit"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, complete with a red striped tie and waistcoat."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective2_fem.dmi'
	icon_state = "detective2_fem"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red_long, /obj/item/clothing/accessory/wcoat)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/det/skirt
	name = "detective's skirt"
	desc = "A serious-looking white blouse paired with a formal black pencil skirt."
	icon = 'icons/clothing/uniform/workwear/dept_security/detective_skirt.dmi'
	icon_state = "detective_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_security/hos.dmi'
	icon_state = "hos"
	armor_type = /datum/armor/station/padded
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/head_of_security/skirt
	name = "head of security's jumpskirt"
	desc = "It's a fashionable jumpskirt worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	icon = 'icons/clothing/uniform/workwear/dept_security/hosf.dmi'
	icon_state = "hosf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/head_of_security_fem
	name = "head of security's jumpsuit"
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armour to protect the wearer."
	icon = 'icons/clothing/uniform/workwear/dept_security/hos_fem.dmi'
	icon_state = "hos_fem"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/head_of_security/skirt_pleated
	name = "head of security's pleated skirt"
	desc = "A pleated skirt worn by those few with the dedication to achieve the position of 'Head of Security'. It bears additional armour to protect the wearer."
	icon = 'icons/clothing/uniform/workwear/dept_security/rhos_skirt.dmi'
	icon_state = "rhos_skirt"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/head_of_security/skirt_pleated/alt
	name = "dark head of security's pleated skirt"
	desc = "A pleated skirt worn by those few with the dedication to achieve the position of 'Head of Security'. It bears additional armour to protect the wearer."
	icon = 'icons/clothing/uniform/workwear/dept_security/hosalt_skirt.dmi'
	icon_state = "hosalt_skirt"
	armor_type = /datum/armor/station/padded
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_TESHARI)

/obj/item/clothing/under/rank/head_of_security/corp
	name = "head of security's corporate jumpsuit"
	desc = "A clean jumpsuit to corporate standard, worn by those few with the dedication to achieve the position of \"Head of Security\"."
	icon = 'icons/clothing/uniform/workwear/dept_security/hos_corporate.dmi'
	icon_state = "hos_corporate"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/head_of_security/corp_fem
	name = "head of security's corporate jumpsuit"
	desc = "A clean jumpsuit to corporate standard, worn by those few with the dedication to achieve the position of \"Head of Security\""
	icon = 'icons/clothing/uniform/workwear/dept_security/hos_corporate_fem.dmi'
	icon_state = "hos_corporate_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/head_of_security/turtleneck
	name = "head of security's turtleneck"
	desc = "A stylish alternative to the normal head of security jumpsuit, complete with tactical pants."
	icon = 'icons/clothing/uniform/workwear/dept_security/hosturtle.dmi'
	icon_state = "hosturtle"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_security/jensen.dmi'
	icon_state = "jensen"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon = 'icons/clothing/uniform/workwear/dept_security/hosblueclothes.dmi'
	icon_state = "hosblueclothes"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/head_of_security/navyblue_fem
	name = "head of security's uniform"
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	icon = 'icons/clothing/uniform/workwear/dept_security/hosblueclothes_fem.dmi'
	icon_state = "hosblueclothes_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/hosformalmale
	name = "head of security's formal uniform"
	desc = "A male head of security's formal-wear, for special occasions."
	icon = 'icons/clothing/uniform/workwear/dept_security/hos_formal_male.dmi'
	icon_state = "hos_formal_male"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/hosformalfem
	name = "head of security's formal uniform"
	desc = "A female head of security's formal-wear, for special occasions."
	icon = 'icons/clothing/uniform/workwear/dept_security/hos_formal_fem.dmi'
	icon_state = "hos_formal_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
