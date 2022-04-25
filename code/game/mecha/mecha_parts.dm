 /////////////////////////
////// Mecha Parts //////
/////////////////////////

// Mecha circuitboards can be found in /code/game/objects/items/weapons/circuitboards/mecha.dm

/obj/item/mecha_parts
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2)


/obj/item/mecha_parts/chassis
	name="Mecha Chassis"
	icon_state = "backbone"
	var/datum/construction/construct

	attackby(obj/item/W as obj, mob/user as mob)
		if(!construct || !construct.action(W, user))
			..()
		return

	attack_hand()
		return

/////////// Ripley

/obj/item/mecha_parts/chassis/ripley
	name = "Ripley Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/mecha_parts/part/ripley_torso
	name="Ripley Torso"
	desc="A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/ripley_left_arm
	name="Ripley Left Arm"
	desc="A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/ripley_right_arm
	name="Ripley Right Arm"
	desc="A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/ripley_left_leg
	name="Ripley Left Leg"
	desc="A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/ripley_right_leg
	name="Ripley Right Leg"
	desc="A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

///////// Gygax

/obj/item/mecha_parts/chassis/gygax
	name = "Gygax Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/gygax_chassis(src)

/obj/item/mecha_parts/part/gygax_torso
	name="Gygax Torso"
	desc="A torso part of Gygax. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/gygax_head
	name="Gygax Head"
	desc="A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/gygax_left_arm
	name="Gygax Left Arm"
	desc="A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/gygax_right_arm
	name="Gygax Right Arm"
	desc="A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/gygax_left_leg
	name="Gygax Left Leg"
	icon_state = "gygax_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/gygax_right_leg
	name="Gygax Right Leg"
	icon_state = "gygax_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/gygax_armour
	name="Gygax Armour Plates"
	icon_state = "gygax_armour"
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5)

////////// Serenity

/obj/item/mecha_parts/chassis/serenity
	name = "Serenity Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/serenity_chassis(src)

//////////// Durand

/obj/item/mecha_parts/chassis/durand
	name = "Durand Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/durand_chassis(src)

/obj/item/mecha_parts/part/durand_torso
	name="Durand Torso"
	icon_state = "durand_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/durand_head
	name="Durand Head"
	icon_state = "durand_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/durand_left_arm
	name="Durand Left Arm"
	icon_state = "durand_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/durand_right_arm
	name="Durand Right Arm"
	icon_state = "durand_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/durand_left_leg
	name="Durand Left Leg"
	icon_state = "durand_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/durand_right_leg
	name="Durand Right Leg"
	icon_state = "durand_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/part/durand_armour
	name="Durand Armour Plates"
	icon_state = "durand_armour"
	origin_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_ENGINEERING = 5)



////////// Firefighter

/obj/item/mecha_parts/chassis/firefighter
	name = "Firefighter Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/firefighter_chassis(src)
/*
/obj/item/mecha_parts/part/firefighter_torso
	name="Ripley-on-Fire Torso"
	icon_state = "ripley_harness"

/obj/item/mecha_parts/part/firefighter_left_arm
	name="Ripley-on-Fire Left Arm"
	icon_state = "ripley_l_arm"

/obj/item/mecha_parts/part/firefighter_right_arm
	name="Ripley-on-Fire Right Arm"
	icon_state = "ripley_r_arm"

/obj/item/mecha_parts/part/firefighter_left_leg
	name="Ripley-on-Fire Left Leg"
	icon_state = "ripley_l_leg"

/obj/item/mecha_parts/part/firefighter_right_leg
	name="Ripley-on-Fire Right Leg"
	icon_state = "ripley_r_leg"
*/

////////// Firefighter

/obj/item/mecha_parts/chassis/geiger
	name = "Lightweight APLU Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/geiger_chassis(src)

/obj/item/mecha_parts/part/geiger_torso
	name="Lightweight APLU Torso"
	icon_state = "ripley_harness"


////////// Phazon

/obj/item/mecha_parts/chassis/phazon
	name = "Phazon Chassis"
	origin_tech = list(TECH_MATERIAL = 7)

	New()
		..()
		construct = new /datum/construction/mecha/phazon_chassis(src)

/obj/item/mecha_parts/part/phazon_torso
	name="Phazon Torso"
	icon_state = "phazon_harness"
	//construction_time = 300
	//construction_cost = list(MAT_STEEL=35000,"glass"=10000,"phoron"=20000)
	origin_tech = list(TECH_DATA = 5, TECH_MATERIAL = 7, TECH_BLUESPACE = 6, TECH_POWER = 6)

/obj/item/mecha_parts/part/phazon_head
	name="Phazon Head"
	icon_state = "phazon_head"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=15000,"glass"=5000,"phoron"=10000)
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 5, TECH_MAGNET = 6)

/obj/item/mecha_parts/part/phazon_left_arm
	name="Phazon Left Arm"
	icon_state = "phazon_l_arm"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/part/phazon_right_arm
	name="Phazon Right Arm"
	icon_state = "phazon_r_arm"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/part/phazon_left_leg
	name="Phazon Left Leg"
	icon_state = "phazon_l_leg"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3)

/obj/item/mecha_parts/part/phazon_right_leg
	name="Phazon Right Leg"
	icon_state = "phazon_r_leg"
	//construction_time = 200
	//construction_cost = list(MAT_STEEL=20000,"phoron"=10000)
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3)

///////// Odysseus


/obj/item/mecha_parts/chassis/odysseus
	name = "Odysseus Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/odysseus_chassis(src)

/obj/item/mecha_parts/part/odysseus_head
	name="Odysseus Head"
	icon_state = "odysseus_head"
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 2)

/obj/item/mecha_parts/part/odysseus_torso
	name="Odysseus Torso"
	desc="A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/odysseus_left_arm
	name="Odysseus Left Arm"
	desc="An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/odysseus_right_arm
	name="Odysseus Right Arm"
	desc="An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/odysseus_left_leg
	name="Odysseus Left Leg"
	desc="An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/part/odysseus_right_leg
	name="Odysseus Right Leg"
	desc="A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/*/obj/item/mecha_parts/part/odysseus_armour
	name="Odysseus Carapace"
	icon_state = "odysseus_armour"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MAT_STEEL=15000)*/

////////// Janus

/obj/item/mecha_parts/chassis/janus
	name = "Janus Chassis"
	origin_tech = list(TECH_MATERIAL = 7)

	New()
		..()
		construct = new /datum/construction/mecha/janus_chassis(src)

/obj/item/mecha_parts/part/janus_torso
	name="Imperion Torso"
	icon_state = "janus_harness"
	origin_tech = list(TECH_DATA = 5, TECH_MATERIAL = 7, TECH_BLUESPACE = 2, TECH_POWER = 6, TECH_PRECURSOR = 2)

/obj/item/mecha_parts/part/janus_head
	name="Imperion Head"
	icon_state = "janus_head"
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 5, TECH_MAGNET = 6, TECH_PRECURSOR = 1)

/obj/item/mecha_parts/part/janus_left_arm
	name="Prototype Gygax Left Arm"
	icon_state = "janus_l_arm"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/part/janus_right_arm
	name="Prototype Gygax Right Arm"
	icon_state = "janus_r_arm"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/part/janus_left_leg
	name="Prototype Durand Left Leg"
	icon_state = "janus_l_leg"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3, TECH_ARCANE = 1)

/obj/item/mecha_parts/part/janus_right_leg
	name="Prototype Durand Right Leg"
	icon_state = "janus_r_leg"
	origin_tech = list(TECH_MATERIAL = 5, TECH_BLUESPACE = 3, TECH_MAGNET = 3, TECH_ARCANE = 1)

///////// Honker

/obj/item/mecha_parts/chassis/honker
	name = "H.O.N.K. Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/mecha_parts/part/honker_torso
	name="H.O.N.K. Torso"
	desc="A H.O.N.K. torso. The lining requires a distressing amount of rubber."
	icon_state = "honker_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 3, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/honker_head
	name="H.O.N.K. Head"
	desc="A H.O.N.K. head. Houses advanced slip prediction sensors and a squeezable nose."
	icon_state = "honker_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/honker_left_arm
	name="H.O.N.K. Left Arm"
	desc="A H.O.N.K. left arm. Data and power sockets are compatible with the most hilarious tools and weapons."
	icon_state = "honker_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/honker_right_arm
	name="H.O.N.K. Right Arm"
	desc="A H.O.N.K. right arm. Data and power sockets are compatible with the most hilarious tools and weapons."
	icon_state = "honker_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/honker_left_leg
	name="H.O.N.K. Left Leg"
	icon_state = "honker_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/honker_right_leg
	name="H.O.N.K. Right Leg"
	icon_state = "honker_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/honker_armour
	name="H.O.N.K. Armour Plates"
	icon_state = "honker_armour"
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 5)

///////// Reticent

/obj/item/mecha_parts/chassis/reticent
	name = "Reticent Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/reticent_chassis(src)

/obj/item/mecha_parts/part/reticent_torso
	name="Reticent Torso"
	desc="A Reticent torso. The hull is augmented by a Silencium mosaic."
	icon_state = "reticent_harness"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_BIO = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/reticent_head
	name="Reticent Head"
	desc="A Reticent head. The eyes stare dispassionately back at you."
	icon_state = "reticent_head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_MAGNET = 2, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/reticent_left_arm
	name="Reticent Left Arm"
	desc="A Reticent left arm. Data and power sockets are compatible with general weapons, and wickedly silent alternatives."
	icon_state = "reticent_l_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/reticent_right_arm
	name="Reticent Right Arm"
	desc="A Reticent right arm. Data and power sockets are compatible with general weapons, and wickedly silent alternatives."
	icon_state = "reticent_r_arm"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/reticent_left_leg
	name="Reticent Left Leg"
	icon_state = "reticent_l_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/reticent_right_leg
	name="Reticent Right Leg"
	icon_state = "reticent_r_leg"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 5, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/mecha_parts/part/reticent_armour
	name="Reticent Armour Plates"
	icon_state = "reticent_armour"
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 5)
