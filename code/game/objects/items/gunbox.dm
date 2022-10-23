/obj/item/gunbox
	name = "security sidearm box (standard)"
	desc = "A secure box containing a security LTL sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"

/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
	options["NT Mk58 (.45)"] = list(/obj/item/gun/projectile/sec, /obj/item/ammo_magazine/m45/rubber, /obj/item/ammo_magazine/m45/flash)
	options["SW 625 Revolver (.45)"] = list(/obj/item/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45/rubber, /obj/item/ammo_magazine/s45/rubber)
	options["P92X (9mm)"] = list(/obj/item/gun/projectile/p92x/sec, /obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/flash)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

/obj/item/gunbox/lethal
	name = "security sidearm box (lethal)"
	desc = "A secure box containing a lethal security sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"

/obj/item/gunbox/lethal/attack_self(mob/living/user)
	var/list/options = list()
	options["M1911 Dynamic (.45)"] = list(/obj/item/gun/projectile/colt, /obj/item/ammo_magazine/m45, /obj/item/ammo_magazine/m45)
	options["SW 625 Revolver (.45)"] = list(/obj/item/gun/projectile/revolver/detective45, /obj/item/ammo_magazine/s45, /obj/item/ammo_magazine/s45)
	options["P92X (9mm)"] = list(/obj/item/gun/projectile/p92x, /obj/item/ammo_magazine/m9mm, /obj/item/ammo_magazine/m9mm)
	var/choice = input(user,"Would you prefer a pistol or a revolver?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

/*
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
*/

/obj/item/gunbox/marksman
	name = "marksman gun box"
	desc = "A secure box containing a marksman rifle."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
	w_class = ITEMSIZE_HUGE

/obj/item/gunbox/marksman/attack_self(mob/living/user)
	var/list/options = list()
	options["Marksman Energy Rifle"] = list(/obj/item/gun/energy/sniperrifle/locked)
	options["M1A Garand"] = list(/obj/item/gun/projectile/garand/sniper, /obj/item/storage/belt/security/tactical/bandolier, /obj/item/ammo_magazine/m762garand/sniperhunter, /obj/item/ammo_magazine/m762garand/sniperhunter, /obj/item/ammo_magazine/m762garand/sniperhunter, /obj/item/ammo_magazine/m762garand/sniperhunter, /obj/item/ammo_magazine/m762garand/sniperhunter, /obj/item/ammo_magazine/m762garand/sniperhunter, /obj/item/ammo_magazine/m762garand/sniperhunter) // 7 clips, 56 rounds
	var/choice = input(user,"Would you prefer a ballistic rifle or a laser?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have chosen \the [AM]. Say hello to your new friend.")
		qdel(src)

//Foam Gunboxes
/obj/item/gunbox/donksoft
	name = "DONKsoft gun box (pistol)"
	desc = "A cardboard box containing a DONKsoft weapon."
	icon = 'icons/obj/storage.dmi'
	icon_state = "donkbox"

/obj/item/gunbox/donksoft/attack_self(mob/living/user)
	var/list/options = list()
	options["Classic DONKsoft Pistol"] = list(/obj/item/gun/projectile/pistol/foam, /obj/item/ammo_magazine/mfoam/pistol, /obj/item/ammo_magazine/mfoam/pistol)
	options["Blue DONKsoft Pistol"] = list(/obj/item/gun/projectile/pistol/foam/blue, /obj/item/ammo_magazine/mfoam/pistol, /obj/item/ammo_magazine/mfoam/pistol)
	options["DONKsoft Automag"] = list(/obj/item/gun/projectile/pistol/foam/magnum, /obj/item/ammo_magazine/mfoam/pistol, /obj/item/ammo_magazine/mfoam/pistol)
	var/choice = input(user,"What toy is in this box?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have pulled out \the [AM]. Say hello to your new friend.")
		qdel(src)

/obj/item/gunbox/donksoft/shotgun
	name = "DONKsoft gun box (shotgun)"
	desc = "A cardboard box containing a DONKsoft weapon."
	icon = 'icons/obj/storage.dmi'
	icon_state = "donkbox2"

/obj/item/gunbox/donksoft/shotgun/attack_self(mob/living/user)
	var/list/options = list()
	options["Classic DONKsoft Shotgun"] = list(/obj/item/gun/projectile/shotgun/pump/foam, /obj/item/storage/box/foamdart, /obj/item/storage/box/foamdart)
	options["Blue DONKsoft Shotgun"] = list(/obj/item/gun/projectile/shotgun/pump/foam/blue, /obj/item/storage/box/foamdart, /obj/item/storage/box/foamdart)
	var/choice = input(user,"What toy is in this box?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have pulled out \the [AM]. Say hello to your new friend.")
		qdel(src)

/obj/item/gunbox/donksoft/smg
	name = "DONKsoft gun box (smg)"
	desc = "A cardboard box containing a DONKsoft weapon."
	icon = 'icons/obj/storage.dmi'
	icon_state = "donkbox3"

/obj/item/gunbox/donksoft/smg/attack_self(mob/living/user)
	var/list/options = list()
	options["Classic DONKsoft SMG"] = list(/obj/item/gun/projectile/automatic/advanced_smg/foam, /obj/item/ammo_magazine/mfoam/smg, /obj/item/ammo_magazine/mfoam/smg)
	options["Blue DONKsoft SMG"] = list(/obj/item/gun/projectile/automatic/advanced_smg/foam/blue, /obj/item/ammo_magazine/mfoam/smg, /obj/item/ammo_magazine/mfoam/smg)
	var/choice = input(user,"What toy is in this box?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have pulled out \the [AM]. Say hello to your new friend.")
		qdel(src)
