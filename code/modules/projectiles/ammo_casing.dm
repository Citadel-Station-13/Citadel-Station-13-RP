/obj/item/ammu_casing
	name = "projectile casing"
	desc = "A projectile's casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 1
	throwrange = 7
	throwspeed = 3
	w_class = ITEMSIZE_TINY

	var/leaves_residue = TRUE										//some bay forensics shit
	var/caliber = ""												//what kinds of magazines/guns can load this
	var/projectile_type = /obj/item/projectile						//Can be directly accessed.
	var/obj/item/projectile/projectile = PROJECTILE_UNINITIALIZED	//DO NOT DIRECTLY ACCESS. Use get_projectile()

/obj/item/ammu_casing/proc/is_spent()
	return istype(projectile) || (projectile == PROJECTILE_UNINITIALIZED)

/obj/item/ammu_casing/proc/initialize_projectile()
	return ((projectile = new projectile_type(src, src)))

/obj/item/ammu_casing/proc/return_projectile()
	return (projectile == PROJECTILE_UNINITIALIZED)? initialize_projectile() : projectile

/obj/item/ammu_casing/Initialize()
	. = ..()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammu_casing/proc/expend_projectile()		//both return and expend
	. = return_projectile()
	if(.)
		projectile = null
		setDir(pick(cardinal))
		update_icon()

/obj/item/ammu_casing/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		var/obj/item/projectile/P = return_projectile()
		if(!P)
			to_chat(user, "<span class='warning'>[src] is empty!.</span>")
			return
		var/text = sanitizeSafe(input(user, "Inscribe some text into [P]", "inscription") as text|null, MAX_NAME_LEN)
		if(!text)
			to_chat(user, "<span class='notice'>You scratch the inscription off of [P].</span>")
			P.name = initial(P.name)
		else
			to_chat(user, "<span class='notice'>You inscribe [text] onto [P].</span>")
			P.name = "[P.name] (\"[text]\")"

/obj/item/ammo_casing/update_icon()
	if(is_spent())
		icon_state = "[initial(icon_state)]-spent"
	else
		icon_state = initial(icon_state)

/obj/item/ammo_casing/examine(mob/user)
	. = ..()
	if(is_spent())
		to_chat(user, "This one is spent.")

