/obj/item/gun/projectile/ballistic/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Uses 12g rounds."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	projectile_type = /obj/projectile/bullet/shotgun
	handle_casings = HOLD_CASINGS
	one_handed_penalty = 15
	var/recentpump = 0 // to prevent spammage
	var/action_sound = 'sound/weapons/shotgunpump.ogg'
	load_sound = 'sound/weapons/guns/interaction/shotgun_insert.ogg'
	var/animated_pump = 0 //This is for cyling animations.
	var/empty_sprite = 0 //This is just a dirty var so it doesn't fudge up.

/obj/item/gun/projectile/ballistic/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.get_projectile()
	return null

/obj/item/gun/projectile/ballistic/shotgun/pump/attack_self(mob/user)
	// todo: this breaks other attack self interactions :(
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/gun/projectile/ballistic/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, action_sound, 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	if(animated_pump)//This affects all bolt action and shotguns.
		flick("[icon_state]-cycling", src)//This plays any pumping

	update_icon()

/obj/item/gun/projectile/ballistic/shotgun/pump/update_icon_state()
	. = ..()
	if(!empty_sprite)//Just a dirty check
		return
	if((loaded.len) || (chambered))
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]-empty"

/obj/item/gun/projectile/ballistic/shotgun/pump/slug
	ammo_type = /obj/item/ammo_casing/a12g
