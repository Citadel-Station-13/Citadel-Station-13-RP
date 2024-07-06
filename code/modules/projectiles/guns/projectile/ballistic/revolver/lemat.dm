/obj/item/gun/projectile/ballistic/revolver/lemat
	name = "LeMat Revolver"
	desc = "The LeMat revolver is a 9-shot revolver with a secondar barrel for firing shotgun shells. Cybersun Industries still produces this iconic revolver in limited numbers, deliberately inflating the value of these collectible reproduction pistols. Uses .38 rounds and 12g shotgun shells."
	icon_state = "lemat"
	item_state = "revolver"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 9
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38
	projectile_type = /obj/projectile/bullet/pistol
	var/secondary_max_shells = 1
	var/secondary_caliber = "12g"
	var/secondary_ammo_type = /obj/item/ammo_casing/a12g
	var/flipped_firing = 0
	var/list/secondary_loaded = list()
	var/list/tertiary_loaded = list()

/obj/item/gun/projectile/ballistic/revolver/lemat/Initialize(mapload)
	for(var/i in 1 to secondary_max_shells)
		secondary_loaded += new secondary_ammo_type(src)
	return ..()

/obj/item/gun/projectile/ballistic/revolver/lemat/verb/swap_firingmode()
	set name = "Swap Firing Mode"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Click to swap from one method of firing to another."

	var/mob/living/carbon/human/M = usr
	if(!M.mind)
		return 0

	to_chat(M, "<span class='notice'>You change the firing mode on \the [src].</span>")
	if(!flipped_firing)
		if(max_shells && secondary_max_shells)
			max_shells = secondary_max_shells

		if(caliber && secondary_caliber)
			caliber = secondary_caliber

		if(ammo_type && secondary_ammo_type)
			ammo_type = secondary_ammo_type

		if(secondary_loaded)
			tertiary_loaded = loaded.Copy()
			loaded = secondary_loaded

		flipped_firing = 1

	else
		if(max_shells)
			max_shells = initial(max_shells)

		if(caliber && secondary_caliber)
			caliber = initial(caliber)

		if(ammo_type && secondary_ammo_type)
			ammo_type = initial(ammo_type)

		if(tertiary_loaded)
			secondary_loaded = loaded.Copy()
			loaded = tertiary_loaded

		flipped_firing = 0

/obj/item/gun/projectile/ballistic/revolver/lemat/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = VERB_CATEGORY_OBJECT

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	if(!flipped_firing)
		loaded = shuffle(loaded)
		if(rand(1,max_shells) > loaded.len)
			chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/ballistic/revolver/lemat/examine(mob/user, dist)
	. = ..()
	if(secondary_loaded)
		var/to_print
		for(var/round in secondary_loaded)
			to_print += round
		. += "\The [src] has a secondary barrel loaded with \a [to_print]"
	else
		. += "\The [src] has a secondary barrel that is empty."

/obj/item/gun/projectile/ballistic/revolver/lemat/holy
	name = "Blessed LeMat Revolver"
	ammo_type = /obj/item/ammo_casing/a38/silver
	secondary_ammo_type = /obj/item/ammo_casing/a12g/silver
