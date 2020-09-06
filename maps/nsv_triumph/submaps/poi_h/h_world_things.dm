// -- Turfs -- //

//Turfmakers
#define DESERT_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_CLASSH
#define DESERT_TURF_CREATE(x)	x/classh/initial_gas_mix=ATMOSPHERE_ID_DESERT

DESERT_TURF_CREATE(/turf/unsimulated/wall/planetary)

DESERT_TURF_CREATE(/turf/simulated/wall)
DESERT_TURF_CREATE(/turf/simulated/wall/sandstone)
DESERT_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
DESERT_TURF_CREATE(/turf/simulated/floor/beach/sand/desert)
DESERT_TURF_CREATE(/turf/simulated/floor/wood)
DESERT_TURF_CREATE(/turf/simulated/floor/tiled)
DESERT_TURF_CREATE(/turf/simulated/floor)
DESERT_TURF_CREATE(/turf/simulated/floor/water)
DESERT_TURF_CREATE(/turf/simulated/floor/water/deep)
DESERT_TURF_CREATE(/turf/simulated/floor/water/shoreline)
DESERT_TURF_CREATE(/turf/simulated/floor/water/shoreline/corner)


DESERT_TURF_CREATE(/turf/simulated/mineral)
DESERT_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
DESERT_TURF_CREATE(/turf/simulated/mineral/floor)
DESERT_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)

// -- Loot Spawners Stolen from UD Files -- //
/obj/random/triumph
	name = "random triumph loot"
	desc = "Random loot for triumph."
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"

/obj/random/triumph/item_to_spawn()
	return pick(prob(3);/obj/random/multiple/triumph/miningdrills,
				prob(3);/obj/random/multiple/triumph/ores,
				prob(2);/obj/random/multiple/triumph/treasure,
				prob(1);/obj/random/multiple/triumph/mechtool)

/obj/random/triumph/uncertain
	icon_state = "upickaxe"
	spawn_nothing_percentage = 65	//only 33% to spawn loot

/obj/random/multiple/triumph/miningdrills
	name = "random triumph mining tool loot"
	desc = "Random mining tool loot for triumph."
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"

/obj/random/multiple/triumph/miningdrills/item_to_spawn()
	return pick(
				prob(10);list(/obj/item/pickaxe/silver),
				prob(8);list(/obj/item/pickaxe/drill),
				prob(6);list(/obj/item/pickaxe/jackhammer),
				prob(5);list(/obj/item/pickaxe/gold),
				prob(4);list(/obj/item/pickaxe/plasmacutter),
				prob(2);list(/obj/item/pickaxe/diamond),
				prob(1);list(/obj/item/pickaxe/diamonddrill)
				)

/obj/random/multiple/triumph/ores
	name = "random triumph mining ore loot"
	desc = "Random mining utility loot for triumph."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"

/obj/random/multiple/triumph/ores/item_to_spawn()
	return pick(
				prob(9);list(
							/obj/item/storage/bag/ore,
							/obj/item/shovel,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/glass,
							/obj/item/ore/hydrogen,
							/obj/item/ore/hydrogen,
							/obj/item/ore/hydrogen,
							/obj/item/ore/hydrogen,
							/obj/item/ore/hydrogen,
							/obj/item/ore/hydrogen
							),
				prob(7);list(
							/obj/item/storage/bag/ore,
							/obj/item/pickaxe,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium,
							/obj/item/ore/osmium
							),
				prob(4);list(
							/obj/item/clothing/suit/radiation,
							/obj/item/clothing/head/radiation,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium,
							/obj/item/ore/uranium),
				prob(2);list(
							/obj/item/flashlight/lantern,
							/obj/item/clothing/glasses/material,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond,
							/obj/item/ore/diamond
							),
				prob(1);list(
							/obj/item/mining_scanner,
							/obj/item/shovel/spade,
							/obj/item/ore/verdantium,
							/obj/item/ore/verdantium,
							/obj/item/ore/verdantium,
							/obj/item/ore/verdantium,
							/obj/item/ore/verdantium
							)
				)

/obj/random/multiple/triumph/treasure
	name = "random triumph treasure"
	desc = "Random treasure loot for triumph."
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"

/obj/random/multiple/triumph/treasure/item_to_spawn()
	return pick(
				prob(5);list(
							/obj/random/coin,
							/obj/random/coin,
							/obj/random/coin,
							/obj/random/coin,
							/obj/random/coin,
							/obj/item/clothing/head/pirate
							),
				prob(4);list(
							/obj/item/storage/bag/cash,
							/obj/item/spacecash/c500,
							/obj/item/spacecash/c100,
							/obj/item/spacecash/c50
							),
				prob(3);list(
							/obj/item/clothing/head/hardhat/orange,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold,
							/obj/item/stack/material/gold),
				prob(1);list(
							/obj/item/stack/material/phoron,
							/obj/item/stack/material/phoron,
							/obj/item/stack/material/phoron,
							/obj/item/stack/material/phoron,
							/obj/item/stack/material/diamond,
							/obj/item/stack/material/diamond,
							/obj/item/stack/material/diamond
							)
				)

/obj/random/multiple/triumph/mechtool
	name = "random triumph mech equipment"
	desc = "Random mech equipment loot for triumph."
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_clamp"

/obj/random/multiple/triumph/mechtool/item_to_spawn()
	return pick(
				prob(12);list(/obj/item/mecha_parts/mecha_equipment/tool/drill),
				prob(10);list(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp),
				prob(8);list(/obj/item/mecha_parts/mecha_equipment/generator),
				prob(7);list(/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot/rigged),
				prob(6);list(/obj/item/mecha_parts/mecha_equipment/repair_droid),
				prob(3);list(/obj/item/mecha_parts/mecha_equipment/gravcatapult),
				prob(2);list(/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser),
				prob(2);list(/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged),
				prob(1);list(/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill),
				)