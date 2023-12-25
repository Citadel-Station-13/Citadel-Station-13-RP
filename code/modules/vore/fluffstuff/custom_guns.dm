// For general use

// For general use

// For general use
/obj/item/gun/projectile/energy/imperial
	name = "imperial energy pistol"
	desc = "An elegant weapon developed by the Imperium Auream. Their weaponsmiths have cleverly found a way to make a gun that is only about the size of an average energy pistol, yet with the fire power of a laser carbine."
	icon_state = "ge_pistol"
	item_state = "ge_pistol"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	item_icons = list(SLOT_ID_RIGHT_HAND = 'icons/obj/gun/energy.dmi', SLOT_ID_LEFT_HAND = 'icons/obj/gun/energy.dmi') // WORK YOU FUCKING CUNT PIECE OF SHIT BASTARD STUPID BITCH ITEM ICON AAAAHHHH
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "ge_pistol_r", SLOT_ID_LEFT_HAND = "ge_pistol_l")
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000)
	projectile_type = /obj/projectile/beam/imperial



//Not so civilian gun
/obj/item/gun/projectile/ballistic/giskard/olivaw
	name = "\improper \"Olivaw\" holdout burst-pistol"
	desc = "The FS HG .380 \"Olivaw\" is a more advanced version of the \"Giskard\". This one seems to have a two-round burst-fire mode. Uses .380 rounds."
	icon_state = "olivawcivil"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=1.2,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=0.2, move_delay=4,    burst_accuracy=list(0,-15),       dispersion=list(1.2, 1.8)),
		)

/obj/item/gun/projectile/ballistic/giskard/olivaw/update_icon_state()
	. = ..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"

//Detective gun

// No idea what this is for.

//HoP gun
/obj/item/gun/projectile/energy/gun/martin
	name = "holdout energy gun"
	desc = "The FS PDW E \"Martin\" is small holdout e-gun. Don't miss!"
	icon_state = "PDW"
	item_state = "gun"
	w_class = ITEMSIZE_SMALL
	projectile_type = /obj/projectile/beam/stun
	charge_cost = 1200
	charge_meter = 0
	modifystate = null
	battery_lock = 1
	fire_sound = 'sound/weapons/Taser.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', charge_cost = 600),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_sound='sound/weapons/Laser.ogg', charge_cost = 1200),
		)

/obj/item/gun/projectile/energy/gun/martin/update_overlays()
	. = ..()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun")
			. += "taser_pdw"
		if("lethal")
			. += "lazer_pdw"

//---------------- Beams ----------------
/obj/projectile/beam/eluger
	name = "laser beam"
	icon_state = "xray"
	light_color = "#00FF00"
	hitscan_muzzle_type = /obj/effect/projectile/muzzle/xray
	hitscan_tracer_type = /obj/effect/projectile/tracer/xray
	hitscan_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/imperial
	name = "laser beam"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon_state = "darkb"
	light_color = "#8837A3"
	hitscan_muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	hitscan_tracer_type = /obj/effect/projectile/tracer/darkmatter
	hitscan_impact_type = /obj/effect/projectile/impact/darkmatter

/obj/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	light_color = "#0000FF"
	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_omni
	hitscan_impact_type = /obj/effect/projectile/impact/laser_omni

//--------------- StG-60 ----------------
/obj/item/ammo_magazine/m792
	name = "box mag (7.92x33mm Kurz)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stg_30rnd"
	caliber = "7.92x33mm"
	ammo_type = /obj/item/ammo_casing/a792
	ammo_max = 30
	mag_type = MAGAZINE

/obj/item/ammo_casing/a792
	desc = "A 7.92x33mm Kurz casing."
	icon_state = "rifle-casing"
	caliber = "7.92x33mm"
	projectile_type = /obj/projectile/bullet/rifle/a762

/obj/item/ammo_magazine/mtg/empty
	initial_ammo = 0

//---------------- PDW ------------------
/obj/item/ammo_magazine/m9mml
	name = "\improper SMG magazine (9mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	materials_base = list(MAT_STEEL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	ammo_max = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mml/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mml/ap
	name = "\improper SMG magazine (9mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a9mm/ap

//.380
/obj/item/ammo_casing/a380
	desc = "A .380 bullet casing."
	caliber = ".380"
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/ammo_magazine/m380
	name = "magazine (.380)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	materials_base = list(MAT_STEEL = 480)
	caliber = ".380"
	ammo_type = /obj/item/ammo_casing/a380
	ammo_max = 8
	multiple_sprites = 1

//.44
/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_magazine/m44/rubber
	desc = "A magazine for .44 less-than-lethal ammo."
	ammo_type = /obj/item/ammo_casing/a44/rubber

//.44 speedloaders
/obj/item/ammo_magazine/s44
	name = "speedloader (.44)"
	desc = "A speedloader for .44 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "s357"
	caliber = ".44"
	materials_base = list(MAT_STEEL = 1260)
	ammo_type = /obj/item/ammo_casing/a44
	ammo_max = 6
	multiple_sprites = 1
	mag_type = SPEEDLOADER

/obj/item/ammo_magazine/s44/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "r357"
	ammo_type = /obj/item/ammo_casing/a44/rubber

//Expedition pistol
/obj/item/gun/projectile/energy/frontier
	name = "Expedition Crank Phaser"
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization."
	icon_state = "phaser"
	item_state = "phaser"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "phaser", SLOT_ID_LEFT_HAND = "phaser", "SLOT_ID_BELT" = "phaser")
	fire_sound = 'sound/weapons/laser_rifle_1.wav'
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	charge_cost = 300
	battery_lock = 1

	var/recharging = 0
	var/phase_power = 75

	projectile_type = /obj/projectile/beam
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/projectile/beam, charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/projectile/beam/weaklaser, charge_cost = 60),
	)

/obj/item/gun/projectile/energy/frontier/unload_ammo(var/mob/user)
	if(recharging)
		return
	recharging = 1
	update_icon()
	user.visible_message("<span class='notice'>[user] opens \the [src] and starts pumping the handle.</span>", \
						"<span class='notice'>You open \the [src] and start pumping the handle.</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(power_supply.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()

/obj/item/gun/projectile/energy/frontier/update_icon()
	if(recharging)
		icon_state = "[initial(icon_state)]_pump"
		update_held_icon()
		return
	..()

/obj/item/gun/projectile/energy/frontier/emp_act(severity)
	return ..(severity+2)

/obj/item/gun/projectile/energy/frontier/legacy_ex_act() //|rugged|
	return

/obj/item/gun/projectile/energy/frontier/locked
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	pin = /obj/item/firing_pin/explorer

//Phaser Carbine - Reskinned phaser
/obj/item/gun/projectile/energy/frontier/locked/carbine
	name = "Expedition Phaser Carbine"
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been produced in limited numbers so far. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon_state = "carbinekill"
	item_state = "retro"
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi')

	modifystate = "carbinekill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/projectile/beam, modifystate="carbinekill", charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/projectile/beam/weaklaser, modifystate="carbinestun", charge_cost = 60),

	)

/obj/item/gun/projectile/energy/frontier/locked/carbine/update_icon_state()
	. = ..()
	if(recharging)
		icon_state = "[modifystate]_pump"
		update_held_icon()

//Expeditionary Holdout Phaser Pistol
/obj/item/gun/projectile/energy/frontier/locked/holdout
	name = "Holdout Phaser Pistol"
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "holdoutkill"
	item_state = null
	fire_sound = 'sound/weapons/laser_holdout_1.wav'
	phase_power = 100

	w_class = ITEMSIZE_SMALL
	charge_cost = 600
	modifystate = "holdoutkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/projectile/beam, modifystate="holdoutkill", charge_cost = 600),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/projectile/beam/weaklaser, modifystate="holdoutstun", charge_cost = 120),
		list(mode_name="stun", fire_delay=12, projectile_type=/obj/projectile/beam/stun/med, modifystate="holdoutshock", charge_cost = 300),
	)

/obj/item/gun/projectile/energy/frontier/taj
	name = "Adhomai crank laser"
	desc = "The \"Icelance\" crank charged laser rifle, produced by the Hadii-Wrack group for the People's Republic of Adhomai's Grand People's Army."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "phaser-taj"
	item_state = "phaser-taj"
	wielded_item_state = "phaser-taj"
	charge_cost = 600

	projectile_type = /obj/projectile/beam/midlaser


	firemodes = list(
	)

/obj/item/gun/projectile/energy/frontier/taj/unload_ammo(var/mob/user)
	if(recharging)
		return
	recharging = 1
	update_icon()
	user.visible_message("<span class='notice'>[user] begins to turn the crank of \the [src].</span>", \
						"<span class='notice'>You begins to turn the crank of \the [src].</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(power_supply.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()
