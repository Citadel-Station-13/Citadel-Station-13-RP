// For all intents and purposes, these work exactly the same as pump shotguns. It's unnecessary to make their own procs for them.

/obj/item/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A reproduction of an almost ancient weapon design from the early 20th century. It's still popular among hunters and collectors due to its reliability. Uses 7.62mm rounds."
	item_state = "boltaction"
	icon_state = "boltaction"
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1)// Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/gun/projectile/shotgun/pump/rifle/practice // For target practice
	desc = "A bolt-action rifle with a lightweight synthetic wood stock, designed for competitive shooting. Comes shipped with practice rounds pre-loaded into the gun. Popular among professional marksmen. Uses 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762/practice

/obj/item/gun/projectile/shotgun/pump/rifle/ceremonial
	name = "ceremonial bolt-action rifle"
	desc = "A bolt-action rifle with a heavy, high-quality wood stock that has a beautiful finish. Clearly not intended to be used in combat. Uses 7.62mm rounds."
	icon_state = "boltaction_c"
	item_state = "boltaction_c"
	ammo_type = /obj/item/ammo_casing/a762/blank

/obj/item/gun/projectile/shotgun/pump/rifle/ceremonial/holy
	name = "blessed bolt-action rifle"
	desc = "A bolt-action rifle with a heavy, high-quality wood stock that has a beautiful finish. Clearly not intended to be used in combat. Uses 7.62mm rounds."
	ammo_type = /obj/item/ammo_casing/a762/silver
	holy = TRUE

/obj/item/gun/projectile/shotgun/pump/rifle/vox_hunting
	name = "vox hunting rifle"
	desc = "This ancient rifle bears traces of an assembly meant to house power cells, implying it used to fire energy beams. It has since been crudely modified to fire standard 7.62mm rounds."
	icon_state = "vox_hunting"
	item_state = "vox_hunting"
	ammo_type = /obj/item/ammo_casing/a762
	throwforce = 10
	force = 20

// Stole hacky terrible code from doublebarrel shotgun. -Spades
/obj/item/gun/projectile/shotgun/pump/rifle/ceremonial/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
		to_chat(user, "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>")
		if(loaded.len)
			afterattack(user, user)
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			icon_state = "sawnrifle"
			w_class = ITEMSIZE_NORMAL
			recoil = 2 // Owch
			accuracy = -15 // You know damn well why.
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "sawn-off rifle"
			desc = "The firepower of a rifle, now the size of a pistol, with an effective combat range of about three feet. Uses 7.62mm rounds."
			to_chat(user, "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>")
	else
		..()

//Lever actions are the same thing, but bigger.
/obj/item/gun/projectile/shotgun/pump/rifle/lever
	name = "lever-action rifle"
	desc = "A reproduction of an almost ancient weapon design from the 19th century. This one uses a lever-action to move new rounds into the chamber. Uses .357 rounds."
	item_state = "leveraction"
	icon_state = "leveraction"
	max_shells = 10
	caliber = "357"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/a357
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/gun/projectile/shotgun/pump/rifle/lever/holy
	name = "blessed lever-action"
	ammo_type = /obj/item/ammo_casing/a357/silver
	holy = TRUE

/obj/item/gun/projectile/shotgun/pump/rifle/lever/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
		to_chat(user, "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>")
		if(loaded.len)
			afterattack(user, user)
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			item_state = "mareleg"
			icon_state = "mareleg"
			w_class = ITEMSIZE_NORMAL
			caliber = "357"
			load_method = SINGLE_CASING
			ammo_type = /obj/item/ammo_casing/a357
			recoil = 1 // Less Ouch
			accuracy = -5 // You know damn well why.
			item_state = "gun"
			max_shells = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your hip (how's that for a big iron) - or in a holster, why not.
			name = "Mare's Leg"
			desc = "A traditional shortened lever action whose weight distribution makes it far better suited for its size than similar sawn off rifles but has less ammo capacity. Uses .44 rounds."
			to_chat(user, "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/shotgun/pump/rifle/lever/vintage
	name = "vintage repeater"
	desc = "An iconic manually operated lever action rifle, offering adequate stopping power due to it's still powerful cartridge while at the same time having a rather respectable firing rate due to it's mechanism. It is very probable this is a replica instead of a museum piece, but rifles of this pattern still see usage as colonist guns in some far off regions. Uses .44 rounds."
	item_state = "levercarabine" // That isn't how carbine is spelled ya knob! :U
	icon_state = "levercarabine"
	max_shells = 10
	caliber = "44"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/a44
	animated_pump = 1
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/gun/projectile/shotgun/pump/rifle/lever/vintage/holy
	name = "blessed lever-action"
	ammo_type = /obj/item/ammo_casing/a44/silver
	holy = TRUE

/obj/item/gun/projectile/shotgun/pump/rifle/lever/vintage/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/surgical/circular_saw) || istype(A, /obj/item/melee/energy) || istype(A, /obj/item/pickaxe/plasmacutter) && w_class != ITEMSIZE_NORMAL)
		to_chat(user, "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>")
		if(loaded.len)
			afterattack(user, user)
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>[src] goes off!</span>", "<span class='danger'>The rifle goes off in your face!</span>")
			return
		if(do_after(user, 30))
			item_state = "mareleg"
			icon_state = "mareleg"
			w_class = ITEMSIZE_NORMAL
			caliber = "44"
			load_method = SINGLE_CASING
			ammo_type = /obj/item/ammo_casing/a44
			recoil = 1 // Less Ouch
			accuracy = -5 // You know damn well why.
			item_state = "gun"
			max_shells = 5
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your hip (how's that for a big iron) - or in a holster, why not.
			name = "Mare's Leg"
			desc = "A traditional shortened lever action whose weight distribution makes it far better suited for its size than similar sawn off rifles but has less ammo capacity. Uses .44 rounds."
			to_chat(user, "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>")
	else
		..()

/obj/item/gun/projectile/shotgun/pump/rifle/lever/arnold
	name = "lever-action shotgun"
	desc = "The legendary Model 1887 Lever Action Shotgun, Hasta La Vista Bay-bee!"
	item_state = "arnold"
	icon_state = "arnold"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	max_shells = 5
	caliber = "12g"
	load_method = SINGLE_CASING
	action_sound = 'sound/weapons/riflebolt.ogg'

/obj/item/gun/projectile/shotgun/pump/rifle/lever/arnold/holy
	name = "blessed lever-action shotgun"
	ammo_type = /obj/item/ammo_casing/a12g/silver
	holy = TRUE

/obj/item/gun/projectile/shotgun/pump/rifle/lever/win1895
	name = "Winchester 1895"
	desc = "The Winchester Model 1895 rifle, unqiue for its ability to load using rifle stripper clips. Uses 7.62mm rounds."
	item_state = "win1895"
	icon_state = "win1895"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 5
	caliber = "7.62mm"
	action_sound = 'sound/weapons/riflebolt.ogg'
	animated_pump = 1

/obj/item/gun/projectile/shotgun/pump/rifle/lever/win1895/holy
	name = "blessed lever-action"
	ammo_type = /obj/item/ammo_casing/a762/silver
	holy = TRUE

/obj/item/gun/projectile/shotgun/pump/scopedrifle
	name = "scoped bolt action"
	desc = "A bolt-action rifle with a scope afixed to it by a gun smith. Uses 7.62 rounds."
	item_state = "boltaction"
	icon_state = "boltaction-scoped"
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	max_shells = 5
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1)
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'
	pin = /obj/item/firing_pin/explorer
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	ammo_type = /obj/item/ammo_casing/a762/sniperhunter
	accuracy = 50 //Forced missing fucking sucks ass
	scoped_accuracy = 100

/obj/item/gun/projectile/shotgun/pump/scopedrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)