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
	var/ammo_type = /obj/item/projectile/magic
	var/no_den_usage
	pin = /obj/item/firing_pin/magic

/obj/item/gun/magic/afterattack(atom/target, mob/living/user, flag)
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

/obj/item/gun/magic/proc/recharge_newshot()
	if(charges && chambered && !chambered.get_projectile())
		chambered.newshot()

/obj/item/gun/magic/proc/process_chamber()
	if(chambered && !chambered.get_projectile()) //if BB is null, i.e the shot has been fired...
		charges--//... drain a charge
		recharge_newshot()

/obj/item/gun/magic/Initialize(mapload)
	. = ..()
	charges = max_charges
	chambered = new ammo_type(src)
	if(can_charge)
		START_PROCESSING(SSobj, src)


/obj/item/gun/magic/Destroy()
	if(can_charge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/magic/process(delta_time)
	charge_tick++
	if(charge_tick < recharge_rate || charges >= max_charges)
		return 0
	charge_tick = 0
	charges++
	if(charges == 1)
		recharge_newshot()
	return 1

/obj/item/gun/magic/consume_next_projectile()
	return chambered?.get_projectile()

/obj/item/gun/magic/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='warning'>The [name] whizzles quietly.</span>")

/obj/item/gun/magic/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is twisting [src] above their head, releasing a magical blast! It looks like they are trying to commit suicide!</span>")
	playsound(loc, fire_sound, 50, 1, -1)
	return (FIRELOSS)

/obj/item/gun/magic/vv_edit_var(var_name, var_value)
	. = ..()
	switch(var_name)
		if(NAMEOF(src, charges))
			recharge_newshot()
