/datum/armor/vehicle/mecha/combat/marauder
	melee = 0.35
	melee_tier = 5
	bullet = 0.35
	bullet_tier = 5
	laser = 0.35
	laser_tier = 5
	energy = 0.6
	bomb = 0.75

/obj/vehicle/sealed/mecha/combat/marauder
	name = "Marauder"
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	description_fluff = "Developed by Nanotrasen, the Marauder is the modern descendant of the Durand. Stronger, faster, and more resilient, the Marauder has fully supplanted its predecessor. Deployed by Nanotrasen to the fiercest conflict zones during the Phoron War, Marauders quickly gained a reputation for brutal efficiency. Marauders are fielded by the megacorporation to hot zones across the Frontier to this day. Thanks to its status as a military grade weapons platform and its highly proprietary equipment, the Marauder is generally unavailable to civilians - including low-level Nanotrasen duty stations and allied corporations. Standing at 12'(3.5m) tall, the Marauder cockpit is complex and spacious enough to grant the pilot a full range of movement within its spherical shell."
	catalogue_data = list(/datum/category_item/catalogue/technology/marauder)
	icon_state = "marauder"
	initial_icon = "marauder"

	base_movement_speed = 2.5
	armor_type = /datum/armor/vehicle/mecha/combat/marauder
	integrity = /obj/vehicle/sealed/mecha/combat::integrity * 1.35
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max * 1.35

	comp_armor_relative_thickness = 1.75 * /obj/vehicle/sealed/mecha/combat::comp_armor_relative_thickness
	comp_armor = /obj/item/vehicle_component/plating/mecha_armor/military
	comp_hull_relative_thickness = 1.75 * /obj/vehicle/sealed/mecha/combat::comp_hull_relative_thickness
	comp_hull = /obj/item/vehicle_component/plating/mecha_hull/durable

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)
	modules_intrinsic = list(
		/obj/item/vehicle_module/toggled/jetpack/electric,
		/obj/item/vehicle_module/lazy/smokescreen,
	)

	max_temperature = 60000
	wreckage = /obj/effect/decal/mecha_wreckage/marauder
	internal_damage_threshold = 25

	melee_standard_force = 40

	mech_faction = MECH_FACTION_NT

	zoom_possible = TRUE

	icon_scale_x = 1.5
	icon_scale_y = 1.5

/obj/vehicle/sealed/mecha/combat/marauder/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/energy/pulse,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic,
	)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/marauder/old
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations. This one is particularly worn looking and likely isn't as sturdy."

	integrity = /obj/vehicle/sealed/mecha/combat::integrity * 0.75
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max * 0.75

/obj/vehicle/sealed/mecha/combat/marauder/old/Initialize(mapload)
	. = ..()
	power_cell.charge = rand(0, (power_cell.charge/2))

/obj/vehicle/sealed/mecha/combat/marauder/seraph
	name = "Seraph"
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	description_fluff = "Essentially a Marauder with minor imrprovements, the Seraph combat exosuit is a slight upgrade to its predecessor. Due to the relatively small impact of these changes, the Seraph has not made the Marauder obsolete. Instead Seraph units are generally issued to Nanotrasen paramilitary commanders, where they fill a specialized communications role courtesy of their next-generation communications and electronic warfare suites. Due to the tactical nature of the Seraph's battlefield role, the exosuit is not expected to see combat frequently. In spite of this, the Seraph still fields a combat loadout that enables it to protect itself if attacked unexpectedly."
	catalogue_data = list(/datum/category_item/catalogue/technology/seraph)
	icon_state = "seraph"
	initial_icon = "seraph"

	base_movement_speed = 3
	integrity = /obj/vehicle/sealed/mecha/combat/marauder::integrity * 1.25
	integrity_max = /obj/vehicle/sealed/mecha/combat/marauder::integrity_max * 1.25

	wreckage = /obj/effect/decal/mecha_wreckage/seraph
	internal_damage_threshold = 20
	melee_standard_force = 50

/obj/vehicle/sealed/mecha/combat/marauder/seraph/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic,
		/obj/item/vehicle_module/lazy/legacy/teleporter,
	)

//Note that is the Mauler
/obj/vehicle/sealed/mecha/combat/marauder/mauler
	name = "Mauler"
	desc = "A stolen heavy-duty combat exosuit, developed off of the existing Marauder model."
	description_fluff = "In spite of their technological advancement and heavily restricted deployments, Nanotrasen Marauders may sometimes be stolen, salvaged, or illictly purchased from corrupt company officials. These repurposed models are designated Maulers - after the first line produced by the Syndicate during the Phoron War. Functionally identical in terms of armor and armament, Maulers are considerably more rare than the already scarce Marauder, and are considered a black market collectable on par with stolen art."
	icon_state = "mauler"
	initial_icon = "mauler"
	wreckage = /obj/effect/decal/mecha_wreckage/mauler
	mech_faction = MECH_FACTION_SYNDI
