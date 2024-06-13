/obj/item/gun/projectile/magic/staff
	slot_flags = SLOT_BACK
	accuracy = 95

/obj/item/gun/projectile/magic/staff/healing
	name = "staff of healing"
	desc = "An artefact that spits bolts of restoring magic which can remove ailments of all kinds and even raise the dead."
	fire_sound = 'sound/magic/staff_healing.ogg'
	projectile_type = /obj/projectile/magic/resurrection
	icon_state = "staffofhealing"
	item_state = "staffofhealing"

/obj/item/gun/projectile/magic/staff/door
	name = "staff of door creation"
	desc = "An artefact that spits bolts of transformative magic that can create doors in walls."
	fire_sound = 'sound/magic/staff_door.ogg'
	projectile_type = /obj/projectile/magic/door
	icon_state = "staffofdoor"
	item_state = "staffofdoor"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1

/obj/item/gun/projectile/magic/staff/honk
	name = "staff of the honkmother"
	desc = "Honk."
	fire_sound = 'sound/items/airhorn.ogg'
	projectile_type = /obj/projectile/bullet/honker
	icon_state = "honker"
	item_state = "honker"
	max_charges = 4
	recharge_rate = 8

/obj/item/gun/projectile/magic/staff/locker
	name = "staff of the locker"
	desc = "An artefact that expells encapsulating bolts, for incapacitating thy enemy."
	fire_sound = 'sound/magic/staff_change.ogg'
	projectile_type = /obj/projectile/magic/locker
	icon_state = "locker"
	item_state = "locker"
	max_charges = 6
	recharge_rate = 4
