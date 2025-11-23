/datum/armor/vehicle/mecha/combat/honker
	melee = 0.35
	melee_tier = 4
	bullet = 0.45
	bullet_tier = 4
	laser = 0.45
	laser_tier = 4
	energy = 0.35
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/honker
	name = "H.O.N.K."
	desc = "The H.O.N.K. mecha is sometimes crafted by deranged Roboticists with a grudge, and is illegal in thirty six different sectors."
	description_fluff = "Utilized with shocking effectiveness during the Prank War of 2476, the H.O.N.K. mech was commissioned by former Honktifex Maximus Pierrot LXIX. Utilizing advanced technology for its time, these mecha were constructed with the extremely rare alloy Vaudium. Initially viewed by external observers as a simple curiosity, the H.O.N.K. mech's ability to inflict widespread 'hilarity' was not realized until the design was made public some decades later. After less than two years on the open market, harsh sanctions and bans on production were levied across at least thirty six Galactic sectors. In spite of this production moratorium, experts in Robotics may sometimes ignore the warnings and fabricate these suits when asked. This is generally considered to be a poor decision. This plodding mecha comes in at 10'(3m) in height, and features a curiously barrel shaped body that provides supreme stability when firing its weaponry. There is some dispute regarding exactly what H.O.N.K. stands for. The most likely suggestion is generallly accepted to be: 'Hilariously Overpowered Noise Kreator'."
	icon_state = "honker"
	initial_icon = "honker"

	armor_type = /datum/armor/vehicle/mecha/combat/honker
	integrity = /obj/vehicle/sealed/mecha/combat::integrity * (5 / 6)
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max * (5 / 6)
	base_movement_speed = 3.75

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 1,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 2,
	)

	comp_armor = /obj/item/vehicle_component/plating/armor/marshal
	comp_hull = /obj/item/vehicle_component/plating/hull/durable

	dir_in = 1 //Facing North.
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/honker
	internal_damage_threshold = 35

	icon_scale_x = 1.35
	icon_scale_y = 1.35

/datum/armor/vehicle/mecha/combat/honker/cluwne

/obj/vehicle/sealed/mecha/combat/honker/cluwne
	name = "C.L.U.W.N.E."
	desc = "The C.L.U.W.N.E. mecha is an up-armored cousin of the H.O.N.K. mech. Still in service on the borders of Scaena Globus, this unit is not typically commercially available."
	description_fluff = "As the unending battle over Vaudium continues raging to this day, it should come as no surprise that both Clowns and Mimes continue to iterate on their unique forms of military technology. The C.L.U.W.N.E. is the successor to the H.O.N.K. mech. Utilizing similar design philosophy and based off of the same chassis, the C.L.U.W.N.E. is significantly more armored and durable, addressing several vulnerabilities in the original H.O.N.K. design. Demonstrably effective, these mecha are frequently deployed to the front lines of the conflict.  Rarely they are even dispatched off-planet to support Clown Commando teams. Due to the immense amount of Vaudium required to fabricate a single C.L.U.W.N.E. mech, their mass production remains untenable. Even if it were, Clown Planet guards the mech's schematics jealously. It is currently assumed that the mecha's designation stands for 'Combative Laughter Unit With New Equipment', though this theory is widely disputed."
	icon = 'icons/mecha/mecha_vr.dmi'
	icon_state = "cluwne"
	initial_icon = "cluwne"

	armor_type = /datum/armor/vehicle/mecha/combat/honker/cluwne
	integrity = /obj/vehicle/sealed/mecha/combat/honker::integrity * 1.45
	integrity_max = /obj/vehicle/sealed/mecha/combat/honker::integrity_max * 1.45
	base_movement_speed = 3

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
	)

	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/honker/cluwne

/obj/vehicle/sealed/mecha/combat/honker/cluwne/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/honker,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/grenade/banana,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/lazy/legacy/teleporter,
	)

/obj/vehicle/sealed/mecha/combat/honker/cluwne/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000
