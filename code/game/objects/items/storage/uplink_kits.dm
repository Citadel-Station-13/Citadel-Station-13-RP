/obj/item/storage/box/syndicate/Initialize(mapload)
	switch (pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1)))
		if("bloodyspai")
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/clothing/mask/gas/voice(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)

		if("stealth")
			new /obj/item/gun/projectile/energy/crossbow(src)
			new /obj/item/pen/reagent/paralysis(src)
			new /obj/item/chameleon(src)

		if("screwed")
			new /obj/effect/spawner/newbomb/timer/syndicate(src)
			new /obj/effect/spawner/newbomb/timer/syndicate(src)
			new /obj/item/powersink(src)
			new /obj/item/clothing/suit/space/syndicate(src)
			new /obj/item/clothing/head/helmet/space/syndicate(src)
			new /obj/item/clothing/mask/gas/syndicate(src)
			new /obj/item/tank/emergency/oxygen/double(src)

		if("guns")
			new /obj/item/gun/projectile/ballistic/revolver(src)
			new /obj/item/ammo_magazine/a357/speedloader(src)
			new /obj/item/card/emag(src)
			new /obj/item/plastique(src)
			new /obj/item/plastique(src)

		if("murder")
			new /obj/item/melee/transforming/energy/sword(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/card/emag(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)

		if("freedom")
			var/obj/item/implanter/O = new /obj/item/implanter(src)
			O.imp = new /obj/item/implant/freedom(O)
			var/obj/item/implanter/U = new /obj/item/implanter(src)
			U.imp = new /obj/item/implant/uplink(U)

		if("hacker")
			new /obj/item/encryptionkey/syndicate(src)
			new /obj/item/aiModule/syndicate(src)
			new /obj/item/card/emag(src)
			new /obj/item/encryptionkey/binary(src)

		if("lordsingulo")
			new /obj/item/radio/beacon/syndicate(src)
			new /obj/item/clothing/suit/space/syndicate(src)
			new /obj/item/clothing/head/helmet/space/syndicate(src)
			new /obj/item/clothing/mask/gas/syndicate(src)
			new /obj/item/tank/emergency/oxygen/double(src)
			new /obj/item/card/emag(src)

		if("smoothoperator")
			new /obj/item/storage/box/syndie_kit/g9mm(src)
			new /obj/item/storage/bag/trash(src)
			new /obj/item/soap/syndie(src)
			new /obj/item/bodybag(src)
			new /obj/item/clothing/under/suit_jacket(src)
			new /obj/item/clothing/shoes/laceup(src)
	. = ..()

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_freedom/Initialize(mapload)
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/freedom(O)
	O.update()
	. = ..()

/obj/item/storage/box/syndie_kit/imp_compress
	name = "box (C)"
	starts_with = list(/obj/item/implanter/compressed)

/obj/item/storage/box/syndie_kit/imp_explosive
	name = "box (E)"
	starts_with = list(/obj/item/implanter/explosive)

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_uplink/Initialize(mapload)
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/uplink(O)
	O.update()
	. = ..()

/obj/item/storage/box/syndie_kit/imp_aug
	name = "boxed augment implant (with injector)"
	var/case_type = /obj/item/implantcase/shades

/obj/item/storage/box/syndie_kit/imp_aug/Initialize(mapload)
	new /obj/item/implanter(src)
	new case_type(src)
	. = ..()

/obj/item/storage/box/syndie_kit/imp_aug/taser
	case_type = /obj/item/implantcase/taser

/obj/item/storage/box/syndie_kit/imp_aug/laser
	case_type = /obj/item/implantcase/laser

/obj/item/storage/box/syndie_kit/imp_aug/dart
	case_type = /obj/item/implantcase/dart

/obj/item/storage/box/syndie_kit/imp_aug/toolkit
	case_type = /obj/item/implantcase/toolkit

/obj/item/storage/box/syndie_kit/imp_aug/medkit
	case_type = /obj/item/implantcase/medkit

/obj/item/storage/box/syndie_kit/imp_aug/surge
	case_type = /obj/item/implantcase/surge

/obj/item/storage/box/syndie_kit/imp_aug/analyzer
	case_type = /obj/item/implantcase/analyzer

/obj/item/storage/box/syndie_kit/imp_aug/sword
	case_type = /obj/item/implantcase/sword

/obj/item/storage/box/syndie_kit/imp_aug/sprinter
	case_type = /obj/item/implantcase/sprinter

/obj/item/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"
	starts_with = list(
		/obj/item/clothing/suit/space/syndicate,
		/obj/item/clothing/head/helmet/space/syndicate,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/tank/emergency/oxygen/double
	)

/obj/item/storage/box/syndie_kit/chameleon
	name = "chameleon kit"
	desc = "Comes with all the clothes you need to impersonate most people.  Acting lessons sold seperately."
	starts_with = list(
		/obj/item/clothing/under/chameleon,
		/obj/item/clothing/head/chameleon,
		/obj/item/clothing/suit/chameleon,
		/obj/item/clothing/shoes/chameleon,
		/obj/item/storage/backpack/chameleon,
		/obj/item/clothing/gloves/chameleon,
		/obj/item/clothing/mask/chameleon,
		/obj/item/clothing/glasses/chameleon,
		/obj/item/clothing/accessory/chameleon,
		/obj/item/gun/projectile/energy/chameleon
	)

/obj/item/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."
	starts_with = list(
		/obj/item/stamp/chameleon,
		/obj/item/pen/chameleon,
		/obj/item/destTagger,
		/obj/item/packageWrap,
		/obj/item/hand_labeler
	)

/obj/item/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."
	starts_with = list(
		/obj/item/camerabug/spy = 6,
		/obj/item/bug_monitor/spy
	)

/obj/item/storage/box/syndie_kit/g9mm
	name = "\improper Smooth operator"
	desc = "Compact 9mm with silencer kit."
	starts_with = list(
		/obj/item/gun/projectile/ballistic/pistol,
		/obj/item/silencer
	)

/obj/item/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."
	starts_with = list(
		/obj/item/reagent_containers/glass/beaker/vial/random/toxin,
		/obj/item/reagent_containers/syringe
	)

/obj/item/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/storage/box/syndie_kit/cigarette/Initialize(mapload)
	. = ..()
	var/obj/item/storage/fancy/cigarettes/pack

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "nitrogen" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5, "hydrogen" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = new /obj/item/storage/fancy/cigarettes(src)
	pack.reagents.add_reagent("tricordrazine", 15 * pack.max_items)
	pack.desc += " 'T' has been scribbled on it."

	new /obj/item/flame/lighter/zippo(src)

	//calibrate_size()

/proc/fill_cigarre_package(var/obj/item/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.max_items)

/obj/item/storage/box/syndie_kit/ewar_voice
	name = "Electrowarfare and Voice Synthesizer kit"
	desc = "Kit for confounding organic and synthetic entities alike."
	starts_with = list(
		/obj/item/hardsuit_module/electrowarfare_suite,
		/obj/item/hardsuit_module/voice
	)

/obj/item/storage/secure/briefcase/money
	name = "suspicious briefcase"
	desc = "An ominous briefcase that has the unmistakeable smell of old, stale, cigarette smoke, and gives those who look at it a bad feeling."
	starts_with = list(/obj/item/spacecash/c1000 = 10)

/obj/item/storage/box/syndie_kit/combat_armor
	name = "combat armor kit"
	desc = "Contains a full set of combat armor."
	starts_with = list(
		/obj/item/clothing/head/helmet/combat,
		/obj/item/clothing/suit/armor/combat,
		/obj/item/clothing/gloves/arm_guard/combat,
		/obj/item/clothing/shoes/leg_guard/combat
	)

/obj/item/storage/box/syndie_kit/demolitions
	starts_with = list(
		/obj/item/syndie/c4explosive,
		/obj/item/tool/screwdriver
	)

/obj/item/storage/box/syndie_kit/demolitions_heavy
	starts_with = list(
		/obj/item/syndie/c4explosive/heavy,
		/obj/item/tool/screwdriver
	)

/obj/item/storage/box/syndie_kit/demolitions_super_heavy
	starts_with = list(
		/obj/item/syndie/c4explosive/heavy/super_heavy,
		/obj/item/tool/screwdriver
	)

/obj/item/storage/secure/briefcase/rifle
	name = "secure briefcase"
	starts_with = list(
		/obj/item/sniper_rifle_part/barrel,
		/obj/item/sniper_rifle_part/stock,
		/obj/item/sniper_rifle_part/trigger_group,
		/obj/item/ammo_casing/a12_7mm = 4
	)

/obj/item/storage/secure/briefcase/fuelrod
	name = "heavy briefcase"
	desc = "A heavy, locked briefcase."
	description_fluff = "The container, upon opening, looks to have a few oddly shaped indentations in its packing."
	description_antag = "This case will likely contain a charged fuel rod gun, and a few fuel rods to go with it. It can only hold the fuel rod gun, fuel rods, batteries, a screwdriver, and stock machine parts."
	damage_force = 12 //Anti-rad lined i.e. Lead, probably gonna hurt a bit if you get bashed with it.
	insertion_whitelist = list(/obj/item/gun/projectile/magnetic/fuelrod, /obj/item/fuel_assembly, /obj/item/cell, /obj/item/stock_parts, /obj/item/tool/screwdriver)
	insertion_blacklist = list(/obj/item/tool/screwdriver/power)
	starts_with = list(
		/obj/item/gun/projectile/magnetic/fuelrod,
		/obj/item/fuel_assembly/deuterium,
		/obj/item/fuel_assembly/deuterium,
		/obj/item/fuel_assembly/tritium,
		/obj/item/fuel_assembly/tritium,
		/obj/item/fuel_assembly/phoron,
		/obj/item/tool/screwdriver
	)
