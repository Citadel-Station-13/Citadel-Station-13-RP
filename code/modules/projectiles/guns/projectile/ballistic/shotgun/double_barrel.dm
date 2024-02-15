/obj/item/gun/projectile/ballistic/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A truely classic weapon. No need to change what works. Uses 12g rounds."
	icon_state = "shotgun_d"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	damage_force = 10
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/a12g/beanbag


	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", one_handed_penalty = 15, burst=1),
		list(mode_name="fire both barrels at once", one_handed_penalty = 35, burst=2),
		)

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/holy
	ammo_type = /obj/item/ammo_casing/a12g/silver
	desc = "Alright you primitive screw heads, listen up. See this? This... is my BOOMSTICK."

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flare shells. Uses 12g rounds."
	ammo_type = /obj/item/ammo_casing/a12g/flare

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			var/burstsetting = burst
			burst = 2
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			Fire_userless(user)
			burst = burstsetting
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = ITEMSIZE_NORMAL
			damage_force = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!" // I'm not gonna add "Uses 12g rounds." to this one. I'll just let this reference go undisturbed.
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3
	accuracy = 40
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	w_class = ITEMSIZE_NORMAL
	damage_force = 5
	one_handed_penalty = 5

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn/alt
	icon_state = "shotpistol"
	accuracy = 40

/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/sawn/alt/holy // A Special Skin for the sawn off,makes it look like the sawn off from Blood.
	ammo_type = /obj/item/ammo_casing/a12g/silver
