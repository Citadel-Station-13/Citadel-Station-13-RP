/**
 * Engineering department workwear
 */

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/hazard.dmi'
	icon_state = "hazard"
	siemens_coefficient = 0.8
	armor_type = /datum/armor/engineering/jumpsuit
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/engineer/skirt
	desc = "It's an orange high visibility jumpskirt worn by engineers. It has minor radiation shielding."
	name = "engineer's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/enginef.dmi'
	icon_state = "enginef"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chief_engineer/skirt
	desc = "It's a high visibility jumpskirt given to those engineers insane enough to achieve the rank of \"Chief engineer\". It has minor radiation shielding."
	name = "chief engineer's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/chieff.dmi'
	icon_state = "chieff"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/atmospheric_technician/skirt
	desc = "It's a jumpskirt worn by atmospheric technicians."
	name = "atmospheric technician's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/atmosf.dmi'
	icon_state = "atmosf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chief_engineer
	desc = "It's a high visibility jumpsuit given to those engineers insane enough to achieve the rank of \"Chief engineer\". It has minor radiation shielding."
	name = "chief engineer's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/chief.dmi'
	icon_state = "chief"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/chief_engineer/jeans
	name = "chief engineer's jumpjeans"
	desc = "Casual jeans and a high visibility top given to those more insane than those with the average CE jumpsuit. It bears minor radiation shielding."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/chiefj.dmi'
	icon_state = "chiefj"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chief_engineer/fem_jeans
	name = "chief engineer's jumpjeans"
	desc = "Casual jeans and a high visibility top given to those more insane than those with the average CE jumpsuit. It bears minor radiation shielding."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/chiefjf.dmi'
	icon_state = "chiefjf"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chief_engineer/skirt_pleated
	name = "chief engineer's pleated skirt"
	desc = "It's a high visibility pleated skirt given to those insane enough to achieve the rank of 'Chief Engineer'. It comes with minor rediation shielding."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/chiefengineer_skirt.dmi'
	icon_state = "chiefengineer_skirt"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/atmospheric_technician
	desc = "It's a jumpsuit worn by atmospheric technicians."
	name = "atmospheric technician's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/atmos.dmi'
	icon_state = "atmos"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/atmospheric_technician/jeans
	name = "atmospheric technician's jumpjeans"
	desc = "Casual jeans worn by atmospherics technicians"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/atmosj.dmi'
	icon_state = "atmosj"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/atmospheric_technician/fem_jeans
	name = "atmospheric technician's jumpjeans"
	desc = "Casual jeans worn by atmospherics technicians"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/atmosjf.dmi'
	icon_state = "atmosjf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/atmospheric_technician/skirt_pleated
	name = "atmospheric technician's pleated skirt"
	desc = "A pleated skirt occassionally work by atmospheric technicians. Nothing too fancy, but it gets the job done."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/atmos_skirt.dmi'
	icon_state = "atmos_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/engineer
	desc = "It's an orange high visibility jumpsuit worn by engineers. It has minor radiation shielding."
	name = "engineer's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_engineering/engine.dmi'
	icon_state = "engine"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/engineer/jeans
	name = "engineer's jumpjeans"
	desc = "Casual jeans and a sturdy shirt make for minor radiation shielding. The shirt has orange bands around the forearm, showing the wearer's an engineer."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/enginej.dmi'
	icon_state = "enginej"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/engineer/fem_jeans
	name = "engineer's jumpjeans"
	desc = "Casual jeans and a sturdy shirt make for minor radiation shielding. The shirt is high visibility, showing the wearer's an engineer."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/enginejf.dmi'
	icon_state = "enginejf"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/engineer/skirt_pleated
	name = "engineer's pleated skirt"
	desc = "It's a high visibility pleated skirt worn by some engineers. It has minor radiation shielding."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/engine_skirt.dmi'
	icon_state = "engine_skirt"
	armor_type = /datum/armor/engineering/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/engineer/turtleneck
	name = "engineering turtleneck"
	desc = "It's a stylish turtleneck with minor radiation shielding. Nobody's going to see it behind the voidsuit, though."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/turtle_eng.dmi'
	icon_state = "turtle_eng"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/engineer/turtleneck_fem
	name = "engineering turtleneck"
	desc = "It's a stylish turtleneck with minor radiation shielding. Nobody's going to see it behind the voidsuit, thought."
	icon = 'icons/clothing/uniform/workwear/dept_engineering/turtle_eng_fem.dmi'
	icon_state = "turtle_eng_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
