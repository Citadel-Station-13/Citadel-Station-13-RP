/obj/item/gun/projectile/ballistic/colt
	var/unique_reskin
	name = ".45 pistol"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/projectile/bullet/pistol/medium
	icon_state = "colt"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

/obj/item/gun/projectile/ballistic/colt/update_icon_state()
	. = ..()
	if(ammo_magazine)
		if(unique_reskin)
			icon_state = unique_reskin
		else
			icon_state = initial(icon_state)
	else
		if(unique_reskin)
			icon_state = "[unique_reskin]-empty"
		else
			icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/colt/detective
	desc = "A Martian recreation of an old pistol. Uses .45 rounds."
	magazine_type = /obj/item/ammo_magazine/m45/rubber

/obj/item/gun/projectile/ballistic/colt/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Rename your gun. If you're Security."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Detective" && job != "Security Officer" && job != "Warden" && job != "Head of Security")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/ballistic/colt/detective/verb/reskin_gun()
	set name = "Resprite gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["NT Mk. 58"] = "secguncomp"
	options["NT Mk. 58 Custom"] = "secgundark"
	options["Colt M1911"] = "colt"
	options["USP"] = "usp"
	options["H&K VP"] = "VP78"
	options["P08 Luger"] = "p08"
	options["P08 Luger, Brown"] = "p08b"
	options["Glock 37"] = "enforcer_black"
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		unique_reskin = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/ballistic/colt/taj
	name = "Adhomai Pistol"
	desc = "The Adar'Mazy pistol, produced by the Hadii-Wrack group. This pistol is the primary sidearm for low ranking officers and officals in the People's Republic of Adhomai."
	icon_state = "colt-taj"
