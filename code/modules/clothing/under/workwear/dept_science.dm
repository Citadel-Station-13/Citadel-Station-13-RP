/**
 * Science department clothing
 * Medsci is dead! Long live Science!
 */

/**
 * Research Director
 */

/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/director.dmi'
	icon_state = "director"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/research_director/skirt_pleated
	name = "research director's pleated skirt"
	desc = "Feminine fashion for the style conscious RD. Its fabric provides minor protection from biological contaminants, and its pleated skirt provides extra style points."
	icon = 'icons/clothing/uniform/workwear/dept_science/director_skirt.dmi'
	icon_state = "director_skirt"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/research_director/skirt_pleated/whimsical
	name = "whimsical research director's pleated skirt"
	desc = "Whimsical attire for the more magical of RD's, providing minor protection from biological contaminants like it's nothing."
	icon = 'icons/clothing/uniform/workwear/dept_science/rdwhimsy_skirt.dmi'
	icon_state = "rdwhimsy_skirt"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/research_director/skirt_pleated/turtleneck
	name = "research director's turtleneck pleated skirt"
	desc = "A dark purple purple turtleneck and a pleated tan skirt, for a director of superior authority."
	icon = 'icons/clothing/uniform/workwear/dept_science/rdturtle_skirt.dmi'
	icon_state = "rdturtle_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon = 'icons/clothing/uniform/workwear/dept_science/rdalt.dmi'
	icon_state = "rdalt"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/research_director/dress_rd
	name = "research director dress uniform"
	desc = "Feminine fashion for the style conscious RD. Its fabric provides minor protection from biological contaminants."
	icon = 'icons/clothing/uniform/workwear/dept_science/dress_rd.dmi'
	icon_state = "dress_rd"
	armor_type = /datum/armor/science/jumpsuit
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/research_director/turtleneck
	desc = "A dark purple turtleneck and tan khakis, for a director with a superior sense of style."
	name = "research director's turtleneck"
	icon = 'icons/clothing/uniform/workwear/dept_science/rdturtle.dmi'
	icon_state = "rdturtle"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/**
 * Scientist
 */

/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/science.dmi'
	icon_state = "science"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/scientist/jeans
	name = "scientist's jumpjeans"
	desc = "The perfect getup for the more laid-back researcher. Sadly, it doesn't seem to be as protective as its jumpsuit counterpart."
	icon = 'icons/clothing/uniform/workwear/dept_science/sciencej.dmi'
	icon_state = "sciencej"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/scientist/femjeans
	name = "scientist's jumpjeans"
	desc = "The perfect getup for the more laid-back researcher. Sadly, it doesn't seem to be as protective as it's jumpsuit counterpart"
	icon = 'icons/clothing/uniform/workwear/dept_science/sciencejf.dmi'
	icon_state = "sciencejf"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/scientist/skirt
	name = "scientist's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_science/sciencef.dmi'
	icon_state = "sciencef"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/scientist_new
	desc = "Made of a special fiber that gives special protection against biohazards and small explosions."
	name = "scientist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/scientist_new.dmi'
	icon_state = "scientist_new"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/scientist/skirt_pleated
	name = "scientist's pleated skirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. Appropriately placed markings on the shoulders and pleated skirt denote the wearer as a scientist."
	icon = 'icons/clothing/uniform/workwear/dept_science/toxins_skirt.dmi'
	icon_state = "toxins_skirt"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/scientist/turtleneck
	name = "science turtleneck"
	desc = "It's a stylish turtleneck weaved with an explosive-resistant, comfortable mesh. You don't have to look like a dork to be a dork."
	icon = 'icons/clothing/uniform/workwear/dept_science/turtle_sci.dmi'
	icon_state = "turtle_sci"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/scientist/turtleneck_fem
	name = "science turtleneck"
	desc = "It's a stylish turtleneck weaved with an explosive-resistant, comfortable mesh. You don't have to look like a dork to be a dork."
	icon = 'icons/clothing/uniform/workwear/dept_science/turtle_sci_fem.dmi'
	icon_state = "turtle_sci_fem"
	armor_type = /datum/armor/science/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Roboticist
 */

/obj/item/clothing/under/rank/roboticist
	desc = "It's a slimming black jumpsuit with reinforced seams; great for industrial work."
	name = "roboticist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/robotics.dmi'
	icon_state = "robotics"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/roboticist/alt
	desc = "It's a slimming black jumpsuit with reinforced seams and a gold trim; great for industrial work."
	name = "roboticist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/robotics2.dmi'
	icon_state = "robotics2"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/roboticist/skirt
	desc = "It's a slimming black jumpskirt with reinforced seams; great for industrial work."
	name = "roboticist's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_science/roboticsf.dmi'
	icon_state = "roboticsf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/roboticist/skirt_pleated
	name = "roboticist's pleated skirt"
	desc = "It's a slimming black pleated skirt with reinforced seams for a more active industrial workplace."
	icon = 'icons/clothing/uniform/workwear/dept_science/robotics_skirt.dmi'
	icon_state = "robotics_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Explorer
 */

/obj/item/clothing/under/explorer
	desc = "A green uniform for operating in hazardous environments."
	name = "explorer's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/explorer.dmi'
	icon_state = "explorer"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/explorer_fem
	desc = "A green uniform for operating in hazardous environments."
	name = "explorer's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_science/explorer_fem.dmi'
	icon_state = "explorer_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
