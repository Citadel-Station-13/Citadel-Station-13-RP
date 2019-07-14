// Energy weapons for explorers.
// For those who like pretty lights and the smell of ozone.


//The las-rifle is the standard for energy weapons, unlike the standard laser rifle it does not have any armor penetration, \
nor alternate firing modes. Use this as the base line for laser weapon balance. -Kazkin
/obj/item/weapon/gun/energy/exlaserrifle
	name = "\improper expedition las-rifle"
	desc = "A Void Runner, LLC. produced laser rifle modeled after an existing and old ballistic rifle. What it lacks in function \
	and armor penetration that a standard laser rifle has it makes up for in durability and price. This one appears to be \
	missing its safety lock."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "stg60"
	wielded_item_state = "bullpup"
	fire_delay = 8
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 10
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/exlas
//	one_handed_penalty = 30
	charge_cost = 240

/obj/item/weapon/gun/energy/exlaserrifle/update_icon()
	..()
	if(power_supply)
		icon_state = "stg60"
	else
		icon_state = "stg60-empty"




// An alternative option to the weaker but longer lasting ballistic pistols. The bolter does high damage and has \
mild armor penetration, greater than the las-rifle, but suffers from massive ammo consumption which makes it \
strictly a hold out pistol to use in an emergency. -Kazkin
/obj/item/weapon/gun/energy/exlaserpistol
	name = "\improper expedition 'bolter'"
	desc = "Officially named the A38 Hi-Zap pistol this weapon is commonly referred to by its acronym or more \
	commonly as the 'bolter' pistol. A popular choice for a sidearm given its high intensity shots but commonly \
	considered inferior due to its rapid ammo consumption. This one appears to be missing its safety lock."
	icon = 'icons/obj/gun.dmi'
	icon_state = "oldlaser"
	item_state = "oldlaser"
	wielded_item_state = "laser"
	fire_delay = 6
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_NORMAL
	force = 8
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/bolterlaser
	charge_cost = 800




// This weapon is probably the most varied and with luck most powerful of the energy option. The burst mode takes a \
accuracy penalty but if all shots hit an unarmored target it deals the same damage as a laser shotgun. The upside \
being 10 shots instead of 6. Alternatively one could use the semi auto for 30 total shots at half the damage of a \
las-rifle. It's also, unsurprisingly, the best laser weapon for shooting hordes in a hallway. -Kazkin
/obj/item/weapon/gun/energy/exlasersmg
	name = "\improper expedition las-burster"
	desc = "One of the few guns of skrell origin favored by frontier forces in need of energy weaponry. \
	What it loses in stopping power it gains in ammo effeciency and high fire rate, a perfect weapon for \
	long trips without much spare ammo. This one appears to be missing its safety lock."
	icon = 'icons/obj/gun.dmi'
	icon_state = "fm-2tkill100"
	item_state = null
	wielded_item_state = "c20r"
	fire_delay = 4
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_NORMAL
	force = 8
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type=/obj/item/projectile/beam/smglaser
	charge_cost = 80
	modifystate = "fm-2tkill"


	firemodes = list(
		list(mode_name="semi-auto", burst=1, projectile_type=/obj/item/projectile/beam/smglaser, modifystate="fm-2tkill", charge_cost = 80),
		list(mode_name="three-round burst", burst=3, fire_delay=null, move_delay=4, burst_accuracy=list(0,-15,-15), dispersion=list(0.0, 0.6, 1.0), projectile_type=/obj/item/projectile/beam/smglaser, modifystate="fm-2tkill"),
		)



// The laser shotgun provides a high damage good armor penetration option for dealing with melee enemies but due to its \
hard range limit for 5 tiles range enemies have a massive advantage over you. It's bulky size also makes it tricky to \
wield without preperation. -Kazkin
/obj/item/weapon/gun/energy/exlasershotgun
	name = "\improper expedition 'melter'"
	desc = "One of the few weapons made first by Nanotrasen and then heavily modified by the Void Runners, LLC. \
	Officially named the Koro-6751 Atomic Zapper by its inventor this weapon is usually referred to by its slang name the \
	'Melter' and sports a high damage and intensely concentrated energy blast. Sadly, such concentration gives it low range \
	and high recoil. This one appears to be missing its safety lock."
	icon = 'icons/obj/gun.dmi'
	icon_state = "mod_cannon"
	item_state = "mod_cannon"
	wielded_item_state = "pulse"
	fire_delay = 15
	recoil = 2
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_HUGE
	force = 15
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/exheavylaser
	//	one_handed_penalty = 90 // The thing's heavy and huge.
	accuracy = 45
	charge_cost = 400
	modifystate = "mod_cannon"





//Expedition beam types
//Makes keeping track of laser projectiles a lot simpler by putting it here.

/obj/item/projectile/beam/bolterlaser
	name = "bolter laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/laser3.ogg'
	damage = 50
	armor_penetration = 20
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

/obj/item/projectile/beam/exlas
	name = "cyan beam"
	icon_state = "cyan"
	fire_sound = 'sound/weapons/blaster.ogg'
	damage = 40
	light_color = "#00C6FF"

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/smglaser
	name = "smg laser"
	icon_state = "bluelaser"
	fire_sound = 'sound/weapons/laser2.ogg'
	damage = 20
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/emitter/muzzle
	tracer_type = /obj/effect/projectile/emitter/tracer
	impact_type = /obj/effect/projectile/emitter/impact

/obj/item/projectile/beam/exheavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/pulse.ogg'
	damage = 60
	armor_penetration = 30
	light_range = 4
	light_power = 2
	light_color = "#FF0D00"
	kill_count = 4





// Ballistic weapons for explorers.
// For when you prefer something with more kick to it.


//The revolver exists as a low damage low quality low cost side arm used if you need a quickdraw when you don't have \
time to pause and reload. It's definately the weakest of any weapon and therefor the cheapest. -Kazkin
/obj/item/weapon/gun/projectile/explorer/exrevolver
	name = "expedition revolver"
	desc = "A low-grade but reliable side arm for border world mercenaries and explorers, a staple for those wanting a cheap \
	back up that won't jam. Uses .38 rounds. This one appears to be missing its safety lock."
	icon_state = "mosley"
	item_state = "mosley"
	caliber = ".38"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	handle_casings = CYCLE_CASINGS
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a38
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round



// The uzi is by comparison to the only other burst weapon, the las-burster, a directly inferior option. It's low \
damage, highly inaccurate at medium to long range, and has a measly clip of 10 bullets. The advantage is it has the same \
damage as the revoler per shot and can alternatively use a burst mode for close range mag dumps. A good and cheap choice. -Kazkin
/obj/item/weapon/gun/projectile/explorer/exmini_uzi
	name = "\improper expedition uzi"
	desc = "An iconic uzi with many after market adjustments, primarily, a burst fire setting and caliber shift to cheaper \
	9mm rounds. For the those who favor the spray and pray style. Uses 9mm rounds. This one appears to be missing its \
	safety lock."
	icon_state = "mini-uzi"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	load_method = MAGAZINE
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1, TECH_ILLEGAL = 1)
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm)

	firemodes = list(
		list(mode_name="semiauto", burst=1, fire_delay=0),
		list(mode_name="3-round bursts", burst=3, burst_delay=1, fire_delay=4, move_delay=4, burst_accuracy = list(0,-15,-15,-30,-30), dispersion = list(0.6, 1.0, 1.0))
		)

/obj/item/weapon/gun/projectile/explorer/exmini_uzi/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "mini-uzi"
	else
		icon_state = "mini-uzi-empty"



// The jack of trades weapon, its good at any range, decent size magazine, decent damage, and low cost compared to \
rifle options. Virtually identical to standard forty five pistols that security has barring its safety lock. -Kazkin
/obj/item/weapon/gun/projectile/explorer/expistol
	name = "expedition pistol"
	desc = "A standard pistol favored by law enforcement and mercenary alike for its low price, decent stopping power, and \
	light weight. This one was produced by the Void Runners, LLC. Uses .45 rounds. This one appears to be missing its safety lock."
	magazine_type = /obj/item/ammo_magazine/m45
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "olivawcivil"
	item_state = "olivawcivil"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/explorer/expistol/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"



// Another identical weapon to the standard pump shotgun. The advantage this has is high damage and armor penetration \
but suffers from long reload times compared to other guns and a very small maximum shell load of 5 if one is chambered. \
Reloading is slightly quicker if one either clicks fast or ammo dumps via clicking the gun with an ammo box. -Kazkin
/obj/item/weapon/gun/projectile/explorer/expump
	name = "expedition shotgun"
	desc = "The iconic pump action shotgun modeled after an existing design and created by the Voids Runners, LLC. A favorite \
	for its high stopping power and armor penetration. Uses 12g rounds. This one appears to be missing its safety lock."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "shotgun-empty"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEMSIZE_LARGE
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = SINGLE_CASING|SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a12g
	projectile_type = /obj/item/projectile/bullet/shotgun
	handle_casings = HOLD_CASINGS
	var/recentpump = 0 // to prevent spammage
	var/action_sound = 'sound/weapons/shotgunpump.ogg'
	var/animated_pump = 0 //This is for cyling animations.
	var/empty_sprite = 0 //This is just a dirty var so it doesn't fudge up.


/obj/item/weapon/gun/projectile/explorer/expump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/explorer/expump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/explorer/expump/proc/pump(mob/M as mob)
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

/obj/item/weapon/gun/projectile/explorer/expump/update_icon()//This adds empty sprite capability for shotguns.
	..()
	if(!empty_sprite)//Just a dirty check
		return
	if((loaded.len) || (chambered))
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]-empty"



// The carbine is a mid-tier rifle that has the distinct advantage of auto-ejecting empty mags for quicker reload times and \
playing a sound to alert the user their empty of ammo. Otherwise, its just a solid dependable gun. -Kazkin
/obj/item/weapon/gun/projectile/explorer/excarbine
	name = "\improper expedition rifle"
	desc = "A roughly made and sturdy rifle favored for its high ammoy capacity, created by the Void Runner, LLC. What it lacks \
	in refinement it makes up for in accuracy. Uses 5.45mm rounds. This one appears to be missing its safety lock."
	icon_state = "carbine"
	item_state = "carbine"
	wielded_item_state = "z8carbine-wielded"
	w_class = ITEMSIZE_LARGE
	caliber = "5.45mm"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/rifleshot.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m545
	allowed_magazines = list(/obj/item/ammo_magazine/m545)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/garand_ping.ogg'



// For the players who want to rp as a sniper. This weapon does high damage and comes with a scope so one can shoot targets \
off screen. Highly effective when using vision types like thermal. Given many expeditions are in close quarters its advantages \
are very circumstantial. Otherwise its a slow shooting but high damage rifle at a high cost. -Kazkin
/obj/item/weapon/gun/projectile/explorer/exsniper
	name = "\improper expedition sniper"
	desc = "A newer rifle model sold by the Void Runners, LLC and according to a small plate on the handle patented \
	by 'Mikhail M'danil.' A popular weapon among those who wish to be the last thing someone never saw. Uses 7.62mm rounds. \
	This one appears to be missing its safety lock."
	icon_state = "barretsniper"
	item_state = "barretsniper"
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	force = 10
	slot_flags = SLOT_BACK // Needs a sprite.
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1, TECH_ILLEGAL = 1)
	recoil = 2 //extra kickback
	caliber = "7.62mm"
	load_method = MAGAZINE
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 0
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	fire_sound = 'sound/weapons/SVD_shot.ogg'
	magazine_type = /obj/item/ammo_magazine/m762
	allowed_magazines = list(/obj/item/ammo_magazine/m762)


/obj/item/weapon/gun/projectile/explorer/exsniper/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "barretsniper"
	else
		icon_state = "barretsniper-empty"

/obj/item/weapon/gun/projectile/explorer/exsniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)


// A hidden pistol in the ballistic vendor that requires the vendor to be hacked to produce. Much like other weapons this \
one is still safety locked. It's identical to the revolver in damage and uses compact clips but has the advantage of \
being pocket sized for quick draws. Due to being a hidden weapon its design is a bit more personalized and only one exists. -Kazkin
/obj/item/weapon/gun/projectile/explorer/exholdout
	name = "\improper runner's friend"
	desc = "A popular pistol with a unique appearence commonly used by explorers with the Void Runners, LLC. Someone \
	has inscribed 'Reap what you sow' on the handle. Uses 9mm rounds. This one appears to be missing its safety lock."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "makarov"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	w_class = ITEMSIZE_SMALL|SLOT_HOLSTER
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/item/projectile/bullet/pistol


/obj/item/weapon/gun/projectile/explorer/exholdout/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-empty"



// The second hacked weapon with a similar more customized flavor text. It does quite high damage but only loads one shot \
per reload and requires some tricky clicks to be used with any effectiveness outside a quick draw back up. -Kazkin
/obj/item/weapon/gun/projectile/explorer/excontender
	name = "void contender"
	desc = "A modified bolt action hand cannon used by veteran void runners, 'For when their isn't enough prayer in \
	schools' has been inscribed on the handle. Uses .357 rounds. This one appears to be missing its safety lock."
	icon_state = "pockrifle"
	var/icon_retracted = "pockrifle-empty"
	item_state = "revolver"
	caliber = ".357"
	handle_casings = HOLD_CASINGS
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_NORMAL
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	var/retracted_bolt = 0
	load_method = SINGLE_CASING

/obj/item/weapon/gun/projectile/explorer/excontender/attack_self(mob/user as mob)
	if(chambered)
		chambered.loc = get_turf(src)
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You cycle back the bolt on [src], ejecting the casing and allowing you to reload.</span>")
		icon_state = icon_retracted
		retracted_bolt = 1
		return 1
	else if(retracted_bolt && loaded.len)
		to_chat(user, "<span class='notice'>You cycle the loaded round into the chamber, allowing you to fire.</span>")
	else
		to_chat(user, "<span class='notice'>You cycle the boly back into position, leaving the gun empty.</span>")
	icon_state = initial(icon_state)
	retracted_bolt = 0

/obj/item/weapon/gun/projectile/explorer/excontender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't load [src] without cycling the bolt.</span>")
		return
	..()








//Weapon Locks for ballistics and laser weaponry. Try to keep the laser weapons on top.
//For the love of god never spawn the non-locked weapons inside vendors or for players, they can fire anywhere. -Kazkin


// Lasers

/obj/item/weapon/gun/energy/exlaserrifle/locked
	desc = "A Void Runner, LLC. produced laser rifle modeled after an existing and old ballistic rifle. What it lacks in function \
	and armor penetration that a standard laser rifle has it makes up for in durability and price. \
	This one has a safety interlock that prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/energy/exlaserrifle/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/energy/exlaserpistol/locked
	desc = "Officially named the A38 Hi-Zap pistol this weapon is commonly referred to by its acronym or more \
	commonly as the 'bolter' pistol. A popular choice for a sidearm given its high intensity shots but commonly \
	considered inferior due to its rapid ammo consumption. This one has a safety interlock that \
	prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/energy/exlaserpistol/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/energy/exlasersmg/locked
	desc = "One of the few guns of skrell origin favored by frontier forces in need of energy weaponry. \
	What it loses in stopping power it gains in ammo effeciency and high fire rate, a perfect weapon for \
	long trips without much spare ammo. This one has a safety interlock that \
	prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/energy/exlasersmg/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()


/obj/item/weapon/gun/energy/exlasershotgun/locked
	desc = "One of the few weapons made first by Nanotrasen and then heavily modified by the Void Runners, LLC. \
	Officially named the Koro-6751 Atomic Zapper by its inventor this weapon is usually referred to by its slang name the \
	'Melter' and sports a high damage and intensely concentrated energy blast. Sadly, such concentration gives it low range \
	and high recoil. This one has a safety interlock that \
	prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/energy/exlasershotgun/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



//Ballistics



/obj/item/weapon/gun/projectile/explorer/exrevolver/locked
	desc = "A low-grade but reliable side arm for border world mercenaries and explorers, a staple for those wanting a cheap \
	back up that won't jam. Uses .38 rounds. This one has a safety interlock that prevents firing while in \
	proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/exrevolver/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/projectile/explorer/exmini_uzi/locked
	desc = "An iconic uzi with many after market adjustments, primarily, a burst fire setting and caliber shift to cheaper \
	9mm rounds. For the those who favor the spray and pray style. Uses 9mm rounds. This one has a safety \
	interlock that prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/exmini_uzi/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/projectile/explorer/expistol/locked
	desc = "A standard pistol favored by law enforcement and mercenary alike for its low price, decent stopping power, and \
	light weight. This one was produced by the Void Runners, LLC. Uses .45 rounds. This one has a safety interlock that \
	prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/expistol/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()




/obj/item/weapon/gun/projectile/explorer/expump/locked
	desc = "The iconic pump action shotgun modeled after an existing design and created by the Voids Runners, LLC. A favorite \
	for its high stopping power and armor penetration. Uses 12g rounds. This one has a safety interlock that prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/expump/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/projectile/explorer/excarbine/locked
	desc = "A roughly made and sturdy rifle favored for its high ammoy capacity, created by the Void Runner, LLC. What it lacks \
	in refinement it makes up for in accuracy. Uses 5.45mm rounds. This one has a safety interlock that prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/excarbine/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/projectile/explorer/exsniper/locked
	desc = "A newer rifle model sold by the Void Runners, LLC and according to a small plate on the handle patented \
	by 'Mikhail M'danil.' A popular weapon among those who wish to be the last thing someone never saw. Uses 7.62mm rounds. \
	This one has a safety interlock that prevents firing while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/exsniper/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()




/obj/item/weapon/gun/projectile/explorer/exholdout/locked
	desc = "A popular pistol with a unique appearence commonly used by explorers with the Void Runners, LLC. Someone has \
	inscribed 'Reap what you sow' on the handle. Uses 9mm rounds. This one has a safety interlock that prevents firing \
	while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/exholdout/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



/obj/item/weapon/gun/projectile/explorer/excontender/locked
	desc = "A modified bolt action hand cannon used by veteran void runners, 'For when their isn't enough prayer in \
	schools' has been inscribed on the handle. Uses .357 rounds. This one has a safety interlock that prevents firing \
	while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/weapon/gun/projectile/explorer/excontender/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.map_levels)
			to_chat(user, "<span class='warning'>The safety device prevents the gun from firing this close to the facility.</span>")
			return 0
	return ..()



//Armor for explorers, this is an adjustment for the chest armor to have portable generators so they provide cold protection \
for the new map that is being made. Sadly they don't have heat protection or void capability. Initilizaed here for modular ease. \
This will likely be removed for full items later on.

/obj/item/clothing/suit/armor/combat/explorer
	name = "expedition combat vest"
	desc = "A vest that protects the wearer from several common types of weaponry. This one has a portable heat generator built \
	inside to protect against the cold."
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/riot/explorer
	name = "expedition riot vest"
	desc =  "A vest with heavy padding to protect against melee attacks. This one has a portable heat generator built inside \
	to protect against the intense cold."
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/bulletproof/explorer
	name = "expedition ballistic vest"
	desc =  "A vest that excels in protecting the wearer against high-velocity solid projectiles. This one has a portable heat \
	generator built inside to protect against the intense cold."
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/laserproof/explorer
	name = "expedition ablative vest"
	desc =  "A vest that excels in protecting the wearer against energy projectiles. This one has a portable heat \
	generator built inside to protect against the intense cold."
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE


//Belts for explorers, not worth editing the belt file over something so small as this.
/obj/item/weapon/storage/belt/security/explorer
	name = "expedition belt"
	desc = "A belt designed for explorers to carry ammunition and supplies."

/obj/item/weapon/storage/belt/security/tactical/bandolier/explorer
	name = "expedition bandolier"
	desc = "A bandolier designed for explorers to carry ammunition and supplies. You feel tacticool wearing this."
