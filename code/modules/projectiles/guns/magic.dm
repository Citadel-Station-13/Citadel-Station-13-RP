/obj/item/gun/magic
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
	var/no_den_usage
	pin = /obj/item/firing_pin/magic

	/// the projectile type we generate
	//  todo: this should be on /obj/item/gun/magic/basic
	projectile_type = /obj/projectile/magic

/obj/item/gun/magic/afterattack(atom/target, mob/user, clickchain_flags, list/params)
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

/obj/item/gun/magic/Initialize(mapload)
	. = ..()
	charges = max_charges
	if(can_charge)
		START_PROCESSING(SSobj, src)

/obj/item/gun/magic/Destroy()
	if(can_charge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/magic/process(delta_time)
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges)
		return
	charge_tick = 0
	charges++

/obj/item/gun/magic/consume_next_projectile()
	if(charges <= 0)
		return null
	return chambered?.get_projectile()

/obj/item/gun/magic/handle_click_empty(mob/user)
	to_chat(user, "<span class='warning'>The [name] whizzles quietly.</span>")
