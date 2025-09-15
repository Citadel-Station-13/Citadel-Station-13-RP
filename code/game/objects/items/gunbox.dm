/obj/item/gunbox
	name = "security sidearm box (standard)"
	desc = "A secure box containing a security LTL sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"
	worth_intrinsic = 350

/obj/item/gunbox/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["NT Mk58 (.45)"] = list(/obj/item/gun/projectile/ballistic/sec, /obj/item/ammo_magazine/a45/doublestack/rubber, /obj/item/ammo_magazine/a45/doublestack/flash)
	options["SW 625 Revolver (.45)"] = list(/obj/item/gun/projectile/ballistic/revolver/detective45, /obj/item/ammo_magazine/a45/speedloader/rubber, /obj/item/ammo_magazine/a45/speedloader/rubber)
	options["P92X (9mm)"] = list(/obj/item/gun/projectile/ballistic/p92x/sec, /obj/item/ammo_magazine/a9mm/rubber, /obj/item/ammo_magazine/a9mm/flash)
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
	worth_intrinsic = 450

/obj/item/gunbox/lethal/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["M1911 Dynamic (.45)"] = list(/obj/item/gun/projectile/ballistic/colt, /obj/item/ammo_magazine/a45/singlestack, /obj/item/ammo_magazine/a45/singlestack)
	options["SW 625 Revolver (.45)"] = list(/obj/item/gun/projectile/ballistic/revolver/detective45, /obj/item/ammo_magazine/a45/speedloader, /obj/item/ammo_magazine/a45/speedloader)
	options["P92X (9mm)"] = list(/obj/item/gun/projectile/ballistic/p92x, /obj/item/ammo_magazine/a9mm, /obj/item/ammo_magazine/a9mm)
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
	w_class = WEIGHT_CLASS_HUGE

/obj/item/gunbox/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options[".45 Pistol"] = list(/obj/item/gun/projectile/ballistic/colt/detective, /obj/item/ammo_magazine/a45/rubber, /obj/item/ammo_magazine/a45/rubber)
	options[".45 Revolver"] = list(/obj/item/gun/projectile/ballistic/revolver/detective45, /obj/item/ammo_magazine/a45/speedloader/rubber, /obj/item/ammo_magazine/a45/speedloader/rubber)
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
	w_class = WEIGHT_CLASS_HUGE

/obj/item/gunbox/marksman/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["Marksman Energy Rifle"] = list(/obj/item/gun/projectile/energy/sniperrifle/locked)
	options["Expeditionary Reconnaissance Rifle"] = list(/obj/item/gun/projectile/ballistic/reconrifle, /obj/item/storage/belt/security/tactical/bandolier, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm, /obj/item/ammo_magazine/a7_62mm) // 10x 10rnd mags (max belt carry capacity)
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

/obj/item/gunbox/donksoft/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["Classic DONKsoft Pistol"] = list(/obj/item/gun/projectile/ballistic/pistol/foam, /obj/item/ammo_magazine/foam/pistol, /obj/item/ammo_magazine/foam/pistol)
	options["Blue DONKsoft Pistol"] = list(/obj/item/gun/projectile/ballistic/pistol/foam/blue, /obj/item/ammo_magazine/foam/pistol, /obj/item/ammo_magazine/foam/pistol)
	options["DONKsoft Automag"] = list(/obj/item/gun/projectile/ballistic/pistol/foam/magnum, /obj/item/ammo_magazine/foam/pistol, /obj/item/ammo_magazine/foam/pistol)
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

/obj/item/gunbox/donksoft/shotgun/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["Classic DONKsoft Shotgun"] = list(/obj/item/gun/projectile/ballistic/shotgun/pump/foam, /obj/item/ammo_magazine/foam/box, /obj/item/ammo_magazine/foam/box)
	options["Blue DONKsoft Shotgun"] = list(/obj/item/gun/projectile/ballistic/shotgun/pump/foam/blue, /obj/item/ammo_magazine/foam/box, /obj/item/ammo_magazine/foam/box)
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

/obj/item/gunbox/donksoft/smg/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["Classic DONKsoft SMG"] = list(/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam, /obj/item/ammo_magazine/foam/smg, /obj/item/ammo_magazine/foam/smg)
	options["Blue DONKsoft SMG"] = list(/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam/blue, /obj/item/ammo_magazine/foam/smg, /obj/item/ammo_magazine/foam/smg)
	var/choice = input(user,"What toy is in this box?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things, the gun and the ammo.
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/gun))
				to_chat(user, "You have pulled out \the [AM]. Say hello to your new friend.")
		qdel(src)

/obj/item/gunbox/carrier/blueshield
	name = "\improper Blueshield armor box"
	desc = "A secure box containing a Blueshield's carrier and armor plate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"

/obj/item/gunbox/carrier/blueshield/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["\improper Black Carrier"] = list(/obj/item/clothing/suit/storage/hooded/covertcarrier/blueshield)
	options["\improper Black-Short Carrier"] = list(/obj/item/clothing/suit/storage/hooded/covertcarrier/blueshield/alt)
	options["\improper Navy Carrier"] = list(/obj/item/clothing/suit/storage/hooded/covertcarrier/blueshield/navy)
	var/choice = input(user,"Select which plate carrier you find within the box.") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/clothing))
				to_chat(user, "You withdraw \the [AM].")
		qdel(src)

/obj/item/gunbox/armor/security
	name = "\improper Security armor box"
	desc = "A secure box containing a single Corporate Security armor vest."
	icon = 'icons/obj/storage.dmi'
	icon_state = "gunbox"

/obj/item/gunbox/armor/security/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["\improper Flat Vest"] = list(/obj/item/clothing/suit/armor/vest)
	options["\improper Security Vest"] = list(/obj/item/clothing/suit/armor/vest/alt)
	options["\improper Webbed Vest"] = list(/obj/item/clothing/suit/storage/vest/officer)
	var/choice = input(user,"Select the armor vest you find within the box.") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/clothing))
				to_chat(user, "You withdraw \the [AM].")
		qdel(src)
