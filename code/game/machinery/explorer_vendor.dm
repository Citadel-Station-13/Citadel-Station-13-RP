/obj/item/weapon/spacecash/expedition_voucher
	name = "expedition equipment voucher"
	icon_state = "efundcard"
	desc = "A card that holds credits for explorer equipment."
	worth = 20
	attack_self() return  //Don't act
	attackby()    return  //like actual
	update_icon() return //space cash

/obj/item/weapon/spacecash/expedition_voucher/examine(mob/user)
	..(user)
	if (!(user in view(2)) && user!=src.loc) return
	user << "<font color='blue'>Points remaining: [src.worth]</font>"

/obj/item/weapon/spacecash/expedition_voucher/pilot
	name = "Pilot Equipment Voucher"
	desc = "A card that holds credits for explorer equipment. This one is meant for pilots and has half as many points."
	worth = 10

/obj/machinery/vending/explorer_equipment
	name = "Explorer Outfitter"
	desc = "A one stop shop for weapons and equipment for explorers. A plate on the side says property of the Void Runners, LLC \
	and a long list of warnings, waivers, and legal speak for using this machine."
	product_ads = "For reaping what you sow.;For when their isn't enough prayer in schools.;Spare medicine is always a \
	good idea!.;Don't forget spare ammo!;Your weapons are right here.;Big bags for big guns!;We assume your licensed!;Friendly \
	fire violates the NAP!;Shall not be infringed!;You can never have enough guns!"
	icon_state = "generic"
	vend_delay = 10
	req_access = list(access_explorer)
	products = list(/obj/item/weapon/cell/device/weapon = 100,								// Lasers
							/obj/item/weapon/gun/energy/exlaserrifle/locked = 9,
							/obj/item/weapon/gun/energy/exlaserpistol/locked = 9,
							/obj/item/weapon/gun/energy/exlasersmg/locked = 9,
							/obj/item/weapon/gun/energy/exlasershotgun/locked = 9,
							/obj/item/weapon/shield/riot = 7, 								// Armor
							/obj/item/clothing/suit/armor/combat/explorer = 7,
							/obj/item/clothing/head/helmet/combat = 7,
							/obj/item/clothing/gloves/arm_guard/combat = 7,
							/obj/item/clothing/shoes/leg_guard/combat = 7,
							/obj/item/clothing/suit/armor/riot/explorer = 7,
							/obj/item/clothing/head/helmet/riot = 7,
							/obj/item/clothing/gloves/arm_guard/riot = 7,
							/obj/item/clothing/shoes/leg_guard/riot = 7,
							/obj/item/clothing/suit/armor/bulletproof/explorer = 7,
							/obj/item/clothing/head/helmet/bulletproof = 7,
							/obj/item/clothing/shoes/leg_guard/bulletproof = 7,
							/obj/item/clothing/gloves/arm_guard/bulletproof = 7,
							/obj/item/clothing/suit/armor/laserproof/explorer = 7,
							/obj/item/clothing/head/helmet/laserproof = 7,
							/obj/item/clothing/shoes/leg_guard/laserproof = 7,
							/obj/item/clothing/gloves/arm_guard/laserproof = 7,
							/obj/item/kevlarupgrade = 9,
							/obj/item/weapon/storage/firstaid/regular = 4,					//Medical
							/obj/item/weapon/storage/firstaid/adv = 4,
							/obj/item/weapon/storage/firstaid/combat = 4,
							/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting = 4,
							/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner = 4,
							/obj/item/bodybag/cryobag = 4,
							/obj/item/device/defib_kit/compact/combat = 2,
							/obj/item/device/survivalcapsule/luxury = 2,
							/obj/item/weapon/storage/backpack/dufflebag/syndie = 9,			// Equipment
							/obj/item/weapon/storage/belt/security/explorer = 9,
							/obj/item/weapon/storage/belt/security/tactical/bandolier/explorer = 9,
							/obj/item/clothing/accessory/storage/brown_vest = 9,
							/obj/item/clothing/accessory/storage/black_vest = 9,
							/obj/item/clothing/accessory/storage/white_vest = 9,
							/obj/item/clothing/accessory/holster/armpit = 9,
							/obj/item/clothing/accessory/holster/waist = 9,
							/obj/item/clothing/accessory/holster/hip = 9,
							/obj/item/clothing/accessory/holster/leg = 9)



	prices = list(/obj/item/weapon/cell/device/weapon = 1,									// Lasers
							/obj/item/weapon/gun/energy/exlaserrifle/locked = 5,
							/obj/item/weapon/gun/energy/exlaserpistol/locked = 3,
							/obj/item/weapon/gun/energy/exlasersmg/locked = 5,
							/obj/item/weapon/gun/energy/exlasershotgun/locked = 6,
							/obj/item/weapon/shield/riot = 2, 								// Armor
							/obj/item/clothing/suit/armor/combat/explorer = 3,
							/obj/item/clothing/head/helmet/combat = 2,
							/obj/item/clothing/gloves/arm_guard/combat = 2,
							/obj/item/clothing/shoes/leg_guard/combat = 2,
							/obj/item/clothing/suit/armor/riot/explorer = 3,
							/obj/item/clothing/head/helmet/riot = 2,
							/obj/item/clothing/gloves/arm_guard/riot = 2,
							/obj/item/clothing/shoes/leg_guard/riot = 2,
							/obj/item/clothing/suit/armor/bulletproof/explorer = 3,
							/obj/item/clothing/head/helmet/bulletproof = 2,
							/obj/item/clothing/shoes/leg_guard/bulletproof = 2,
							/obj/item/clothing/gloves/arm_guard/bulletproof = 2,
							/obj/item/clothing/suit/armor/laserproof/explorer = 3,
							/obj/item/clothing/head/helmet/laserproof = 2,
							/obj/item/clothing/shoes/leg_guard/laserproof = 2,
							/obj/item/clothing/gloves/arm_guard/laserproof = 2,
							/obj/item/kevlarupgrade = 1,
							/obj/item/weapon/storage/firstaid/regular = 1,					//Medical
							/obj/item/weapon/storage/firstaid/adv = 2,
							/obj/item/weapon/storage/firstaid/combat = 3,
							/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting = 5,
							/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner = 4,
							/obj/item/bodybag/cryobag = 1,
							/obj/item/device/defib_kit/compact/combat = 5,
							/obj/item/device/survivalcapsule/luxury = 6,
							/obj/item/weapon/storage/backpack/dufflebag/syndie = 6,			// Equipment
							/obj/item/weapon/storage/belt/security/explorer = 1,
							/obj/item/weapon/storage/belt/security/tactical/bandolier/explorer = 1,
							/obj/item/clothing/accessory/storage/brown_vest = 1,
							/obj/item/clothing/accessory/storage/black_vest = 1,
							/obj/item/clothing/accessory/storage/white_vest = 1,
							/obj/item/clothing/accessory/holster/armpit = 1,
							/obj/item/clothing/accessory/holster/waist = 1,
							/obj/item/clothing/accessory/holster/hip = 1,
							/obj/item/clothing/accessory/holster/leg = 1)


/obj/machinery/vending/explorer_equipment/proc/pay_with_voucher(var/obj/item/weapon/spacecash/expedition_voucher)
	visible_message("<span class='info'>\The [usr] swipes \the [expedition_voucher] through \the [src].</span>")
	if(currently_vending.price > expedition_voucher.worth)
		status_message = "Insufficient points on voucher."
		status_error = 1
		return 0
	else
		expedition_voucher.worth -= currently_vending.price
	return 1


// This section handles what currency is accepted.
/obj/machinery/vending/explorer_equipment/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/obj/item/weapon/card/id/I = W.GetID()

	if(currently_vending && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/handled = 0

		if(istype(W, /obj/item/weapon/spacecash/expedition_voucher))
			var/obj/item/weapon/spacecash/expedition_voucher/C = W
			paid = pay_with_voucher(C)
			handled = 1

		else if(I) //for IDs and PDAs and wallets with IDs
			to_chat(user, "<font color='#ff0000'>This isn't the right type of currency!</font>")
			paid = 0
			handled = 0
		else if(istype(W, /obj/item/weapon/spacecash/ewallet))
			to_chat(user, "<font color='#ff0000'>This isn't the right type of currency!</font>")
			paid = 0
			handled = 0
		else if(istype(W, /obj/item/weapon/spacecash))
			to_chat(user, "<font color='#ff0000'>This isn't the right type of currency!</font>")
			paid = 0
			handled = 0


		if(paid)
			vend(currently_vending, usr)
			return
		else if(handled)
			GLOB.nanomanager.update_uis(src)
			return // don't smack that machine with your 2 thalers

		return
	else if(W.is_screwdriver())
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		playsound(src, W.usesound, 50, 1)
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, "[initial(icon_state)]-panel")

		GLOB.nanomanager.update_uis(src)  // Speaker switch is on the main UI, not wires UI
		return
	else if(istype(W, /obj/item/device/multitool) || W.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return
	else if(W.is_wrench())
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return
	else

		for(var/datum/stored_item/vending_product/R in product_records)
			if(istype(W, R.item_path) && (W.name == R.item_name))
				stock(W, R, user)
				return
	..()




/obj/machinery/vending/explorer_equipment/process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((last_slogan + slogan_delay) <= world.time) && (slogan_list.len > 0) && (!shut_up) && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(0))
		throw_item()

	return





/obj/machinery/vending/explorer_equipment/ballistic
	name = "Explorer Ballistic Outfitter"
	desc = "The ballistic weapons vendor for explorers, locked in a seperate machine in the pathfinder's office due to the \
	higher risk with teams using ballistic weaponry. A plate on the side says property of the Void Runners, LLC and a \
	long list of warnings, waivers, and legal speak for using this machine."
	products = list(/obj/item/ammo_magazine/s38 = 27, 											// Ammo
							/obj/item/ammo_magazine/m9mm = 27,
							/obj/item/ammo_magazine/m45 = 27,
							/obj/item/weapon/storage/box/shotgunammo = 27,
							/obj/item/ammo_magazine/m545 = 27,
							/obj/item/ammo_magazine/m762 = 27,
							/obj/item/weapon/gun/projectile/explorer/exrevolver/locked = 9, 	// Pistols
							/obj/item/weapon/gun/projectile/explorer/exmini_uzi/locked = 9,
							/obj/item/weapon/gun/projectile/explorer/expistol/locked = 9,
							/obj/item/weapon/gun/projectile/explorer/expump/locked = 9,			// Rifles
							/obj/item/weapon/gun/projectile/explorer/excarbine/locked = 9,
							/obj/item/weapon/gun/projectile/explorer/exsniper/locked = 9)


	contraband = list(/obj/item/weapon/beartrap = 5,
							/obj/item/weapon/gun/projectile/explorer/exholdout/locked = 1,
							/obj/item/weapon/gun/projectile/explorer/excontender/locked = 1)

	prices = list(/obj/item/ammo_magazine/s38 = 1, 												// Ammo
							/obj/item/ammo_magazine/m9mm = 1,
							/obj/item/ammo_magazine/m45 = 1,
							/obj/item/weapon/storage/box/shotgunammo = 1,
							/obj/item/ammo_magazine/m545 = 1,
							/obj/item/ammo_magazine/m762 = 1,
							/obj/item/weapon/gun/projectile/explorer/exrevolver/locked = 1, 	// Pistols
							/obj/item/weapon/gun/projectile/explorer/exmini_uzi/locked = 2,
							/obj/item/weapon/gun/projectile/explorer/expistol/locked = 2,
							/obj/item/weapon/gun/projectile/explorer/expump/locked = 6,			// Rifles
							/obj/item/weapon/gun/projectile/explorer/excarbine/locked = 5,
							/obj/item/weapon/gun/projectile/explorer/exsniper/locked = 8,
							/obj/item/weapon/gun/projectile/explorer/exholdout/locked = 1,		// Hacked prices, bear traps are free.
							/obj/item/weapon/gun/projectile/explorer/excontender/locked = 2)
