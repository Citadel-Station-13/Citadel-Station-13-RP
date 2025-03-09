/obj/item/gun/projectile/ballistic/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	caliber = /datum/ammo_caliber/rocket
	internal_magazine = TRUE
	internal_magazine_size = 1
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	throw_speed = 2
	throw_range = 10
	damage_force = 5.0
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/weapons/rpg.ogg'
	one_handed_penalty = 30

/*
/obj/item/gun/projectile/ballistic/rocket/proc/load(obj/item/ammo_casing/rocket/R, mob/user)
	if(R.loadable)
		if(rockets.len >= max_rockets)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		user.remove_from_mob(R)
		R.loc = src
		rockets.Insert(1, R) //add to the head of the list, so that it is loaded on the next pump
		user.visible_message("[user] inserts \a [R] into [src].", "<span class='notice'>You insert \a [R] into [src].</span>")
		return
	to_chat(user, "<span class='warning'>[R] doesn't seem to fit in the [src]!</span>")

/obj/item/gun/projectile/ballistic/rocket/proc/unload(mob/user)
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/R = rockets[rockets.len]
		rockets.len--
		user.put_in_hands(R)
		user.visible_message("[user] removes \a [R] from [src].", "<span class='notice'>You remove \a [R] from [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")

/obj/item/gun/projectile/ballistic/rocket/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/rocket)))
		load(I, user)
	else
		..()

/obj/item/gun/projectile/ballistic/rocket/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/rocket/consume_next_projectile(datum/gun_firing_cycle/cycle)
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		rockets -= I
		return
	return null
*/

// /obj/item/gun/projectile/ballistic/rocket/handle_post_fire(mob/user, atom/target)
// 	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]) at [target].")
// 	log_game("[key_name_admin(user)] used a rocket launcher ([src.name]) at [target].")
// 	..()

/obj/item/gun/projectile/ballistic/rocket/collapsible
	name = "disposable rocket launcher"
	desc = "A single use rocket launcher designed with portability in mind. This disposable launcher must be extended before it can fire."
	icon_state = "missile"
	item_state = "missile"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT
	chamber_cycle_after_fire = FALSE
	internal_magazine_preload_ammo = /obj/item/ammo_casing/rocket
	var/collapsed = 1
	var/empty = 0

/obj/item/gun/projectile/ballistic/rocket/collapsible/special_check(mob/user)
	if(collapsed)
		to_chat(user, "<span class='warning'>[src] is collapsed! You must extend it before firing!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/ballistic/rocket/collapsible/attackby(var/obj/item/A as obj, mob/user as mob)
	to_chat(user, "<span class='danger'>You cannot reload the [src]!</span>")
	return

/obj/item/gun/projectile/ballistic/rocket/collapsible/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		to_chat(user, "<span class='danger'>You cannot unload the [src]'s munition!</span>")
		return
	else
		return ..()

/obj/item/gun/projectile/ballistic/rocket/collapsible/attack_self(mob/user, datum/event_args/actor/actor)
	if(collapsed)
		to_chat(user, "<span class='notice'>You pull out the tube on the [src], readying the weapon to be fired.</span>")
		icon_state = "[initial(icon_state)]-extended"
		item_state = "[initial(item_state)]-extended"
		collapsed = 0
	else if(!collapsed && empty)
		to_chat(user, "<span class='danger'>You cannot collapse the [src] after it has been fired!</span>")
		return
	else
		to_chat(user, "<span class='notice'>You push the tube back into the [src], collapsing the weapon.</span>")
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		collapsed = 1

/obj/item/gun/projectile/ballistic/rocket/collapsible/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()
	if(empty)
		return
	else
		name = "spent collapsible missile launcher"
		desc = "This missile launcher has been used. It is no longer able to fire."
		icon_state = "[initial(icon_state)]-empty"
		empty = 1

/obj/item/gun/projectile/ballistic/rocket/tyrmalin
	name = "rokkit launcher"
	desc = "A sloppily machined tube designed to function as a recoilless rifle. Sometimes used by Tyrmalin defense teams. It draws skeptical looks even amongst their ranks."
	icon_state = "rokkitlauncher"
	item_state = "rocket"
	unstable = 1

// todo: dumb
/obj/item/gun/projectile/ballistic/rocket/tyrmalin/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()
	if(.)
		if(unstable)
			switch(rand(1,100))
				if(1 to 5)
					visible_message("<span class='danger'>The rocket primer on [src] activates early!</span>")
					icon_state = "rokkitlauncher-malfunction"
					spawn(rand(2 SECONDS, 5 SECONDS))
						if(src && !destroyed)
							visible_message("<span class='critical'>\The [src] detonates!</span>")
							destroyed = 1
							explosion(get_turf(src), -1, 0, 2, 3)
							qdel(src)
					return ..()
				if(6 to 20)
					visible_message("<span class='notice'>The rocket in [src] flares out in the tube!</span>")
					playsound(src, 'sound/machines/button.ogg', 25)
					icon_state = "rokkitlauncher-broken"
					destroyed = 1
					name = "broken rokkit launcher"
					desc = "The tube has burst outwards like a sausage."
					return null
				if(21 to 100)
					return ..()

/obj/item/gun/projectile/ballistic/rocket/tyrmalin/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src && destroyed)
		to_chat(user, "<span class='danger'>\The [src]'s chamber is too warped to extract the casing!</span>")
		return
	else
		return ..()

/obj/item/gun/projectile/ballistic/rocket/tyrmalin/attackby(var/obj/item/A as obj, mob/user as mob)
	. = ..()
	if(A.is_material_stack_of(/datum/prototype/material/plasteel))
		var/obj/item/stack/material/M = A
		if(M.use(1))
			var/obj/item/tyrmalin_rocket_assembly/R = new /obj/item/tyrmalin_rocket_assembly(get_turf(src))
			to_chat(user, "<span class='notice'>You reinforce the weapon's barrel and open the maintenance hatch. The electronics are...missing?</span>")
			user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
			user.put_in_active_hand(R)
			qdel(src)

/obj/item/tyrmalin_rocket_assembly
	name = "advanced rokkit launcher assembly"
	desc = "A Tyrmalin rokkit launcher that has been partially disassembled and reinforced with more reliable materials. It's missing some wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "rokkitassembly1"
	var/build_step = 0

/obj/item/tyrmalin_rocket_assembly/attackby(var/obj/item/W as obj, mob/user as mob)

	switch(build_step)
		if(0)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					to_chat(user, "<span class='warning'>You need one coil of wire to wire \the [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire \the [src].</span>")
				if(do_after(user, 40))
					if(C.use(1))
						build_step++
						to_chat(user, "<span class='notice'>You add wires to the internal assembly.</span>")
						name = "wired advanced rokkit launcher assembly"
						desc = "This aseembly looks like it needs a power control module."
						icon_state = "rokkitassembly2"

		if(1)
			if(istype(W, /obj/item/module/power_control))
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				build_step++
				to_chat(user, "<span class='notice'>You add \the [W] to \the [src].</span>")
				name = "programmed advanced rokkit launcher assembly"
				desc = "It seems ready for assembly."
				icon_state = "rokkitassembly3"

		if(2)
			if(W.is_screwdriver())
				playsound(src, W.tool_sound, 100, 1)
				to_chat(user, "<span class='notice'>You begin installing the board...</span>")
				if(do_after(user, 40))
					build_step++
					to_chat(user, "<span class='notice'>You close the hatch and complete the advanced rokkit launcher.</span>")
					var/turf/T = get_turf(src)
					new /obj/item/gun/projectile/ballistic/rocket/tyrmalin_advanced(T)
					qdel(src)

/obj/item/tyrmalin_rocket_assembly/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	.=..()
	update_icon()

/obj/item/gun/projectile/ballistic/rocket/tyrmalin_advanced
	name = "advanced rokkit launcher"
	desc = "A compact missile launcher fielded by Tyrmalin mech hunters. It looks more sturdy and refined than the prior iteration."
	icon_state = "rokkitlauncher_adv"

/obj/item/gun/projectile/ballistic/rocket/tyrmalin_advanced/update_icon_state()
	. = ..()
	if(get_ammo_remaining())
		icon_state = "[initial(icon_state)]-loaded"
	else
		icon_state = "[initial(icon_state)]"
