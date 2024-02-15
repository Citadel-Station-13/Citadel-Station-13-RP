/obj/item/gun/projectile/ballistic/revolver
	name = "revolver"
	desc = "The Lumoco Arms HE Colt is a choice revolver for when you absolutely, positively need to put a hole in the other guy. Uses .357 rounds."
	icon = 'icons/modules/projectlies/guns/ballistic/revolver.dmi'
	icon_state = "revolver"

	caliber = ".357"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/projectile/bullet/pistol/strong
	magazine_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	magazine_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

/obj/item/gun/projectile/ballistic/revolver/holy
	name = "blessed revolver"
	ammo_type = /obj/item/ammo_casing/a357/silver

/obj/item/gun/projectile/ballistic/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/ballistic/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/ballistic/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()
