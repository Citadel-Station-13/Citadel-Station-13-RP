//Drill added for hazmat suit
/obj/item/rig/hazmat/equipped
	req_access = list(access_xenoarch)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/device/drill //The suit has nothing to mine with otherwise.
		)

//Access restriction and seal delay, plus pat_module and rescue_pharm for medical suit
/obj/item/rig/medical/equipped
	req_access = list(access_medical)
	seal_delay = 5

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/pat_module,
		/obj/item/rig_module/rescue_pharm
		)
/* cit change - this is fucking gay
//Armor reduction for industrial suit
/obj/item/rig/industrial
	armor = list(melee = 50, bullet = 10, laser = 20, energy = 15, bomb = 30, bio = 100, rad = 50)
*/

//Area allowing backpacks to be placed on rigsuits.
/obj/item/rig/vox
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/combat1
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton,/obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/ert
	allowed = list(/obj/item/flashlight, /obj/item/tank, /obj/item/t_scanner, /obj/item/rcd, /obj/item/tool/crowbar, \
	/obj/item/tool/screwdriver, /obj/item/weldingtool, /obj/item/tool/wirecutters, /obj/item/tool/wrench, /obj/item/multitool, \
	/obj/item/radio, /obj/item/analyzer,/obj/item/storage/briefcase/inflatable, /obj/item/melee/baton, /obj/item/gun, \
	/obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/item/roller, /obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/light/ninja
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/cell, /obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/merc
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs, /obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/ce
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/t_scanner,/obj/item/pickaxe, /obj/item/rcd,/obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/medical
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/healthanalyzer,/obj/item/stack/medical,/obj/item/roller,/obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/hazmat
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/stack/flag,/obj/item/storage/excavation,/obj/item/pickaxe,/obj/item/healthanalyzer,/obj/item/measuring_tape,/obj/item/ano_scanner,/obj/item/depth_scanner,/obj/item/core_sampler,/obj/item/gps,/obj/item/beacon_locator,/obj/item/radio/beacon,/obj/item/pickaxe/hand,/obj/item/storage/bag/fossils,/obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/hazard
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/melee/baton,/obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/industrial
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/bag/ore,/obj/item/t_scanner,/obj/item/pickaxe, /obj/item/rcd,/obj/item/storage/backpack,/obj/item/subspaceradio)

/obj/item/rig/military
	allowed = list(/obj/item/flashlight, /obj/item/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/handcuffs, \
	/obj/item/t_scanner, /obj/item/rcd, /obj/item/weldingtool, /obj/item/tool, /obj/item/multitool, \
	/obj/item/radio, /obj/item/analyzer,/obj/item/storage/briefcase/inflatable, /obj/item/melee/baton, /obj/item/gun, \
	/obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/item/roller, /obj/item/suit_cooling_unit, /obj/item/storage/backpack,/obj/item/subspaceradio)
/obj/item/rig/pmc
	allowed = list(/obj/item/flashlight, /obj/item/tank, /obj/item/t_scanner, /obj/item/rcd, /obj/item/tool/crowbar, \
	/obj/item/tool/screwdriver, /obj/item/weldingtool, /obj/item/tool/wirecutters, /obj/item/tool/wrench, /obj/item/multitool, \
	/obj/item/radio, /obj/item/analyzer,/obj/item/storage/briefcase/inflatable, /obj/item/melee/baton, /obj/item/gun, \
	/obj/item/storage/firstaid, /obj/item/reagent_containers/hypospray, /obj/item/roller, /obj/item/storage/backpack,/obj/item/subspaceradio)
