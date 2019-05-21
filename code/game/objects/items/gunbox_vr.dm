/obj/item/gunbox
	name = "security sidearm box"
	desc = "A secure box containing a security sidearm."

/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
	options["M1911 Dynamic (.45)"] = list(/obj/item/weapon/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	//options["NT Mk58 (.45)"] = list(/obj/item/weapon/gun/projectile/sec, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options["SW 625 Revolver (.45)"] = list(/obj/item/weapon/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	options["P92X (9mm)"] = list(/obj/item/weapon/gun/projectile/p92x/sec, /obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/rubber)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

/obj/item/gunbox/hos
	name = "Head of Security sidearm box"
	desc = "A secure box containing a security sidearm."

/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
	options["M1911 Dynamic (.45)"] = list(/obj/item/weapon/gun/projectile/colt/detective, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/rubber)
	options["'Consul' Revolver (.44)"] = list(/obj/item/weapon/gun/projectile/revolver/consul, /obj/item/ammo_magazine/s44/rubber, /obj/item/ammo_magazine/s44/rubber)
	options["SW 625 Revolver (.45)"] = list(/obj/item/weapon/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	options["Webley Service Revolver (.44)"] = list(/obj/item/weapon/gun/projectile/revolver/webley, /obj/item/ammo_magazine/s44/rubber, /obj/item/ammo_magazine/s44/rubber)
	options["Lumoco Arms HE Colt (.357 LETHAL)"] = list(/obj/item/weapon/gun/projectile/revolver, /obj/item/ammo_magazine/s357, /obj/item/ammo_magazine/s357) // Yikes, lethals only for .357s. I'll have to fix that later.
	options["'Mateba' Revolver (.357 LETHAL)"] = list(/obj/item/weapon/gun/projectile/revolver/mateba, /obj/item/ammo_magazine/s357, /obj/item/ammo_magazine/s357)
	options["Deckard .38 (.38)"] = list(/obj/item/weapon/gun/projectile/revolver/deckard, /obj/item/ammo_magazine/s38/rubber, /obj/item/ammo_magazine/s38/rubber)
	options["P92X (9mm)"] = list(/obj/item/weapon/gun/projectile/p92x/sec, /obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/rubber)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)