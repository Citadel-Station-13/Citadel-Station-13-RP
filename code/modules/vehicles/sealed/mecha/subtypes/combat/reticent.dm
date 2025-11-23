/datum/armor/vehicle/mecha/combat/reticent
	melee = 0.45

/obj/vehicle/sealed/mecha/combat/reticent
	name = "Reticent"
	desc = "Designed in response to the H.O.N.K., Reticent models are close combat powerhouses designed to rapidly and quietly ambush slower foes."
	description_fluff = "During the Melancholy Occupation of 2476 - callously referred to by their opposition as the 'Prank War' - the people of Le Rien realized the rapidly widening gulf between their technological advancements and Columbina's. Aiming to prevent another such tragedy from happening again, extensive research was conducted on the H.O.N.K. mecha deployed by the Clowns. Although Silencium bears less technological utility, scientists were able to employ its own unique properties in the Reticent's design. An agile mecha plated in a sturdy layer of Silencium, the Reticent was able to move silently through corridors its bulkier opponent could not. Able to close distance with the more range biased H.O.N.K. mecha, Reticent units deployed to occupied zones quickly cleared out mechanized garrisons. Although formidable, the Reticent suffers from a weak chassis - a byproduct of its maneuverability - and is easily disabled once its dense mineral armor is shattered. Its 11'(3.4m) oblong body is designed to move at a forward tilt, assisting the exosuit in rapidly gaining momentum."
	icon_state = "reticent"
	initial_icon = "reticent"
	dir_in = 1 //Facing North.

	armor = /datum/armor/vehicle/mecha/combat/reticent
	base_movement_speed = 3.33
	integrity = 1.0 * /obj/vehicle/sealed/mecha/combat::integrity
	integrity_max = 1.0 * /obj/vehicle/sealed/mecha/combat::integrity_max
	comp_armor = /obj/item/vehicle_component/plating/armor/marshal
	comp_hull = /obj/item/vehicle_component/plating/hull/lightweight

	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/reticent
	internal_damage_threshold = 35

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 2,
	)

	overload_possible = 1

	icon_scale_x = 1.35
	icon_scale_y = 1.35

	move_sound = 'sound/effects/suitstep1.ogg'
	turn_sound = 'sound/effects/suitstep2.ogg'

/datum/armor/vehicle/mecha/combat/reticent/reticience
	melee_tier = 4
	bullet_tier = 4.5
	laser_tier = 4.5

/obj/vehicle/sealed/mecha/combat/reticent/reticence
	name = "Reticence"
	desc = "The current flagship mecha of Le Rien. The Reticence trades some speed for durability, but remains formidable. It is not commercially available."
	description_fluff = "After fully repelling the Columbinan occupiers in 2503, Le Rien began to construct powerful defensive lines along their borders. Decades of fighting had provided researchers with plenty of insight into the faults and merits of the Reticent design. Although intent on keeping the model in service, the Silent Council decreed that a new mech platform would need to be developed to bolster their static defensive line. The Reticent was far too fragile for border defense. Returning to more traditional mecha design doctrine, the Reticence is larger, heavier, and more armored than its predecessor. A 10'(3m) tall hulk, the Reticence trades in the Reticent's blinding speed for a more powerful shielding system and significant improvements in Silencium armor placement. The Reticence is still able to close the gap and deliver close-range punishment to any who dare violate Le Rien's borders."
	icon_state = "reticence"
	initial_icon = "reticence"

	armor = /datum/armor/vehicle/mecha/combat/reticent/reticience
	base_movement_speed = 3.33
	integrity = 1.25 * /obj/vehicle/sealed/mecha/combat/reticent::integrity
	integrity_max = 1.25 * /obj/vehicle/sealed/mecha/combat/reticent::integrity_max

	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/reticent/reticence

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

/obj/vehicle/sealed/mecha/combat/reticent/reticence/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/whisperblade,
		/obj/item/vehicle_module/lazy/legacy/weapon/infernoblade,
		/obj/item/vehicle_module/shield_projector/omnidirectional/reticence,
		/obj/item/vehicle_module/lazy/legacy/cloak,
	)

/obj/vehicle/sealed/mecha/combat/reticent/reticence/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000
