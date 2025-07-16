/**
 * Medical department clothing
 * Medsci is dead! Long live Medical!
 */

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon = 'icons/clothing/uniform/workwear/dept_medical/sterile.dmi'
	icon_state = "sterile"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "white"

/obj/item/clothing/under/medigown
	name = "medical gown"
	desc = "A flimsy examination gown, the back ties never close."
	icon = 'icons/clothing/uniform/workwear/dept_medical/medicalgown.dmi'
	icon_state = "medicalgown"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/**
 * Chemist
 */

/obj/item/clothing/under/rank/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	name = "chemist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/chemistry.dmi'
	icon_state = "chemistry"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/chemist/skirt
	name = "chemist's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_medical/chemistryf.dmi'
	icon_state = "chemistryf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chemist/jeans
	name = "chemist's jumpjeans"
	desc = "Casual jeans and a coloured top with special protection against biohazards. It has chemist rank striping on the shoulders."
	icon = 'icons/clothing/uniform/workwear/dept_medical/chemistryj.dmi'
	icon_state = "chemistryj"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/chemist/fem_jeans
	name = "chemist's jumpjeans"
	desc = "Casual jeans and a coloured top with special protectiona gainst biohazards. It has chemist rank striping on the shoulders."
	icon = 'icons/clothing/uniform/workwear/dept_medical/chemistryjf.dmi'
	icon_state = "chemistryjf"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chemist/skirt_pleated
	name = "chemist's pleated skirt"
	desc = "It's made of a special fiber that gives special protection against biohazards. It even has bonus pleating!"
	icon = 'icons/clothing/uniform/workwear/dept_medical/chemistry_skirt.dmi'
	icon_state = "chemistry_skirt"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chemist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "chemist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/chemist_new.dmi'
	icon_state = "chemist_new"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/**
 * CMO
 */

/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/cmo.dmi'
	icon_state = "cmo"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/chief_medical_officer/skirt
	desc = "It's a jumpskirt worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_medical/cmof.dmi'
	icon_state = "cmof"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL


/obj/item/clothing/under/rank/chief_medical_officer/skirt_pleated
	name = "chief medical officer's pleated skirt"
	desc = "A pleated skirt for the fashion conscious CMO, now with minor biological protection!"
	icon = 'icons/clothing/uniform/workwear/dept_medical/cmo_skirt.dmi'
	icon_state = "cmo_skirt"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chief_medical_officer/turtleneck
	desc = "It's a turtleneck worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection, for an officer with a superior sense of style and practicality."
	name = "chief medical officer's turtleneck"
	icon = 'icons/clothing/uniform/workwear/dept_medical/cmoturtle.dmi'
	icon_state = "cmoturtle"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/chief_medical_officer/jeans
	name = "chief medical officer's jeans"
	desc = "A high-stress workplace should never revoke one's right to dress casual. The minor biological protection should do the trick well enough."
	icon = 'icons/clothing/uniform/workwear/dept_medical/cmoj.dmi'
	icon_state = "cmoj"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/chief_medical_officer/fem_jeans
	name = "chief medical officer's jeans"
	desc = "A high-stress workplace should never revoke one's right to dress casual. The minor biological protection should do the trick well enough."
	icon = 'icons/clothing/uniform/workwear/dept_medical/cmojf.dmi'
	icon_state = "cmojf"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Geneticist
 */

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/genetics.dmi'
	icon_state = "genetics"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)


/obj/item/clothing/under/rank/geneticist/skirt
	name = "geneticist's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_medical/geneticsf.dmi'
	icon_state = "geneticsf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL


/obj/item/clothing/under/rank/geneticist/skirt_pleated
	name = "geneticist's pleated skirt"
	desc = "A pleated skirt for the ever forgotten geneticist."
	icon = 'icons/clothing/uniform/workwear/dept_medical/genetics_skirt.dmi'
	icon_state = "genetics_skirt"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL


/obj/item/clothing/under/rank/geneticist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "geneticist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/genetics_new.dmi'
	icon_state = "genetics_new"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)


/**
 * Virologist
 */

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/virology.dmi'
	icon_state = "virology"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/virologist/skirt
	name = "virologist's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_medical/virologyf.dmi'
	icon_state = "virologyf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/virologist/jeans
	name = "virologist's jumpjeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has green striping on the shoulders that denote the wearer as a virologist."
	icon = 'icons/clothing/uniform/workwear/dept_medical/virologyj.dmi'
	icon_state = "virologyj"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/virologist/fem_jeans
	name = "virologist's jumpjeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has green striping on the shoulders that denote the wearer as a virologist."
	icon = 'icons/clothing/uniform/workwear/dept_medical/virologyjf.dmi'
	icon_state = "virologyjf"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/virologist/skirt_pleated
	name = "virologist's pleated skirt"
	desc = "It's made of a special fiber that gives special protection against biohazards. It even has bonus pleating!"
	icon = 'icons/clothing/uniform/workwear/dept_medical/virology_skirt.dmi'
	icon_state = "virology_skirt"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/virologist_new
	desc = "Made of a special fiber that gives increased protection against biohazards."
	name = "virologist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/virologist_new.dmi'
	icon_state = "virologist_new"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/**
 * Nurse
 */

/obj/item/clothing/under/rank/nursesuit
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/nursesuit.dmi'
	icon_state = "nursesuit"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/nurse
	desc = "A dress commonly worn by the nursing staff in the medical department."
	name = "nurse's dress"
	icon = 'icons/clothing/uniform/workwear/dept_medical/nurse.dmi'
	icon_state = "nurse"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/orderly
	desc = "A white suit to be worn by medical attendants."
	name = "orderly's uniform"
	icon = 'icons/clothing/uniform/workwear/dept_medical/orderly.dmi'
	icon_state = "orderly"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/**
 * Doctor
 */

/obj/item/clothing/under/rank/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/medical.dmi'
	icon_state = "medical"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/medical/skirt
	name = "medical doctor's jumpskirt"
	icon = 'icons/clothing/uniform/workwear/dept_medical/medicalf.dmi'
	icon_state = "medicalf"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/jeans
	name = "medical doctor's jeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	icon = 'icons/clothing/uniform/workwear/dept_medical/medicalj.dmi'
	icon_state = "medicalj"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/medical/fem_jeans
	name = "medical doctor's jeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has a cross on the chest denoting that th wearer is trained medical personnel."
	icon = 'icons/clothing/uniform/workwear/dept_medical/medicaljf.dmi'
	icon_state = "medicaljf"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/skirt_pleated
	name = "medical doctor's pleated skirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its themed pleating and the cross on the chest denotes that the wearer is trained medical personnel."
	icon = 'icons/clothing/uniform/workwear/dept_medical/medical_skirt.dmi'
	icon_state = "medical_skirt"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/turtleneck
	name = "medical turtleneck"
	desc = "It's a stylish turtleneck made of bioresistant fiber. Look good, save lives- what more could you want?"
	icon = 'icons/clothing/uniform/workwear/dept_medical/turtle_med.dmi'
	icon_state = "turtle_med"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/turtleneck_fem
	name = "medical turtleneck"
	desc = "It's a stylish turtleneck made of bioresistant fiber. Look good, save lives- what more could you want?"
	icon = 'icons/clothing/uniform/workwear/dept_medical/turtle_med_fem.dmi'
	icon_state = "turtle_med_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/paramedic
	name = "short sleeve medical jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one has a cross on the chest denoting that the wearer is trained medical personnel."
	icon = 'icons/clothing/uniform/workwear/dept_medical/medical_short.dmi'
	icon_state = "medical_short"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Scrubs
 */

/obj/item/clothing/under/rank/medical/scrubs
	name = "blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsblue.dmi'
	icon_state = "scrubsblue"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/medical/scrubs_fem
	name = "blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsblue_fem.dmi'
	icon_state = "scrubsblue_fem"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/scrubs/green
	name = "green scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsgreen.dmi'
	icon_state = "scrubsgreen"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/medical/scrubs_fem/green
	name = "green scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsgreen_fem.dmi'
	icon_state = "scrubsgreen_fem"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/scrubs/purple
	name = "purple scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubspurple.dmi'
	icon_state = "scrubspurple"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/medical/scrubs_fem/purple
	name = "purple scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubspurple_fem.dmi'
	icon_state = "scrubspurple_fem"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/scrubs/black
	name = "black scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in black."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsblack.dmi'
	icon_state = "scrubsblack"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/medical/scrubs_fem/black
	name = "black scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in black."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsblack_fem.dmi'
	icon_state = "scrubsblack_fem"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/scrubs/navyblue
	name = "navy blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in navy blue."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsnavyblue.dmi'
	icon_state = "scrubsnavyblue"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/rank/medical/scrubs_fem/navyblue
	name = "navy blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in navy blue."
	icon = 'icons/clothing/uniform/workwear/dept_medical/scrubsnavyblue_fem.dmi'
	icon_state = "scrubsnavyblue_fem"
	armor_type = /datum/armor/medical/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Psychiatrist
 */

/obj/item/clothing/under/rank/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/dept_medical/psych.dmi'
	icon_state = "psych"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/psych/turtleneck
	desc = "A turqouise turtleneck and a pair of dark blue slacks, belonging to a psychologist."
	name = "psychologist's turtleneck"
	icon = 'icons/clothing/uniform/workwear/dept_medical/psychturtle.dmi'
	icon_state = "psychturtle"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/psych/turtleneck_fem
	name = "psychologist's turtleneck"
	desc = "A turqouise turtleneck and a pair of dark blue slacks, belonging to a psychologist."
	icon = 'icons/clothing/uniform/workwear/dept_medical/psychturtle_fem.dmi'
	icon_state = "psychturtle_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/**
 * Paramedic
 */

/obj/item/clothing/under/paramedunidark
	name = "Paramedic Uniform"
	desc = "A dark jumpsuit for those brave souls who have to deal with a CMO who thinks they're the do everything person."
	icon = 'icons/clothing/uniform/workwear/dept_medical/paramedic-dark.dmi'
	icon_state = "paramedic-dark"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL


/obj/item/clothing/under/parameduniskirtdark
	name = "Paramedic Uniskirt"
	desc = "A dark jumpskirt for those brave souls who have to deal with a CMO who thinks they're the do everything person."
	icon = 'icons/clothing/uniform/workwear/dept_medical/paramedic-dark_skirt.dmi'
	icon_state = "paramedic-dark_skirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/paramedunilight
	name = "\improper Paramedic Uniform"
	desc = "A light jumpsuit for those brave souls who have to deal with a CMO who thinks they're the do everything person."
	icon_state = "paramedic-light"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/parameduniskirtlight
	name = "\improper Paramedic Uniskirt"
	desc = "A light jumpskirt for those brave souls who have to deal with a CMO who thinks they're the do everything person."
	icon_state = "paramedic_skirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
