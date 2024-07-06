/obj/item/gun/projectile/ballistic/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. Uses 12g rounds."
	icon_state = "shotgun_c"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/a12g
	load_method = SINGLE_CASING|SPEEDLOADER

/obj/item/gun/projectile/ballistic/shotgun/pump/combat/warden
	name = "warden's shotgun"
	desc = "A heavily modified Hephaestus Industries KS-40. This version bears multiple after-market mods, including a laser sight to help compensate for its shortened stock. 'Property of the Warden' has been etched into the side of the reciever. Uses 12g rounds."
	icon_state = "shotgun_w"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/gun/projectile/ballistic/shotgun/pump/combat/warden/verb/rename_gun()
	set name = "Name Gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Rename your gun. If you're the Warden."

	var/mob/M = usr
	if(!M.mind)	return 0
	var/job = M.mind.assigned_role
	if(job != "Warden")
		to_chat(M, "<span class='notice'>You don't feel cool enough to name this gun.</span>")
		return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		to_chat(M, "You name the gun [input]. Lock and load.")
		return 1

/obj/item/gun/projectile/ballistic/shotgun/pump/combat/warden/verb/reskin_gun()
	set name = "Resprite gun"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["KS-40 CQC"] = "shotgun_w"
	options["NT Limted Run CQ-6"] = "shotgun_w_corp"
	options["WT Sabot Stinger"] = "shotgun_w_sting"
	options["Donksoft Prank Kit"] = "shotgun_w_donk"
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		icon_state = options[choice]
		item_state = options[choice]
		to_chat(M, "Your gun is now sprited as [choice]. Lock and load.")
		update_icon()
		return 1
