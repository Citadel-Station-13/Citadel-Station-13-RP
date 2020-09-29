/obj/item/gunbox
	name = "security sidearm box"
	desc = "A secure box containing a security sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
	w_class = ITEMSIZE_HUGE

/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
	options["M1911 Dynamic (.45)"] = list(/obj/item/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	//options["NT Mk58 (.45)"] = list(/obj/item/gun/projectile/sec, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options["SW 625 Revolver (.45)"] = list(/obj/item/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	options["P92X (9mm)"] = list(/obj/item/gun/projectile/p92x/sec, /obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/rubber)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)
