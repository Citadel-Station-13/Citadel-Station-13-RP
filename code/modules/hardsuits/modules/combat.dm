/*
 * Contains
 * /obj/item/hardsuit_module/grenade_launcher
 * /obj/item/hardsuit_module/mounted
 * /obj/item/hardsuit_module/mounted/taser
 * /obj/item/hardsuit_module/shield
 * /obj/item/hardsuit_module/fabricator
 * /obj/item/hardsuit_module/mounted/energy_blade
 * /obj/item/hardsuit_module/armblade
 * /obj/item/hardsuit_module/device/flash */

/obj/item/hardsuit_module/device/flash
	name = "mounted flash"
	desc = "You are the law."
	icon_state = "flash"
	interface_name = "mounted flash"
	interface_desc = "Stuns your target by blinding them with a bright light."
	device_type = /obj/item/flash

/obj/item/hardsuit_module/grenade_launcher

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

/obj/item/hardsuit_module/grenade_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

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

/obj/item/hardsuit_module/grenade_launcher/engage(atom/target)

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

/obj/item/hardsuit_module/grenade_launcher/smoke
	name = "mounted smoke-bomb launcher"
	desc = "A shoulder-mounted smoke-bomb dispenser."

	interface_name = "integrated smoke-bomb launcher"
	interface_desc = "Discharges loaded smoke-bombs against the wearer's location."

	fire_force = 15

	charges = list(
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/simple/smoke,  6)
		)

/obj/item/hardsuit_module/grenade_launcher/holy
	name = "mounted PARA disruptor launcher"
	desc = "A shoulder-mounted holy water dispenser."

	interface_name = "PARA disruptor grenade launcher"
	interface_desc = "Launches armed PARA disruptor grenades at the wearer's target."

	fire_force = 15

	charges = list(
		list("PARA disruptor grenade",  "PARA disruptor grenade",  /obj/item/grenade/simple/chemical/premade/holy,  6)
		)

/obj/item/hardsuit_module/mounted

	name = "mounted laser cannon"
	desc = "A shoulder-mounted battery-powered laser cannon mount."
	selectable = 1
	usable = 1
	module_cooldown = 0
	icon_state = "lcannon"

	engage_string = "Configure"

	interface_name = "mounted laser cannon"
	interface_desc = "A shoulder-mounted cell-powered laser cannon."

	var/gun_type = /obj/item/gun/projectile/energy/lasercannon/mounted
	var/obj/item/gun/gun

/obj/item/hardsuit_module/mounted/Initialize(mapload)
	. = ..()
	gun = new gun_type(src)
	gun.safety_state = GUN_SAFETY_OFF
	gun.one_handed_penalty = 0

/obj/item/hardsuit_module/mounted/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		gun.user_switch_firemodes(new /datum/event_args/actor(holder.wearer))
		return 1

	gun.start_firing_cycle_async(holder.wearer, get_centered_entity_tile_angle(holder.wearer, target), NONE, null, target, new /datum/event_args/actor(holder.wearer))
	return 1

/obj/item/hardsuit_module/mounted/egun

	name = "mounted energy gun"
	desc = "A forearm-mounted energy projector."
	icon_state = "egun"

	interface_name = "mounted energy gun"
	interface_desc = "A forearm-mounted suit-powered energy gun."

	gun_type = /obj/item/gun/projectile/energy/gun/mounted

/obj/item/hardsuit_module/mounted/taser

	name = "mounted taser"
	desc = "A palm-mounted nonlethal energy projector."
	icon_state = "taser"

	usable = 0

	suit_overlay_active = "mounted-taser"
	suit_overlay_inactive = "mounted-taser"

	interface_name = "mounted taser"
	interface_desc = "A shoulder-mounted cell-powered taser."

	gun_type = /obj/item/gun/projectile/energy/taser/mounted

/obj/item/hardsuit_module/mounted/energy_blade

	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 50
	active_power_cost = 10
	passive_power_cost = 0

	gun_type = /obj/item/gun/projectile/energy/crossbow/ninja

/obj/item/hardsuit_module/mounted/energy_blade/process(delta_time)

	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/ninja_energy_blade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/hardsuit_module/mounted/energy_blade/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.are_usable_hands_full())
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return

	var/obj/item/melee/ninja_energy_blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/hardsuit_module/mounted/energy_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/ninja_energy_blade/blade in M.contents)
		qdel(blade)

/obj/item/hardsuit_module/fabricator

	name = "matter fabricator"
	desc = "A self-contained microfactory system for hardsuit integration."
	selectable = 1
	usable = 1
	use_power_cost = 15
	icon_state = "enet"

	engage_string = "Fabricate Star"

	interface_name = "death blossom launcher"
	interface_desc = "An integrated microfactory that produces poisoned throwing stars from thin air and electricity."

	var/fabrication_type = /obj/item/material/star/ninja
	var/fire_force = 30
	var/fire_distance = 10

/obj/item/hardsuit_module/fabricator/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/H = holder.wearer

	if(target)
		var/obj/item/firing = new fabrication_type()
		firing.forceMove(get_turf(src))
		H.visible_message("<span class='danger'>[H] launches \a [firing]!</span>")
		firing.throw_at_old(target,fire_force,fire_distance)
	else
		if(H.are_usable_hands_full())
			to_chat(H, "<span class='danger'>Your hands are full.</span>")
		else
			var/obj/item/new_weapon = new fabrication_type()
			new_weapon.forceMove(H)
			to_chat(H, "<font color=#4F49AF><b>You quickly fabricate \a [new_weapon].</b></font>")
			H.put_in_hands(new_weapon)

	return 1

/obj/item/hardsuit_module/armblade
	name = "retractable armblade"
	desc = "A retractable arm-mounted blade in an equally retractable scabbard that fits in standardized hardsuit mounts. Attaches to the user's forearm."
	icon_state = "armblade"
	toggleable = TRUE
	disruptive = FALSE

	interface_name = "retractable armblade"
	interface_desc = "An attached armblade fitted to the wearer's arm of choice."

	activate_string = "Extend Blade"
	deactivate_string = "Retract Blade"
	var/obj/item/material/knife/machete/armblade/hardsuit/held_blade

/obj/item/hardsuit_module/armblade/Initialize(mapload)
	. = ..()
	held_blade = new /obj/item/material/knife/machete/armblade/hardsuit
	held_blade.storing_module = src
	RegisterSignal(held_blade, COMSIG_ITEM_DROPPED, PROC_REF(magnetic_catch))

/obj/item/hardsuit_module/armblade/proc/magnetic_catch(datum/source)
	var/obj/item/I = source
	if(I != held_blade)
		return
	deactivate()

/obj/item/hardsuit_module/armblade/process(delta_time)

	if(holder && holder.wearer)
		if(!(locate(/obj/item/material/knife/machete/armblade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/hardsuit_module/armblade/activate()

	..()
	var/mob/living/M = holder.wearer
	var/datum/gender/TU = GLOB.gender_datums[M.get_visible_gender()]

	if(!M.put_in_hands(held_blade))
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return
	if(M.a_intent == INTENT_HARM)
		M.visible_message(
			"<span class='danger'>[M] throws [TU.his] arm out, extending \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='danger'>You throw your arm out, extending \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='notice'>You hear a threatening hiss and a click.</span>"
			)
	else
		M.visible_message(
			"<span class='notice'>[M] extends \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='notice'>You extend \the [held_blade] from \the [holder] with a click!</span>",
			"<span class='notice'>You hear a hiss and a click.</span>")

	playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)

/obj/item/hardsuit_module/armblade/deactivate()
	..()
	held_blade?.forceMove(src)
