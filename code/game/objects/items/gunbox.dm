/obj/item/gunbox
	name = "detective's gun box"
	desc = "A secure box containing a Detective's sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
	w_class = ITEMSIZE_HUGE

/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
	options[".45 Pistol"] = list(/obj/item/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options[".45 Revolver"] = list(/obj/item/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

/obj/item/gunbox/marksman
	name = "marksman gun box"
	desc = "A secure box containing a marksman rifle."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
	w_class = ITEMSIZE_HUGE

/obj/item/gunbox/marksman/attack_self(mob/living/user)
	var/list/options = list()
	options["Marksman Energy Rifle"] = list(/obj/item/gun/energy/sniperrifle/locked)
	options["Scoped Bolt Action"] = list(/obj/item/gun/projectile/shotgun/pump/scopedrifle, /obj/item/storage/belt/security/tactical/bandolier, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter, /obj/item/ammo_magazine/clip/c762/sniperhunter)
	var/choice = input(user,"Would you prefer a ballistic rifle or a laser?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)