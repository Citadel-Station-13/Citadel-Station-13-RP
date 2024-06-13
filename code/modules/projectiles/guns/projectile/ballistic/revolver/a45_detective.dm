/obj/item/gun/projectile/ballistic/revolver/detective45
	name = ".45 revolver"
	desc = "A fancy replica of an old revolver, modified for .45 rounds and a seven-shot cylinder."
	icon_state = "detective"
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a45/rubber
	max_shells = 7


/obj/item/gun/projectile/ballistic/revolver/detective45/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Rename your gun. If you're the Detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Detective")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/ballistic/revolver/detective45/verb/reskin_gun()
	set name = "Resprite gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["Colt Detective Special"] = "detective"
	options["Ruger GP100"] = "GP100"
	options["Colt Single Action Army"] = "detective_peacemaker"
	options["Colt Single Action Army, Dark"] = "detective_peacemaker_dark"
	options["H&K PT"] = "detective_panther"
	options["Vintage LeMat"] = "lemat_old"
	options["Webley MKVI "] = "webley"
	options["Lombardi Buzzard"] = "detective_buzzard"
	options["Constable Deluxe 2502"] = "detective_constable"
	options["Synth Tracker"] = "deckard-loaded"
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Say hello to your new friend.")
		return 1
