
/obj/item/gun/projectile/ballistic/konigin
	name = "Konigin-63 compact"
	desc = "A compact pistol with an underslung single-round shotgun barrel. Uses 9mm."
	description_fluff = "Originally produced in 2463 by GMC, the Konigin is considered to be the direct ancestor to the P3 Whisper. Considerably more expensive to manufacture and maintain, the Konigin saw limited use outside of Syndicate special operations cells. By the time GMC ended production of the Konigin-63, the weapon had undergone significant design changes - most notably the installment of a single capacity underbarrel shotgun. This rare design is certainly inspired, and has become something of a collector's item post-war."
	icon_state = "konigin"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "9mm"
	suppressible = TRUE
	silenced_icon = "konigin_silencer"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact/double
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/gun/projectile/ballistic/konigin
	firemodes = list(
		list(mode_name="pistol",       burst=1,    fire_delay=0,    move_delay=null, use_shotgun=null, burst_accuracy=null, dispersion=null),
		list(mode_name="shotgun",  burst=null, fire_delay=null, move_delay=null, use_shotgun=1,    burst_accuracy=null, dispersion=null)
		)

	var/use_shotgun = 0
	var/obj/item/gun/projectile/ballistic/shotgun/underslung/shotgun

/obj/item/gun/projectile/ballistic/konigin/Initialize(mapload)
	. = ..()
	shotgun = new(src)

/obj/item/gun/projectile/ballistic/konigin/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/a12g)))
		shotgun.load_ammo(I, user)
	else
		..()

/obj/item/gun/projectile/ballistic/konigin/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && use_shotgun)
		shotgun.unload_ammo(user)
	else
		..()

/obj/item/gun/projectile/ballistic/konigin/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_shotgun)
		shotgun.Fire(target, user, params, pointblank, reflex)
	else
		..()
