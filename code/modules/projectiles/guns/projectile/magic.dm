// todo: thsi stupid shit needs a refactor and i'm intentionally ignoring it because FUCK MAGIC

/obj/item/gun/projectile/magic
	name = "magic staff"
	desc = "This staff is boring to watch because even though it came first you've seen everything it can do in other staves for years."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/gun/magic.dmi'
	icon_state = "staffofnothing"
	item_state = "staff"
	fire_sound = 'sound/weapons/emitter.ogg'
	var/checks_antimagic = TRUE
	var/max_charges = 6
	var/charges = 0
	var/recharge_rate = 4
	var/charge_tick = 0
	var/can_charge = 1
	var/projectile_type = /obj/projectile/magic/spellblade
	var/no_den_usage
	pin = /obj/item/firing_pin/magic

/obj/item/gun/projectile/magic/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(no_den_usage)
		var/area/A = get_area(user)
		if(istype(A, /area/wizard_station))
			to_chat(user, "<span class='warning'>You know better than to violate the security of The Den, best wait until you leave to use [src].</span>")
			return
		else
			no_den_usage = 0
	if(checks_antimagic && user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE))
		to_chat(user, "<span class='warning'>Something is interfering with [src].</span>")
		return
	. = ..()

/obj/item/gun/projectile/magic/Initialize(mapload)
	. = ..()
	charges = max_charges
	if(can_charge)
		START_PROCESSING(SSobj, src)

/obj/item/gun/projectile/magic/Destroy()
	if(can_charge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/projectile/magic/process(delta_time)
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges)
		return 0
	charge_tick = 0
	charges++
	if(charges == 1)
		recharge_newshot()
	return 1

/obj/item/gun/projectile/magic/consume_next_projectile()
	if(!charges)
		return
	charges--
	return new projectile_type

/obj/item/gun/projectile/magic/handle_fire_empty(atom/target, atom/movable/user, turf/where, angle, reflex, iteration)
	user.action_feedback(SPAN_WARNING("[src] whizzles quietly."))
