/obj/vehicle/sealed/mecha/combat/fighter/duke
	name = "\improper Duke"
	desc = "The Duke Heavy Fighter is designed and manufactured by Hephaestus Industries as a bulky craft built to punch above its weight. This one comes painted in Nanotrasen's blue white and black color scheme straight out of the fabricator, catering to security team's need for friendly identification. It makes up for the minimal hull upgrade space with a stronger chassis, and multiple mounting points for missiles, bombs, and lasers. It's incapable of Atmospheric flight."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke"
	initial_icon = "duke"

	step_in = 3 //slightly slower than a baron (this shit doesnt actually work atm, likely due to the whole equipment weight nonsense)

	integrity = 1200
	integrity_max = 1200 //double baron HP, only room for one defensive upgrade. No specials(cloaking, speed, ect) or universals.

	max_hull_equip = 1
	max_weapon_equip = 4
	max_utility_equip = 2
	max_universal_equip = 0
	max_special_equip = 0

	catalogue_data = list(/datum/category_item/catalogue/technology/duke)
	wreckage = /obj/effect/decal/mecha_wreckage/duke

	ground_capable = FALSE

/obj/vehicle/sealed/mecha/combat/fighter/duke/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/vehicle_module/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/vehicle/sealed/mecha/combat/fighter/duke/db
	name = "\improper Duke \"Deep Blue\""
	desc = "A Duke heavy fighter decorated with the common 'Deep Blue' customization kit, both designed and sold by Hephaestus Industries. This paint scheme pays homage to one of the first supercomputing systems that dared to push the boundaries of what it meant to think. Think 40 steps ahead of your enemy with these colorations, just as Deep Blue did so many years ago."
	icon_state = "duke_db"
	initial_icon = "duke_db"
	wreckage = /obj/effect/decal/mecha_wreckage/duke/db

/obj/vehicle/sealed/mecha/combat/fighter/duke/db/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/vehicle_module/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/vehicle/sealed/mecha/combat/fighter/duke/cw
	name = "\improper Duke \"Clockwork\""
	desc = "A Duke heavy fighter decorated with the rare 'Clockwork' customization kit, both designed and sold by Hephaestus Industries. Textured paint with accurate colorations and reflectiveness to brass makes this Duke Heavy Fighter stand out amongst the competition in any conflict."
	icon_state = "duke_cw"
	initial_icon = "duke_cw"
	wreckage = /obj/effect/decal/mecha_wreckage/duke/cw

/obj/vehicle/sealed/mecha/combat/fighter/duke/cw/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/vehicle_module/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/duke
	name = "Duke wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke-broken"
	bound_width = 64
	bound_height = 64

/obj/effect/decal/mecha_wreckage/duke/db
	name = "Duke wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke_db-broken"
	bound_width = 64
	bound_height = 64

/obj/effect/decal/mecha_wreckage/duke/cw
	name = "Duke wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke_cw-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/duke
	name = "Voidcraft - Duke"
	desc = "The Duke Heavy Fighter is designed and manufactured by Hephaestus Industries as a bulky craft built to punch above its weight. Primarily armed with missiles, bombs, or similar large payloads, this fighter packs a punch against most at the cost of room for minimul hull modifications, which is almost always reserved for much-needed armor inserts instead of a shield. It's incapable of atmospheric flight."
	value = CATALOGUER_REWARD_MEDIUM
