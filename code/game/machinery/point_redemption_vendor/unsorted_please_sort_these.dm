// stuff i kicked over from old files that i don't want to deal with. someone deal with them.

/obj/item/tank/vimur
	name = "Vimur tank"
	desc = "Contains Vimur. A gas with very high thermal capacity. Probably not so smart to breath."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "coolant"
	gauge_icon = null
	slot_flags = null	//they have no straps!
	volume = 500//Standard tanks have 70, we up that alot, a cannister has 1000, but we want this to be worth our points.

/obj/item/tank/vimur/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(GAS_ID_VIMUR, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return .

/obj/item/engineering_mystical_tech
	name = "XYE"
	desc = "???"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "circuit"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_PRECURSOR = 1)

// todo: generic supply vouchers
/obj/item/engineering_voucher
	name = "equipment voucher"
	desc = "An used voucher that could be used to be redeemed for something at the cargo console"
	icon = 'icons/obj/vouchers.dmi'
	icon_state = "engineering_voucher_used"
	w_class = WEIGHT_CLASS_SMALL
	var/datum/supply_pack/redeemable_for = null

/obj/item/engineering_voucher/proc/redeem(var/mob/user)
	if(!redeemable_for)
		to_chat(user, SPAN_WARNING("[src] has already been used"))
		return
	var/datum/supply_order/order = new /datum/supply_order

	var/idname = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	order.ordernum = ++SSsupply.ordernum		// Ordernum is used to track the order between the playerside list of orders and the adminside list
	order.index = order.ordernum	// Index can be fabricated, or falsified. Ordernum is a permanent marker used to track the order
	order.object = redeemable_for
	order.name = redeemable_for.name
	order.cost = 0
	order.ordered_by = idname
	order.comment = "Voucher redemption"
	order.ordered_at = stationdate2text() + " - " + stationtime2text()
	order.status = SUP_ORDER_APPROVED		//auto approved
	order.approved_by = "[user]"
	order.approved_at = stationdate2text() + " - " + stationtime2text()

	SSsupply.order_history += order//tell supply the order exists.
	SSsupply.adm_order_history += order

	name = "used " + name
	redeemable_for = null
	icon_state = "engineering_voucher_used"
	desc = "An used voucher that was used to redeem for something at the cargo console"

/obj/item/engineering_voucher/teg
	name = "Thermo-Electric Generator voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a Thermo-Electric Generator"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/teg

/obj/item/engineering_voucher/collectors
	name = "Radiation Collector voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of crate of radiation collectors"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/engine/radiation_collector

/obj/item/engineering_voucher/smcore
	name = "Supermatter Core voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a Supermatter core"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/engine/supermatter_core

/obj/item/engineering_voucher/fusion_core
	name = "Fusion Core voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a fusion core"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/engine/fusion_core

/obj/item/engineering_voucher/fusion_fuel_injector
	name = "Fuel Injector voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a fusion fuel injector"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/engine/fusion_fuel_injector

/obj/item/engineering_voucher/gyrotrons
	name = "Gyrotron voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of Gyrotrons"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/engine/gyrotron

/obj/item/engineering_voucher/fuel_compressor
	name = "Fuel compressor voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a Fuel rod compressor"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/engine/fusion_fuel_compressor

/obj/item/engineering_voucher/reflector
	name = "Laser reflector voucher"
	desc = "A voucher redeemable, at any NT cargo department, for a single laser reflector."
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/nanotrasen/engineering/reflector
