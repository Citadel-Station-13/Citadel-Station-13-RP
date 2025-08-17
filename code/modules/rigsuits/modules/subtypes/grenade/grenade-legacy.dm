
/obj/item/rig_module/basic/grenade_launcher

	name = "mounted grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser."
	selectable = 1
	icon_state = "grenadelauncher"

	interface_name = "integrated grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/grenade/simple/flashbang,  3),
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/simple/smoke,  3),
		list("EMP grenade", "EMP grenade", /obj/item/grenade/simple/emp, 3),
		)

/obj/item/rig_module/basic/grenade_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(!istype(input_device) || !istype(user))
		return 0

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return 0

	if(accepted_item.charges >= 5)
		to_chat(user, "<span class='danger'>Another grenade of that type will not fit into the module.</span>")
		return 0

	if(!user.attempt_consume_item_for_construction(input_device))
		return

	to_chat(user, "<font color=#4F49AF><b>You slot \the [input_device] into the suit module.</b></font>")
	accepted_item.charges++
	return 1

/obj/item/rig_module/basic/grenade_launcher/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a grenade type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient grenades!</span>")
		return 0

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message("<span class='danger'>[H] launches \a [new_grenade]!</span>")
	new_grenade.activate(new /datum/event_args/actor(H))
	new_grenade.throw_at_old(target,fire_force,fire_distance)

/obj/item/rig_module/basic/grenade_launcher/smoke
	name = "mounted smoke-bomb launcher"
	desc = "A shoulder-mounted smoke-bomb dispenser."

	interface_name = "integrated smoke-bomb launcher"
	interface_desc = "Discharges loaded smoke-bombs against the wearer's location."

	fire_force = 15

	charges = list(
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/simple/smoke,  6)
		)

/obj/item/rig_module/basic/grenade_launcher/holy
	name = "mounted PARA disruptor launcher"
	desc = "A shoulder-mounted holy water dispenser."

	interface_name = "PARA disruptor grenade launcher"
	interface_desc = "Launches armed PARA disruptor grenades at the wearer's target."

	fire_force = 15

	charges = list(
		list("PARA disruptor grenade",  "PARA disruptor grenade",  /obj/item/grenade/simple/chemical/premade/holy,  6)
		)

/obj/item/rig_module/basic/grenade_launcher/cleaner
	name = "mounted cleaner-grenade launcher"
	desc = "A shoulder-mounted cleaner-grenade dispenser."

	interface_name = "integrated cleaner-grenade launcher"
	interface_desc = "Discharges loaded cleaner-grenades against the wearer's location."

	fire_force = 15

	charges = list(
		list("cleaner grenade",  "cleaner grenade",  /obj/item/grenade/simple/chemical/premade/cleaner,  6)
		)

/obj/item/rig_module/basic/cleaner_launcher

	name = "mounted space cleaner launcher"
	desc = "A shoulder-mounted micro-cleaner dispenser."
	selectable = 1
	icon_state = "grenadelauncher"
	interface_name = "integrated cleaner launcher"
	interface_desc = "Discharges loaded cleaner grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("cleaner grenade",   "cleaner grenade",   /obj/item/grenade/simple/chemical/premade/cleaner,  9),
		)

/obj/item/rig_module/basic/cleaner_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(!istype(input_device) || !istype(user))
		return 0

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return 0

	if(accepted_item.charges >= 5)
		to_chat(user, "<span class='danger'>Another grenade of that type will not fit into the module.</span>")
		return 0
	if(!user.attempt_consume_item_for_construction(input_device))
		return

	to_chat(user, "<font color=#4F49AF><b>You slot \the [input_device] into the suit module.</b></font>")
	accepted_item.charges++
	return 1

/obj/item/rig_module/basic/cleaner_launcher/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a grenade type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient grenades!</span>")
		return 0

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message("<span class='danger'>[H] launches \a [new_grenade]!</span>")
	new_grenade.activate(new /datum/event_args/actor(H))
	new_grenade.throw_at_old(target,fire_force,fire_distance)
