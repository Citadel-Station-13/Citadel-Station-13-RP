/obj/random/underdark
	name = "random underdark loot"
	desc = "Random loot for Underdark."
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"

/obj/random/underdark/item_to_spawn()
	return pick(prob(3);/obj/random/multiple/underdark/miningdrills,
				prob(3);/obj/random/multiple/underdark/ores,
				prob(2);/obj/random/multiple/underdark/treasure,
				prob(1);/obj/random/multiple/underdark/mechtool)

/obj/random/underdark/uncertain
	icon_state = "upickaxe"
	spawn_nothing_percentage = 65	//only 33% to spawn loot

/obj/random/multiple/underdark/miningdrills
	name = "random underdark mining tool loot"
	desc = "Random mining tool loot for Underdark."
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"

/obj/random/multiple/underdark/miningdrills/item_to_spawn()
	return pick(
				prob(10);list(/obj/item/pickaxe/silver),
				prob(8);list(/obj/item/pickaxe/drill),
				prob(6);list(/obj/item/pickaxe/jackhammer),
				prob(5);list(/obj/item/pickaxe/gold),
				prob(4);list(/obj/item/pickaxe/plasmacutter),
				prob(2);list(/obj/item/pickaxe/diamond),
				prob(1);list(/obj/item/pickaxe/diamonddrill)
				)

/obj/random/multiple/underdark/ores
	name = "random underdark mining ore loot"
	desc = "Random mining utility loot for Underdark."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"

/obj/random/multiple/underdark/ores/item_to_spawn()
	return pick(
				prob(9);list(
							/obj/random/ore_bag,
							/obj/item/shovel,
							/obj/item/stack/ore/glass, //TODO: tell this legacy loot bullshit to fuck off so we don't have this happening.
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/glass,
							/obj/item/stack/ore/hydrogen,
							/obj/item/stack/ore/hydrogen,
							/obj/item/stack/ore/hydrogen,
							/obj/item/stack/ore/hydrogen,
							/obj/item/stack/ore/hydrogen,
							/obj/item/stack/ore/hydrogen
							),
				prob(7);list(
							/obj/random/ore_bag,
							/obj/item/pickaxe,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium,
							/obj/item/stack/ore/osmium
							),
				prob(4);list(
							/obj/item/clothing/suit/radiation,
							/obj/item/clothing/head/radiation,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium,
							/obj/item/stack/ore/uranium),
				prob(2);list(
							/obj/item/flashlight/lantern,
							/obj/item/clothing/glasses/material,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond,
							/obj/item/stack/ore/diamond
							),
				prob(1);list(
							/obj/item/mining_scanner,
							/obj/item/shovel/spade,
							/obj/item/stack/ore/verdantium,
							/obj/item/stack/ore/verdantium,
							/obj/item/stack/ore/verdantium,
							/obj/item/stack/ore/verdantium,
							/obj/item/stack/ore/verdantium
							)
				)

/obj/random/multiple/underdark/treasure
	name = "random underdark treasure"
	desc = "Random treasure loot for Underdark."
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"

/obj/random/multiple/underdark/treasure/item_to_spawn()
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

/obj/random/multiple/underdark/mechtool
	name = "random underdark mech equipment"
	desc = "Random mech equipment loot for Underdark."
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_clamp"

/obj/random/multiple/underdark/mechtool/item_to_spawn()
	return pick(
				prob(12);list(/obj/item/vehicle_module/tool/drill),
				prob(10);list(/obj/item/vehicle_module/tool/hydraulic_clamp),
				prob(8);list(/obj/item/vehicle_module/generator),
				// prob(7);list(/obj/item/vehicle_module/ballistic/scattershot/rigged),
				prob(6);list(/obj/item/vehicle_module/repair_droid),
				prob(3);list(/obj/item/vehicle_module/gravcatapult),
				// prob(2);list(/obj/item/vehicle_module/energy/riggedlaser),
				// prob(2);list(/obj/item/vehicle_module/energy/flamer/rigged),
				prob(1);list(/obj/item/vehicle_module/tool/drill/diamonddrill),
				)

