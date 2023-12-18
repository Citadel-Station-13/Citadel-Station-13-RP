/obj/item/gun/projectile/ballistic/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	caliber = "rocket"
	max_shells = 1
	load_method = SINGLE_CASING
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	throw_speed = 2
	throw_range = 10
	damage_force = 5.0
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/weapons/rpg.ogg'
	one_handed_penalty = 30

/obj/item/gun/projectile/ballistic/rocket/collapsible
	name = "disposable rocket launcher"
	desc = "A single use rocket launcher designed with portability in mind. This disposable launcher must be extended before it can fire."
	icon_state = "missile"
	item_state = "missile"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	handle_casings = HOLD_CASINGS
	ammo_type = /obj/item/ammo_casing/rocket
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

/obj/item/gun/projectile/ballistic/rocket/collapsible/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src)
		to_chat(user, "<span class='danger'>You cannot unload the [src]'s munition!</span>")
		return
	else
		return ..()

/obj/item/gun/projectile/ballistic/rocket/collapsible/attack_self(mob/user, obj/item/gun/G)
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

/obj/item/gun/projectile/ballistic/rocket/collapsible/examine(mob/user, dist)
	. = ..()
	return

/obj/item/gun/projectile/ballistic/rocket/collapsible/consume_next_projectile(mob/user as mob)
	. = ..()
	if(empty)
		return
	else
		name = "spent collapsible missile launcher"
		desc = "This missile launcher has been used. It is no longer able to fire."
		icon_state = "[initial(icon_state)]-empty"
		empty = 1
