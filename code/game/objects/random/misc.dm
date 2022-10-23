/*
// This is going to get so incredibly bloated.
// But this is where all of the "Loot" goes. Anything fun or useful that doesn't deserve its own file, pile in.
*/

/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"

/obj/random/tool/item_to_spawn()
	return pick(/obj/item/tool/screwdriver,
				/obj/item/tool/wirecutters,
				/obj/item/weldingtool,
				/obj/item/weldingtool/largetank,
				/obj/item/tool/crowbar,
				/obj/item/tool/wrench,
				/obj/item/flashlight,
				/obj/item/multitool)

/obj/random/tool/powermaint
	name = "random powertool"
	desc = "This is a random rare powertool for maintenance"
	icon_state = "jaws_pry"

/obj/random/tool/powermaint/item_to_spawn()
	return pick(prob(320);/obj/random/tool,
				prob(1);/obj/item/tool/screwdriver/power,
				prob(1);/obj/item/tool/wirecutters/power,
				prob(15);/obj/item/weldingtool/electric,
				prob(5);/obj/item/weldingtool/experimental)

/obj/random/tool/power
	name = "random powertool"
	desc = "This is a random powertool"
	icon_state = "jaws_pry"

/obj/random/tool/power/item_to_spawn()
	return pick(/obj/item/tool/screwdriver/power,
				/obj/item/tool/wirecutters/power,
				/obj/item/weldingtool/electric,
				/obj/item/weldingtool/experimental)

/obj/random/tool/alien
	name = "random alien tool"
	desc = "This is a random tool"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder"

/obj/random/tool/alien/item_to_spawn()
	return pick(/obj/item/tool/screwdriver/alien,
				/obj/item/tool/wirecutters/alien,
				/obj/item/weldingtool/alien,
				/obj/item/tool/crowbar/alien,
				/obj/item/tool/wrench/alien,
				/obj/item/stack/cable_coil/alien,
				/obj/item/multitool/alien)

/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"

/obj/random/technology_scanner/item_to_spawn()
	return pick(prob(5);/obj/item/t_scanner,
				prob(2);/obj/item/radio,
				prob(5);/obj/item/analyzer)

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

/obj/random/powercell/item_to_spawn()
	return pick(prob(40);/obj/item/cell,
				prob(25);/obj/item/cell/device,
				prob(25);/obj/item/cell/high,
				prob(9);/obj/item/cell/super,
				prob(1);/obj/item/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/random/bomb_supply/item_to_spawn()
	return pick(/obj/item/assembly/igniter,
				/obj/item/assembly/prox_sensor,
				/obj/item/assembly/signaler,
				/obj/item/assembly/timer,
				/obj/item/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/toolbox/item_to_spawn()
	return pick(prob(6);/obj/item/storage/toolbox/mechanical,
				prob(6);/obj/item/storage/toolbox/electrical,
				prob(2);/obj/item/storage/toolbox/emergency,
				prob(1);/obj/item/storage/toolbox/syndicate)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 25

/obj/random/tech_supply/nofail
	name = "guaranteed random tech supply"
	spawn_nothing_percentage = 0

/obj/random/tech_supply/item_to_spawn()
	return pick(prob(3);/obj/random/powercell,
				prob(2);/obj/random/technology_scanner,
				prob(1);/obj/item/packageWrap,
				prob(2);/obj/random/bomb_supply,
				prob(1);/obj/item/extinguisher,
				prob(1);/obj/item/clothing/gloves/fyellow,
				prob(3);/obj/item/stack/cable_coil/random,
				prob(2);/obj/random/toolbox,
				prob(2);/obj/item/storage/belt/utility,
				prob(1);/obj/item/storage/belt/utility/full,
				prob(5);/obj/random/tool,
				prob(2);/obj/item/duct_tape_roll,
				prob(2);/obj/item/barrier_tape_roll/engineering,
				prob(1);/obj/item/barrier_tape_roll/atmos,
				prob(1);/obj/item/flashlight/maglight)

/obj/random/tech_supply/component
	name = "random tech component"
	desc = "This is a random machine component."
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_analyzer"

/obj/random/tech_supply/component/nofail
	name = "guaranteed random tech supply"
	spawn_nothing_percentage = 0

/obj/random/tech_supply/component/item_to_spawn()
	return pick(prob(3);/obj/item/stock_parts/gear,
		prob(2);/obj/item/stock_parts/console_screen,
		prob(1);/obj/item/stock_parts/spring,
		prob(3);/obj/item/stock_parts/capacitor,
		prob(2);/obj/item/stock_parts/capacitor/adv,
		prob(1);/obj/item/stock_parts/capacitor/super,
		prob(3);/obj/item/stock_parts/manipulator,
		prob(2);/obj/item/stock_parts/manipulator/nano,
		prob(1);/obj/item/stock_parts/manipulator/pico,
		prob(3);/obj/item/stock_parts/matter_bin,
		prob(2);/obj/item/stock_parts/matter_bin/adv,
		prob(1);/obj/item/stock_parts/matter_bin/super,
		prob(3);/obj/item/stock_parts/scanning_module,
		prob(2);/obj/item/stock_parts/scanning_module/adv,
		prob(1);/obj/item/stock_parts/scanning_module/phasic)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/stacks.dmi'
	icon_state = "traumakit"

/obj/random/medical/item_to_spawn()
	return pick(prob(21);/obj/random/medical/lite,
				prob(5);/obj/random/medical/pillbottle,
				prob(1);/obj/item/storage/pill_bottle/tramadol,
				prob(1);/obj/item/storage/pill_bottle/antitox,
				prob(1);/obj/item/storage/pill_bottle/carbon,
				prob(3);/obj/item/bodybag/cryobag,
				prob(5);/obj/item/reagent_containers/syringe/antitoxin,
				prob(3);/obj/item/reagent_containers/syringe/antiviral,
				prob(5);/obj/item/reagent_containers/syringe/inaprovaline,
				prob(1);/obj/item/reagent_containers/hypospray,
				prob(1);/obj/item/storage/box/freezer,
				prob(2);/obj/item/stack/nanopaste)

/obj/random/medical/pillbottle
	name = "Random Pill Bottle"
	desc = "This is a random pill bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill_canister"

/obj/random/medical/pillbottle/item_to_spawn()
	return pick(prob(1);/obj/item/storage/pill_bottle/spaceacillin,
				prob(1);/obj/item/storage/pill_bottle/dermaline,
				prob(1);/obj/item/storage/pill_bottle/dexalin_plus,
				prob(1);/obj/item/storage/pill_bottle/bicaridine,
				prob(1);/obj/item/storage/pill_bottle/iron)

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25

/obj/random/medical/lite/item_to_spawn()
	return pick(prob(4);/obj/item/stack/medical/bruise_pack,
				prob(4);/obj/item/stack/medical/ointment,
				prob(2);/obj/item/stack/medical/advanced/bruise_pack,
				prob(2);/obj/item/stack/medical/advanced/ointment,
				prob(1);/obj/item/stack/medical/splint,
				prob(4);/obj/item/healthanalyzer,
				prob(1);/obj/item/bodybag,
				prob(3);/obj/item/reagent_containers/hypospray/autoinjector,
				prob(2);/obj/item/storage/pill_bottle/kelotane,
				prob(2);/obj/item/storage/pill_bottle/antitox)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"

/obj/random/firstaid/item_to_spawn()
	return pick(prob(10);/obj/item/storage/firstaid/regular,
				prob(8);/obj/item/storage/firstaid/toxin,
				prob(8);/obj/item/storage/firstaid/o2,
				prob(6);/obj/item/storage/firstaid/adv,
				prob(8);/obj/item/storage/firstaid/fire,
				prob(1);/obj/item/storage/firstaid/combat)

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50
/obj/random/contraband/item_to_spawn()
	return pick(prob(6);/obj/item/storage/pill_bottle/tramadol,
				prob(8);/obj/item/haircomb,
				prob(4);/obj/item/storage/pill_bottle/happy,
				prob(4);/obj/item/storage/pill_bottle/zoom,
				prob(10);/obj/item/contraband/poster,
				prob(4);/obj/item/material/butterfly,
				prob(6);/obj/item/material/butterflyblade,
				prob(6);/obj/item/material/butterflyhandle,
				prob(6);/obj/item/material/wirerod,
				prob(2);/obj/item/material/butterfly/switchblade,
				prob(2);/obj/item/clothing/gloves/knuckledusters,
				prob(1);/obj/item/material/knife/tacknife,
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
				prob(1);/obj/item/beartrap,
				prob(1);/obj/item/handcuffs,
				prob(1);/obj/item/handcuffs/legcuffs,
				prob(2);/obj/item/reagent_containers/syringe/drugs,
				prob(1);/obj/item/reagent_containers/syringe/steroid)

/obj/random/cash
	name = "random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"

/obj/random/cash/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(12);/obj/item/spacecash/c1,
				prob(8);/obj/item/spacecash/c10,
				prob(4);/obj/item/spacecash/c20,
				prob(1);/obj/item/spacecash/c50,
				prob(1);/obj/item/spacecash/c100)

/obj/random/soap
	name = "Random Soap"
	desc = "This is a random bar of soap."
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"

/obj/random/soap/item_to_spawn()
	return pick(prob(3);/obj/item/soap,
				prob(2);/obj/item/soap/nanotrasen,
				prob(2);/obj/item/soap/deluxe,
				prob(1);/obj/item/soap/syndie)


/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"

/obj/random/drinkbottle/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/reagent_containers/food/drinks/bottle/gin,
				/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
				/obj/item/reagent_containers/food/drinks/bottle/vodka,
				/obj/item/reagent_containers/food/drinks/bottle/tequila,
				/obj/item/reagent_containers/food/drinks/bottle/absinthe,
				/obj/item/reagent_containers/food/drinks/bottle/wine,
				/obj/item/reagent_containers/food/drinks/bottle/cognac,
				/obj/item/reagent_containers/food/drinks/bottle/rum,
				/obj/item/reagent_containers/food/drinks/bottle/patron)

/obj/random/meat
	name = "random meat"
	desc = "This is a random slab of meat."
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"

/obj/random/meat/item_to_spawn()
	return pick(prob(60);/obj/item/reagent_containers/food/snacks/meat,
				prob(20);/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat,
				prob(10);/obj/item/reagent_containers/food/snacks/carpmeat,
				prob(5);/obj/item/reagent_containers/food/snacks/bearmeat,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/human,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/monkey,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/corgi,
				prob(1);/obj/item/reagent_containers/food/snacks/xenomeat)

/obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"

/obj/random/material/item_to_spawn()
	return pick(/obj/item/stack/material/steel{amount = 10},
				/obj/item/stack/material/glass{amount = 10},
				/obj/item/stack/material/glass/reinforced{amount = 10},
				/obj/item/stack/material/plastic{amount = 10},
				/obj/item/stack/material/wood{amount = 10},
				/obj/item/stack/material/cardboard{amount = 10},
				/obj/item/stack/rods{amount = 10},
				/obj/item/stack/material/plasteel{amount = 10})

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"

/obj/random/tank/item_to_spawn()
	return pick(prob(5);/obj/item/tank/oxygen,
				prob(4);/obj/item/tank/oxygen/yellow,
				prob(4);/obj/item/tank/oxygen/red,
				prob(3);/obj/item/tank/air,
				prob(4);/obj/item/tank/emergency/oxygen,
				prob(3);/obj/item/tank/emergency/oxygen/engi,
				prob(2);/obj/item/tank/emergency/oxygen/double,
				prob(1);/obj/item/suit_cooling_unit)

/obj/random/cigarettes
	name = "random cigarettes"
	desc = "This is a cigarette."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"

/obj/random/cigarettes/item_to_spawn()
	return pick(prob(5);/obj/item/storage/fancy/cigarettes,
				prob(4);/obj/item/storage/fancy/cigarettes/dromedaryco,
				prob(3);/obj/item/storage/fancy/cigarettes/killthroat,
				prob(3);/obj/item/storage/fancy/cigarettes/luckystars,
				prob(3);/obj/item/storage/fancy/cigarettes/jerichos,
				prob(3);/obj/item/storage/fancy/cigarettes/menthols,
				prob(3);/obj/item/storage/fancy/cigarettes/carcinomas,
				prob(3);/obj/item/storage/fancy/cigarettes/professionals,
				prob(1);/obj/item/storage/fancy/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/taj,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/taj/premium)

/obj/random/coin
	name = "random coin"
	desc = "This is a coin spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/coin/item_to_spawn()
	return pick(prob(5);/obj/item/coin/silver,
				prob(3);/obj/item/coin/iron,
				prob(4);/obj/item/coin/gold,
				prob(3);/obj/item/coin/phoron,
				prob(1);/obj/item/coin/uranium,
				prob(2);/obj/item/coin/platinum,
				prob(1);/obj/item/coin/durasteel,
				prob(1);/obj/item/coin/diamond)

/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"

/obj/random/action_figure/item_to_spawn()
	return pick(/obj/item/toy/figure/cmo,
				/obj/item/toy/figure/assistant,
				/obj/item/toy/figure/atmos,
				/obj/item/toy/figure/bartender,
				/obj/item/toy/figure/borg,
				/obj/item/toy/figure/gardener,
				/obj/item/toy/figure/captain,
				/obj/item/toy/figure/cargotech,
				/obj/item/toy/figure/ce,
				/obj/item/toy/figure/chaplain,
				/obj/item/toy/figure/chef,
				/obj/item/toy/figure/chemist,
				/obj/item/toy/figure/clown,
				/obj/item/toy/figure/corgi,
				/obj/item/toy/figure/detective,
				/obj/item/toy/figure/dsquad,
				/obj/item/toy/figure/engineer,
				/obj/item/toy/figure/geneticist,
				/obj/item/toy/figure/hop,
				/obj/item/toy/figure/hos,
				/obj/item/toy/figure/qm,
				/obj/item/toy/figure/janitor,
				/obj/item/toy/figure/agent,
				/obj/item/toy/figure/librarian,
				/obj/item/toy/figure/md,
				/obj/item/toy/figure/mime,
				/obj/item/toy/figure/miner,
				/obj/item/toy/figure/ninja,
				/obj/item/toy/figure/wizard,
				/obj/item/toy/figure/rd,
				/obj/item/toy/figure/roboticist,
				/obj/item/toy/figure/scientist,
				/obj/item/toy/figure/syndie,
				/obj/item/toy/figure/secofficer,
				/obj/item/toy/figure/warden,
				/obj/item/toy/figure/psychologist,
				/obj/item/toy/figure/paramedic,
				/obj/item/toy/figure/ert)

/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"

/obj/random/plushie/item_to_spawn()
	return pick(/obj/item/toy/plushie/nymph,
				/obj/item/toy/plushie/mouse,
				/obj/item/toy/plushie/kitten,
				/obj/item/toy/plushie/lizard,
				/obj/item/toy/plushie/black_cat,
				/obj/item/toy/plushie/black_fox,
				/obj/item/toy/plushie/blue_fox,
				/obj/random/carp_plushie,
				/obj/item/toy/plushie/coffee_fox,
				/obj/item/toy/plushie/corgi,
				/obj/item/toy/plushie/crimson_fox,
				/obj/item/toy/plushie/deer,
				/obj/item/toy/plushie/girly_corgi,
				/obj/item/toy/plushie/grey_cat,
				/obj/item/toy/plushie/marble_fox,
				/obj/item/toy/plushie/octopus,
				/obj/item/toy/plushie/orange_cat,
				/obj/item/toy/plushie/orange_fox,
				/obj/item/toy/plushie/pink_fox,
				/obj/item/toy/plushie/purple_fox,
				/obj/item/toy/plushie/red_fox,
				/obj/item/toy/plushie/robo_corgi,
				/obj/item/toy/plushie/siamese_cat,
				/obj/item/toy/plushie/spider,
				/obj/item/toy/plushie/tabby_cat,
				/obj/item/toy/plushie/tuxedo_cat,
				/obj/item/toy/plushie/white_cat)

/obj/random/plushielarge
	name = "random large plushie"
	desc = "This is a randomn large plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "droneplushie"

/obj/random/plushielarge/item_to_spawn()
	return pick(/obj/structure/plushie/ian,
				/obj/structure/plushie/drone,
				/obj/structure/plushie/carp,
				/obj/structure/plushie/beepsky)

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"

/obj/random/toy/item_to_spawn()
	return pick(/obj/item/toy/bosunwhistle,
				/obj/item/toy/plushie/therapy/red,
				/obj/item/toy/plushie/therapy/purple,
				/obj/item/toy/plushie/therapy/blue,
				/obj/item/toy/plushie/therapy/yellow,
				/obj/item/toy/plushie/therapy/orange,
				/obj/item/toy/plushie/therapy/green,
				/obj/item/toy/cultsword,
				/obj/item/toy/katana,
				/obj/item/toy/snappop,
				/obj/item/toy/sword,
				/obj/item/toy/balloon,
				/obj/item/toy/crossbow,
				/obj/item/toy/blink,
				/obj/item/toy/waterflower,
				/obj/item/toy/eight_ball,
				/obj/item/toy/eight_ball/conch,
				/obj/item/toy/prize/ripley,
				/obj/item/toy/prize/fireripley,
				/obj/item/toy/prize/deathripley,
				/obj/item/toy/prize/gygax,
				/obj/item/toy/prize/durand,
				/obj/item/toy/prize/honk,
				/obj/item/toy/prize/marauder,
				/obj/item/toy/prize/seraph,
				/obj/item/toy/prize/mauler,
				/obj/item/toy/prize/odysseus,
				/obj/item/toy/prize/phazon)

/obj/random/mouseremains
	name = "random mouseremains"
	desc = "For use with mouse spawners."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "mousetrap"

/obj/random/mouseremains/item_to_spawn()
	return pick(/obj/item/assembly/mousetrap,
				/obj/item/assembly/mousetrap/armed,
				/obj/effect/debris/cleanable/spiderling_remains,
				/obj/effect/debris/cleanable/ash,
				/obj/item/cigbutt,
				/obj/item/cigbutt/cigarbutt,
				/obj/effect/decal/remains/mouse)

/obj/random/alcohol //cit change starts
	name = "random booze"
	desc = "This is a random booze object."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"

/obj/random/alcohol/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/drinks/bottle/gin,
	/obj/item/reagent_containers/food/drinks/bottle/whiskey,
	/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
	/obj/item/reagent_containers/food/drinks/bottle/vodka,
	/obj/item/reagent_containers/food/drinks/bottle/tequila,
	/obj/item/reagent_containers/food/drinks/bottle/patron,
	/obj/item/reagent_containers/food/drinks/bottle/rum,
	/obj/item/reagent_containers/food/drinks/bottle/vermouth,
	/obj/item/reagent_containers/food/drinks/bottle/kahlua,
	/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
	/obj/item/reagent_containers/food/drinks/bottle/cognac,
	/obj/item/reagent_containers/food/drinks/bottle/wine,
	/obj/item/reagent_containers/food/drinks/bottle/absinthe,
	/obj/item/reagent_containers/food/drinks/bottle/melonliquor,
	/obj/item/reagent_containers/food/drinks/bottle/bluecuracao,
	/obj/item/reagent_containers/food/drinks/bottle/small/beer,
	/obj/item/reagent_containers/food/drinks/bottle/small/ale,
	/obj/item/reagent_containers/food/drinks/bottle/sake,
	/obj/item/reagent_containers/food/drinks/bottle/champagne,
	/obj/item/reagent_containers/food/drinks/bottle/victory_gin,
	/obj/item/reagent_containers/food/drinks/bottle/messa_mead)

/obj/random/janusmodule
	name = "random janus circuit"
	desc = "A random (possibly broken) Janus module."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "circuit_damaged"

/obj/random/janusmodule/item_to_spawn()
	return pick(subtypesof(/obj/item/circuitboard/mecha/imperion))

/obj/random/curseditem
	name = "random cursed item"
	desc = "For use in dungeons."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/curseditem/item_to_spawn()
	var/possible_object_paths = list(/obj/item/paper/carbon/cursedform)
	possible_object_paths |= subtypesof(/obj/item/clothing/head/psy_crown)
	return pick(possible_object_paths)

//Random MRE stuff

/obj/random/mre
	name = "random MRE"
	desc = "This is a random single MRE."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	drop_get_turf = FALSE

/obj/random/mre/item_to_spawn()
	return pick(/obj/item/storage/mre,
				/obj/item/storage/mre/menu2,
				/obj/item/storage/mre/menu3,
				/obj/item/storage/mre/menu4,
				/obj/item/storage/mre/menu5,
				/obj/item/storage/mre/menu6,
				/obj/item/storage/mre/menu7,
				/obj/item/storage/mre/menu8,
				/obj/item/storage/mre/menu9,
				/obj/item/storage/mre/menu10)


/obj/random/mre/main
	name = "random MRE main course"
	desc = "This is a random main course for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/main/item_to_spawn()
	return pick(/obj/item/storage/mrebag,
				/obj/item/storage/mrebag/menu2,
				/obj/item/storage/mrebag/menu3,
				/obj/item/storage/mrebag/menu4,
				/obj/item/storage/mrebag/menu5,
				/obj/item/storage/mrebag/menu6,
				/obj/item/storage/mrebag/menu7,
				/obj/item/storage/mrebag/menu8)

/obj/random/mre/side
	name = "random MRE side dish"
	desc = "This is a random side dish for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/side/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/tossedsalad,
				/obj/item/reagent_containers/food/snacks/boiledrice,
				/obj/item/reagent_containers/food/snacks/poppypretzel,
				/obj/item/reagent_containers/food/snacks/twobread,
				/obj/item/reagent_containers/food/snacks/jelliedtoast)

/obj/random/mre/dessert
	name = "random MRE dessert"
	desc = "This is a random dessert for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/dessert/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/candy/proteinbar,
				/obj/item/reagent_containers/food/snacks/donut/normal,
				/obj/item/reagent_containers/food/snacks/donut/cherryjelly,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/cookie)

/obj/random/mre/dessert/vegan
	name = "random vegan MRE dessert"
	desc = "This is a random vegan dessert for MREs."

/obj/random/mre/dessert/vegan/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/donut/cherryjelly,
				/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/drink/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/coffee,
				/obj/item/reagent_containers/food/condiment/small/packet/tea,
				/obj/item/reagent_containers/food/condiment/small/packet/cocoa,
				/obj/item/reagent_containers/food/condiment/small/packet/grape,
				/obj/item/reagent_containers/food/condiment/small/packet/orange,
				/obj/item/reagent_containers/food/condiment/small/packet/watermelon,
				/obj/item/reagent_containers/food/condiment/small/packet/apple)

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/spread/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/jelly,
				/obj/item/reagent_containers/food/condiment/small/packet/honey)

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs"

/obj/random/mre/spread/vegan/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/jelly)

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/sauce/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/reagent_containers/food/condiment/small/packet/sugar,
				/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
				/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
				/obj/item/reagent_containers/food/condiment/small/packet/mayo,
				/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/vegan/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/reagent_containers/food/condiment/small/packet/sugar,
				/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/sugarfree/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
				/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
				/obj/item/reagent_containers/food/condiment/small/packet/mayo,
				/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/crayon/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/crayon/generic,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/red,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/orange,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/yellow,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/green,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/blue,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/purple,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/grey,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/brown)

/obj/random/weapon // For Gateway maps and Syndicate. Can possibly spawn almost any gun in the game.
	name = "Random Illegal Weapon"
	desc = "This is a random illegal weapon."
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "p08"
	spawn_nothing_percentage = 50

/obj/random/weapon/item_to_spawn()
	return pick(
		prob(11);/obj/random/ammo_all,
		prob(11);/obj/item/gun/energy/laser,
		prob(11);/obj/item/gun/projectile/pirate,
		prob(10);/obj/item/material/twohanded/spear,
		prob(10);/obj/item/gun/energy/stunrevolver,
		prob(10);/obj/item/gun/energy/taser,
		prob(10);/obj/item/gun/projectile/shotgun/doublebarrel/pellet,
		prob(10);/obj/item/material/knife,
		prob(10);/obj/item/gun/projectile/luger,
		// prob(10);/obj/item/gun/projectile/pipegun,
		prob(10);/obj/item/gun/projectile/revolver/detective,
		prob(10);/obj/item/gun/projectile/revolver/judge,
		prob(10);/obj/item/gun/projectile/colt,
		prob(2);/obj/item/gun/projectile/colt/taj,
		prob(10);/obj/item/gun/projectile/shotgun/pump,
		prob(10);/obj/item/gun/projectile/shotgun/pump/rifle,
		prob(2);/obj/item/gun/projectile/shotgun/pump/rifle/taj,
		prob(10);/obj/item/melee/baton,
		prob(10);/obj/item/melee/telebaton,
		prob(10);/obj/item/melee/classic_baton,
		prob(9);/obj/item/gun/projectile/automatic/wt550/lethal,
		prob(9);/obj/item/gun/projectile/automatic/pdw,
		prob(9);/obj/item/gun/projectile/automatic/sol,
		prob(9);/obj/item/gun/energy/crossbow/largecrossbow,
		prob(9);/obj/item/gun/projectile/pistol,
		prob(9);/obj/item/gun/projectile/shotgun/pump,
		prob(9);/obj/item/cane/concealed,
		prob(9);/obj/item/gun/energy/gun,
		prob(8);/obj/item/gun/energy/retro,
		prob(8);/obj/item/gun/energy/gun/eluger,
		prob(8);/obj/item/gun/energy/xray,
		prob(8);/obj/item/gun/projectile/automatic/c20r,
		prob(8);/obj/item/melee/energy/sword,
		prob(8);/obj/item/gun/projectile/derringer,
		prob(8);/obj/item/gun/projectile/konigin,
		prob(8);/obj/item/gun/projectile/revolver/lemat,
		// prob(8);/obj/item/gun/projectile/shotgun/pump/rifle/mosin,
		// prob(8);/obj/item/gun/projectile/automatic/m41a,
		prob(7);/obj/item/material/butterfly,
		prob(7);/obj/item/material/butterfly/switchblade,
		prob(7);/obj/item/gun/projectile/giskard,
		prob(7);/obj/item/gun/projectile/automatic/p90,
		prob(7);/obj/item/gun/projectile/automatic/sts35,
		prob(7);/obj/item/gun/projectile/shotgun/pump/combat,
		prob(6);/obj/item/gun/energy/sniperrifle,
		prob(6);/obj/item/gun/projectile/automatic/z8,
		prob(6);/obj/item/gun/energy/captain,
		prob(6);/obj/item/material/knife/tacknife,
		prob(5);/obj/item/gun/projectile/shotgun/pump/JSDF,
		prob(5);/obj/item/gun/projectile/giskard/olivaw,
		prob(5);/obj/item/gun/projectile/revolver/consul,
		prob(5);/obj/item/gun/projectile/revolver/mateba,
		prob(5);/obj/item/gun/projectile/revolver,
		prob(4);/obj/item/gun/projectile/deagle,
		prob(4);/obj/item/gun/projectile/deagle/taj,
		prob(4);/obj/item/material/knife/tacknife/combatknife,
		prob(4);/obj/item/melee/energy/sword,
		prob(2);/obj/item/gun/projectile/automatic/mini_uzi,
		prob(2);/obj/item/gun/projectile/automatic/mini_uzi/taj,
		prob(4);/obj/item/gun/projectile/automatic/wt274,
		prob(4);/obj/item/gun/projectile/contender,
		prob(4);/obj/item/gun/projectile/contender/tacticool,
		prob(4);/obj/item/gun/projectile/contender/taj,
		prob(3);/obj/item/gun/projectile/SVD,
		prob(3);/obj/item/gun/energy/lasercannon,
		prob(3);/obj/item/gun/projectile/shotgun/pump/rifle/lever,
		prob(3);/obj/item/gun/projectile/automatic/bullpup,
		prob(2);/obj/item/gun/energy/pulse_rifle,
		prob(2);/obj/item/gun/energy/gun/nuclear,
		prob(2);/obj/item/gun/projectile/automatic/l6_saw,
		prob(2);/obj/item/gun/energy/gun/burst,
		prob(2);/obj/item/storage/box/frags,
		prob(2);/obj/item/material/twohanded/fireaxe,
		prob(2);/obj/item/gun/projectile/luger/brown,
		prob(2);/obj/item/gun/launcher/crossbow,
		// prob(1);/obj/item/gun/projectile/automatic/battlerifle, // Too OP
		prob(1);/obj/item/gun/projectile/deagle/gold,
		prob(1);/obj/item/gun/energy/imperial,
		prob(1);/obj/item/gun/projectile/automatic/as24,
		prob(1);/obj/item/gun/projectile/rocket,
		prob(1);/obj/item/gun/launcher/grenade,
		prob(1);/obj/item/gun/projectile/gyropistol,
		prob(1);/obj/item/gun/projectile/heavysniper,
		prob(1);/obj/item/plastique,
		prob(1);/obj/item/gun/energy/ionrifle,
		prob(1);/obj/item/material/sword,
		prob(1);/obj/item/cane/concealed,
		prob(1);/obj/item/material/sword/katana,
	)

/obj/random/weapon/guarenteed
	spawn_nothing_percentage = 0

/obj/random/ammo_all
	name = "Random Ammunition (All)"
	desc = "This is random ammunition. Spawns all ammo types."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "666"

/obj/random/ammo_all/item_to_spawn()
	return pick(
		prob(5);/obj/item/storage/box/shotgunammo,
		prob(5);/obj/item/storage/box/shotgunshells,
		prob(5);/obj/item/ammo_magazine/clip/c762,
		prob(5);/obj/item/ammo_magazine/m380,
		prob(5);/obj/item/ammo_magazine/m45,
		prob(5);/obj/item/ammo_magazine/m9mm,
		prob(5);/obj/item/ammo_magazine/s38,
		prob(4);/obj/item/ammo_magazine/clip/c45,
		prob(4);/obj/item/ammo_magazine/clip/c9mm,
		prob(4);/obj/item/ammo_magazine/m45uzi,
		prob(4);/obj/item/ammo_magazine/m45uzi/wt274,
		prob(4);/obj/item/ammo_magazine/m9mml,
		prob(4);/obj/item/ammo_magazine/m9mmt,
		prob(4);/obj/item/ammo_magazine/m57x28mmp90,
		prob(4);/obj/item/ammo_magazine/m10mm,
		prob(4);/obj/item/ammo_magazine/m545/small,
		prob(3);/obj/item/ammo_magazine/clip/c10mm,
		prob(3);/obj/item/ammo_magazine/clip/c44,
		prob(3);/obj/item/ammo_magazine/s44,
		prob(3);/obj/item/ammo_magazine/m762,
		prob(3);/obj/item/ammo_magazine/m545,
		prob(3);/obj/item/cell/device/weapon,
		prob(2);/obj/item/ammo_magazine/m44,
		prob(2);/obj/item/ammo_magazine/s357,
		prob(2);/obj/item/ammo_magazine/m762m,
		prob(2);/obj/item/ammo_magazine/clip/c12g,
		prob(2);/obj/item/ammo_magazine/clip/c12g/pellet,
		prob(1);/obj/item/ammo_magazine/m45tommy,
		// prob(1);/obj/item/ammo_magazine/m95,
		prob(1);/obj/item/ammo_casing/rocket,
		prob(1);/obj/item/storage/box/sniperammo,
		prob(1);/obj/item/storage/box/flashshells,
		prob(1);/obj/item/storage/box/beanbags,
		prob(1);/obj/item/storage/box/stunshells,
		prob(1);/obj/item/ammo_magazine/mtg,
		prob(1);/obj/item/ammo_magazine/m12gdrum,
		prob(1);/obj/item/ammo_magazine/m12gdrum/pellet,
		prob(1);/obj/item/ammo_magazine/m45tommydrum,
	)

/obj/random/cargopod
	name = "Random Cargo Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"

/obj/random/cargopod/item_to_spawn()
	return pick(prob(10);/obj/item/contraband/poster,\
				prob(8);/obj/item/haircomb,\
				prob(6);/obj/item/material/wirerod,\
				prob(6);/obj/item/storage/pill_bottle/tramadol,\
				prob(6);/obj/item/material/butterflyblade,\
				prob(6);/obj/item/material/butterflyhandle,\
				prob(4);/obj/item/storage/pill_bottle/happy,\
				prob(4);/obj/item/storage/pill_bottle/zoom,\
				prob(4);/obj/item/material/butterfly,\
				prob(2);/obj/item/material/butterfly/switchblade,\
				prob(2);/obj/item/clothing/gloves/knuckledusters,\
				prob(2);/obj/item/reagent_containers/syringe/drugs,\
				prob(1);/obj/item/material/knife/tacknife,\
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,\
				prob(1);/obj/item/beartrap,\
				prob(1);/obj/item/handcuffs,\
				prob(1);/obj/item/handcuffs/legcuffs,\
				prob(1);/obj/item/reagent_containers/syringe/steroid)

//Just overriding this here, no more super medkit so those can be reserved for PoIs and such
/obj/random/tetheraid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit. Does not include Combat Kits."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"

/obj/random/tetheraid/item_to_spawn()
	return pick(prob(4);/obj/item/storage/firstaid/regular,
				prob(3);/obj/item/storage/firstaid/toxin,
				prob(3);/obj/item/storage/firstaid/o2,
				prob(2);/obj/item/storage/firstaid/adv,
				prob(3);/obj/item/storage/firstaid/fire)

//Override from maintenance.dm to prevent combat kits from spawning in Tether maintenance
/obj/random/maintenance/item_to_spawn()
	return pick(prob(300);/obj/random/tech_supply,
				prob(200);/obj/random/medical,
				prob(100);/obj/random/tetheraid,
				prob(10);/obj/random/contraband,
				prob(50);/obj/random/action_figure,
				prob(50);/obj/random/plushie,
				prob(200);/obj/random/junk,
				prob(200);/obj/random/material,
				prob(50);/obj/random/toy,
				prob(100);/obj/random/tank,
				prob(50);/obj/random/soap,
				prob(60);/obj/random/drinkbottle,
				prob(500);/obj/random/maintenance/clean)

/obj/random/action_figure/supplypack
	drop_get_turf = FALSE

/obj/random/roguemineloot
	name = "Random Rogue Mines Item"
	desc = "Hot Stuff. Hopefully"
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"
	spawn_nothing_percentage = 0

/obj/random/roguemineloot/item_to_spawn()
	return pick(prob(5);/obj/random/mre,
				prob(5);/obj/random/maintenance,
				prob(4);/obj/random/firstaid,
				prob(3);/obj/random/toolbox,
				prob(2);/obj/random/multiple/minevault,
				prob(1);/obj/random/coin,
				prob(1);/obj/random/drinkbottle,
				prob(1);/obj/random/tool/alien)

/obj/random/slimecore
	name = "random slime core"
	desc = "Random slime core."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "rainbow slime extract"

/obj/random/slimecore/item_to_spawn()
	return pick(prob(3);/obj/item/slime_extract/metal,
				prob(3);/obj/item/slime_extract/blue,
				prob(3);/obj/item/slime_extract/purple,
				prob(3);/obj/item/slime_extract/orange,
				prob(3);/obj/item/slime_extract/yellow,
				prob(3);/obj/item/slime_extract/gold,
				prob(3);/obj/item/slime_extract/silver,
				prob(3);/obj/item/slime_extract/dark_purple,
				prob(3);/obj/item/slime_extract/dark_blue,
				prob(3);/obj/item/slime_extract/red,
				prob(3);/obj/item/slime_extract/green,
				prob(3);/obj/item/slime_extract/pink,
				prob(2);/obj/item/slime_extract/oil,
				prob(2);/obj/item/slime_extract/bluespace,
				prob(2);/obj/item/slime_extract/cerulean,
				prob(2);/obj/item/slime_extract/amber,
				prob(2);/obj/item/slime_extract/sapphire,
				prob(2);/obj/item/slime_extract/ruby,
				prob(2);/obj/item/slime_extract/emerald,
				prob(2);/obj/item/slime_extract/light_pink,
				prob(1);/obj/item/slime_extract/grey,
				prob(1);/obj/item/slime_extract/rainbow)

/obj/random/triumph
	name = "random triumph loot"
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"

/obj/random/triumph/item_to_spawn()
	return pick(prob(3);/obj/random/multiple/miningdrills,
				prob(3);/obj/random/multiple/ores,
				prob(2);/obj/random/multiple/treasure,
				prob(1);/obj/random/multiple/mechtool)

/obj/random/triumph/uncertain
	icon_state = "upickaxe"
	spawn_nothing_percentage = 65	//only 33% to spawn loot

/obj/random/multiple/miningdrills
	name = "random mining tool loot"
	icon = 'icons/obj/items.dmi'
	icon_state = "spickaxe"

/obj/random/multiple/miningdrills/item_to_spawn()
	return pick(
				prob(10);list(/obj/item/pickaxe/silver),
				prob(8);list(/obj/item/pickaxe/drill),
				prob(6);list(/obj/item/pickaxe/jackhammer),
				prob(5);list(/obj/item/pickaxe/gold),
				prob(4);list(/obj/item/pickaxe/plasmacutter),
				prob(2);list(/obj/item/pickaxe/diamond),
				prob(1);list(/obj/item/pickaxe/diamonddrill)
				)

/obj/random/multiple/ores
	name = "random mining ore loot"
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"

/obj/random/multiple/ores/item_to_spawn()
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

/obj/random/multiple/treasure
	name = "random treasure"
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"

/obj/random/multiple/treasure/item_to_spawn()
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

/obj/random/multiple/mechtool
	name = "random mech equipment"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_clamp"

/obj/random/multiple/mechtool/item_to_spawn()
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

//Random Bedsheet Spawner
/obj/random/bedsheet
	name = "random bedsheet"
	desc = "Used to spawn a random bedsheet."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet"

/obj/random/bedsheet/item_to_spawn()
	return pick(/obj/item/bedsheet/red,
				/obj/item/bedsheet/orange,
				/obj/item/bedsheet/yellow,
				/obj/item/bedsheet/green,
				/obj/item/bedsheet/blue,
				/obj/item/bedsheet/purple,
				/obj/item/bedsheet/brown,
				/obj/item/bedsheet/rainbow,
				/obj/item/bedsheet/captain,
				/obj/item/bedsheet/hop,
				/obj/item/bedsheet/rd,
				/obj/item/bedsheet/ce,
				/obj/item/bedsheet/hos,
				/obj/item/bedsheet/medical,
				/obj/item/bedsheet/ian,
				/obj/item/bedsheet/clown,
				/obj/item/bedsheet/mime,
				/obj/item/bedsheet/cosmos)

/obj/random/bedsheet/double
	name = "random double bedsheet"
	desc = "Used to spawn a random double-bedsheet."
	icon_state = "doublesheet"

/obj/random/bedsheet/double/item_to_spawn()
	return pick(/obj/item/bedsheet/reddouble,
				/obj/item/bedsheet/orangedouble,
				/obj/item/bedsheet/yellowdouble,
				/obj/item/bedsheet/greendouble,
				/obj/item/bedsheet/bluedouble,
				/obj/item/bedsheet/purpledouble,
				/obj/item/bedsheet/browndouble,
				/obj/item/bedsheet/rainbowdouble,
				/obj/item/bedsheet/captaindouble,
				/obj/item/bedsheet/hopdouble,
				/obj/item/bedsheet/rddouble,
				/obj/item/bedsheet/cedouble,
				/obj/item/bedsheet/hosdouble,
				/obj/item/bedsheet/iandouble,
				/obj/item/bedsheet/clowndouble,
				/obj/item/bedsheet/mimedouble,
				/obj/item/bedsheet/cosmosdouble)

/obj/random/paintkit
	name = "random paint kit (APLU)"
	desc = "Used to spawn a random APLU paint kit."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"

/obj/random/paintkit/item_to_spawn()
	return pick(/obj/item/kit/paint/ripley,
				/obj/item/kit/paint/ripley/death,
				/obj/item/kit/paint/ripley/flames_red,
				/obj/item/kit/paint/ripley/flames_blue,
				/obj/item/kit/paint/ripley/pirate,
				/obj/item/kit/paint/ripley/junker,
				/obj/item/kit/paint/ripley/battered,
				/obj/item/kit/paint/ripley/medical,
				/obj/item/kit/paint/ripley/sovjet,
				/obj/item/kit/paint/ripley/arnold,
				/obj/item/kit/paint/ripley/clown,
				/obj/item/kit/paint/ripley/dreadnought)

/obj/random/paintkit/gygax
	name = "random paint kit (Gygax)"
	desc = "Used to spawn a random Gygax paint kit."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"

/obj/random/paintkit/gygax/item_to_spawn()
	return pick(/obj/item/kit/paint/gygax,
				/obj/item/kit/paint/gygax/blue,
				/obj/item/kit/paint/gygax/green,
				/obj/item/kit/paint/gygax/turtle,
				/obj/item/kit/paint/gygax/mad_jack,
				/obj/item/kit/paint/gygax/osbourne,
				/obj/item/kit/paint/gygax/carp)

/obj/random/paintkit/durand
	name = "random paint kit (Durand)"
	desc = "Used to spawn a random Durand paint kit."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"

/obj/random/paintkit/durand/item_to_spawn()
	return pick(/obj/item/kit/paint/durand,
				/obj/item/kit/paint/durand/paladin,
				/obj/item/kit/paint/durand/turtle)
