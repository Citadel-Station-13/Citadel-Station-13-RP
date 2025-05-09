/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	products = list(
		/obj/item/handcuffs = 8,
		/obj/item/grenade/simple/flashbang = 4,
		/obj/item/flash = 5,
		/obj/item/reagent_containers/spray/pepper = 6,
		/obj/item/reagent_containers/food/snacks/donut/normal = 12,
		/obj/item/storage/box/evidence = 6,
		/obj/item/gun/projectile/ballistic/sec = 2,
		/obj/item/ammo_magazine/a45/doublestack/rubber = 6,
		/obj/item/clothing/mask/gas/half = 6,
		/obj/item/clothing/glasses/omnihud/sec = 6,
		/obj/item/hailer = 6,
		/obj/item/barrier_tape_roll/police = 6,
		/obj/item/flashlight/glowstick = 6,
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/storage/box/donut = 2,
	)
	req_log_access = ACCESS_SECURITY_ARMORY
	has_logs = 1
