/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon_state = "director"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/skirt_pleated
	name = "research director's pleated skirt"
	desc = "Feminine fashion for the style conscious RD. Its fabric provides minor protection from biological contaminants, and its pleated skirt provides extra style points."
	icon_state = "director_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/skirt_pleated/whimsical
	name = "whimsical research director's pleated skirt"
	desc = "Whimsical attire for the more magical of RD's, providing minor protection from biological contaminants like it's nothing."
	icon_state = "rdwhimsy_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/skirt_pleated/turtleneck
	name = "research director's turtleneck pleated skirt"
	desc = "A dark purple purple turtleneck and a pleated tan skirt, for a director of superior authority."
	icon_state = "rdturtle_skirt"

/obj/item/clothing/under/rank/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon_state = "rdalt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "director", SLOT_ID_LEFT_HAND = "director")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/dress_rd
	name = "research director dress uniform"
	desc = "Feminine fashion for the style conscious RD. Its fabric provides minor protection from biological contaminants."
	icon_state = "dress_rd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/research_director/turtleneck
	desc = "A dark purple turtleneck and tan khakis, for a director with a superior sense of style."
	name = "research director's turtleneck"
	icon_state = "rdturtle"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "director", SLOT_ID_LEFT_HAND = "director")

/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon_state = "science"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/scientist/jeans
	name = "scientist's jumpjeans"
	desc = "The perfect getup for the more laid-back researcher. Sadly, it doesn't seem to be as protective as its jumpsuit counterpart."
	icon_state = "sciencej"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)

/obj/item/clothing/under/rank/scientist/femjeans
	name = "scientist's jumpjeans"
	desc = "The perfect getup for the more laid-back researcher. Sadly, it doesn't seem to be as protective as it's jumpsuit counterpart"
	icon_state = "sciencejf"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)

/obj/item/clothing/under/rank/scientist/skirt_pleated
	name = "scientist's pleated skirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. Appropriately placed markings on the shoulders and pleated skirt denote the wearer as a scientist."
	icon_state = "toxins_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/scientist/turtleneck
	name = "science turtleneck"
	desc = "It's a stylish turtleneck weaved with an explosive-resistant, comfortable mesh. You don't have to look like a dork to be a dork."
	icon_state = "turtle_sci"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "purple", SLOT_ID_LEFT_HAND = "purple")
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/scientist/turtleneck_fem
	name = "science turtleneck"
	desc = "It's a stylish turtleneck weaved with an explosive-resistant, comfortable mesh. You don't have to look like a dork to be a dork."
	icon_state = "turtle_sci_fem"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	name = "chemist's jumpsuit"
	icon_state = "chemistry"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chemist/jeans
	name = "chemist's jumpjeans"
	desc = "Casual jeans and a coloured top with special protection against biohazards. It has chemist rank striping on the shoulders."
	icon_state = "chemistryj"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chemist/fem_jeans
	name = "chemist's jumpjeans"
	desc = "Casual jeans and a coloured top with special protectiona gainst biohazards. It has chemist rank striping on the shoulders."
	icon_state = "chemistryjf"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chemist/skirt_pleated
	name = "chemist's pleated skirt"
	desc = "It's made of a special fiber that gives special protection against biohazards. It even has bonus pleating!"
	icon_state = "chemistry_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)


/*
 * Medical
 */
/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon_state = "cmo"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chief_medical_officer/skirt_pleated
	name = "chief medical officer's pleated skirt"
	desc = "A pleated skirt for the fashion conscious CMO, now with minor biological protection!"
	icon_state = "cmo_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chief_medical_officer/turtleneck
	desc = "It's a turtleneck worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection, for an officer with a superior sense of style and practicality."
	name = "chief medical officer's turtleneck"
	icon_state = "cmoturtle"

/obj/item/clothing/under/rank/chief_medical_officer/jeans
	name = "chief medical officer's jeans"
	desc = "A high-stress workplace should never revoke one's right to dress casual. The minor biological protection should do the trick well enough."
	icon_state = "cmoj"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chief_medical_officer/fem_jeans
	name = "chief medical officer's jeans"
	desc = "A high-stress workplace should never revoke one's right to dress casual. The minor biological protection should do the trick well enough."
	icon_state = "cmojf"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon_state = "genetics"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/geneticist/skirt_pleated
	name = "geneticist's pleated skirt"
	desc = "A pleated skirt for the ever forgotten geneticist."
	icon_state = "genetics_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/virologist/jeans
	name = "virologist's jumpjeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has green striping on the shoulders that denote the wearer as a virologist."
	icon_state = "virologyj"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/virologist/fem_jeans
	name = "virologist's jumpjeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has green striping on the shoulders that denote the wearer as a virologist."
	icon_state = "virologyjf"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/virologist/skirt_pleated
	name = "virologist's pleated skirt"
	desc = "It's made of a special fiber that gives special protection against biohazards. It even has bonus pleating!"
	icon_state = "virology_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/nursesuit
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon_state = "nursesuit"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/nurse
	desc = "A dress commonly worn by the nursing staff in the medical department."
	name = "nurse's dress"
	icon_state = "nurse"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "nursesuit", SLOT_ID_LEFT_HAND = "nursesuit")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/orderly
	desc = "A white suit to be worn by medical attendants."
	name = "orderly's uniform"
	icon_state = "orderly"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "nursesuit", SLOT_ID_LEFT_HAND = "nursesuit")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon_state = "medical"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/jeans
	name = "medical doctor's jeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	icon_state = "medicalj"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/fem_jeans
	name = "medical doctor's jeans"
	desc = "A casual outfit made of special fibers that provide minor protection against biohazards. It has a cross on the chest denoting that th wearer is trained medical personnel."
	icon_state = "medicaljf"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/skirt_pleated
	name = "medical doctor's pleated skirt"
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its themed pleating and the cross on the chest denotes that the wearer is trained medical personnel."
	icon_state = "medical_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/turtleneck
	name = "medical turtleneck"
	desc = "It's a stylish turtleneck made of bioresistant fiber. Look good, save lives- what more could you want?"
	icon_state = "turtle_med"
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/turtleneck_fem
	name = "medical turtleneck"
	desc = "It's a stylish turtleneck made of bioresistant fiber. Look good, save lives- what more could you want?"
	icon_state = "turtle_med_fem"

/obj/item/clothing/under/rank/medical/paramedic
	name = "short sleeve medical jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one has a cross on the chest denoting that the wearer is trained medical personnel."
	icon_state = "medical_short"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/medical/scrubs
	name = "blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon_state = "scrubsblue"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue", SLOT_ID_LEFT_HAND = "blue")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs_fem
	name = "blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon_state = "scrubsblue_fem"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs/green
	name = "green scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon_state = "scrubsgreen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "green", SLOT_ID_LEFT_HAND = "green")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs_fem/green
	name = "green scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon_state = "scrubsgreen_fem"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs/purple
	name = "purple scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon_state = "scrubspurple"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "purple", SLOT_ID_LEFT_HAND = "purple")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs_fem/purple
	name = "purple scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon_state = "scrubspurple_fem"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs/black
	name = "black scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in black."
	icon_state = "scrubsblack"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs_fem/black
	name = "black scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in black."
	icon_state = "scrubsblack_fem"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs/navyblue
	name = "navy blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in navy blue."
	icon_state = "scrubsnavyblue"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue", SLOT_ID_LEFT_HAND = "blue")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/scrubs_fem/navyblue
	name = "navy blue scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in navy blue."
	icon_state = "scrubsnavyblue_fem"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon_state = "psych"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")

/obj/item/clothing/under/rank/psych/turtleneck
	desc = "A turqouise turtleneck and a pair of dark blue slacks, belonging to a psychologist."
	name = "psychologist's turtleneck"
	icon_state = "psychturtle"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "psyche", SLOT_ID_LEFT_HAND = "psyche")

/obj/item/clothing/under/rank/psych/turtleneck_fem
	name = "psychologist's turtleneck"
	desc = "A turqouise turtleneck and a pair of dark blue slacks, belonging to a psychologist."
	icon_state = "psychturtle"

/*
 * Medsci, unused (i think) stuff
 */
/obj/item/clothing/under/rank/geneticist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "geneticist's jumpsuit"
	icon_state = "genetics_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/chemist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "chemist's jumpsuit"
	icon_state = "chemist_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/scientist_new
	desc = "Made of a special fiber that gives special protection against biohazards and small explosions."
	name = "scientist's jumpsuit"
	icon_state = "scientist_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/virologist_new
	desc = "Made of a special fiber that gives increased protection against biohazards."
	name = "virologist's jumpsuit"
	icon_state = "virologist_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
