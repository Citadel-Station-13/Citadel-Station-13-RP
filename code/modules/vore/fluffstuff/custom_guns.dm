// For general use
/obj/item/gun/projectile/ballistic/battlerifle
	name = "\improper JSDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	w_class = ITEMSIZE_LARGE
	recoil = 2 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = "9.5x40mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m95
	allowed_magazines = list(/obj/item/ammo_magazine/m95)
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	one_handed_penalty = 60 // The weapon itself is heavy

// For general use
/obj/item/gun/projectile/ballistic/shotgun/pump/JSDF
	name = "\improper JSDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	ammo_type = /obj/item/ammo_casing/a12g
	max_shells = 12

// For general use
/obj/item/gun/projectile/ballistic/pdw
	name = "personal defense weapon"
	desc = "The X-9MM is a select-fire personal defense weapon designed in-house by Xing Private Security. It was made to compete with the WT550 Saber, but never caught on with NanoTrasen. Uses 9mm rounds."
	icon_state = "pdw"
	item_state = "c20r" // Placeholder
	w_class = ITEMSIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mml
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm, /obj/item/ammo_magazine/m9mml)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30), dispersion=list(0.0, 0.6, 0.6))
		)

/obj/item/gun/projectile/ballistic/pdw/update_icon()
	. = ..()
	update_held_icon()

/obj/item/gun/projectile/ballistic/pdw/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m9mm))
		icon_state = "pdw-short"
	else
		icon_state = (ammo_magazine)? "pdw" : "pdw-empty"

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

// For general use
/obj/item/gun/projectile/ballistic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon_state = "stg60"
	item_state = "arifle"
	w_class = ITEMSIZE_LARGE
	max_shells = 30
	caliber = "7.92x33mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_type = /obj/item/ammo_magazine/mtg
	allowed_magazines = list(/obj/item/ammo_magazine/mtg)
	load_method = MAGAZINE

/obj/item/gun/projectile/ballistic/stg/update_icon()
	. = ..()
	update_held_icon()

/obj/item/gun/projectile/ballistic/stg/update_icon_state()
	. = ..()
	icon_state = (ammo_magazine)? "stg60" : "stg60-e"
	item_state = (ammo_magazine)? "arifle" : "arifle-e"

//-----------------------Tranq Gun----------------------------------
/obj/item/gun/projectile/ballistic/dartgun/tranq
	name = "tranquilizer gun"
	desc = "A gas-powered dart gun designed by the National Armory of Gaia. This gun is used primarily by United Federation special forces for Tactical Espionage missions. Don't forget your bandana."
	icon_state = "tranqgun"
	item_state = null

	caliber = "dart"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	allowed_magazines = list(/obj/item/ammo_magazine/chemdart)
	auto_eject = 0

// ------------ Energy Luger ------------
/obj/item/gun/projectile/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser. Although its battery cannot be removed, its ergonomic design makes it easy to shoot, allowing for rapid follow-up shots. It also has the ability to toggle between stun and kill."
	icon_state = "elugerstun100"
	item_state = "gun"
	fire_delay = null // Lugers are quite comfortable to shoot, thus allowing for more controlled follow-up shots. Rate of fire similar to a laser carbine.
	battery_lock = 1 // In exchange for balance, you cannot remove the battery. Also there's no sprite for that and I fucking suck at sprites. -Ace
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	modifystate = "elugerstun"
	fire_sound = 'sound/weapons/Taser.ogg'
	firemodes = list(
	list(mode_name="stun", charge_cost=120,projectile_type=/obj/projectile/beam/stun, modifystate="elugerstun", fire_sound='sound/weapons/Taser.ogg'),
	list(mode_name="lethal", charge_cost=240,projectile_type=/obj/projectile/beam/eluger, modifystate="elugerkill", fire_sound='sound/weapons/eluger.ogg'),
	)


//Civilian gun
/obj/item/gun/projectile/ballistic/giskard
	name = "\improper \"Giskard\" holdout pistol"
	desc = "The FS HG .380 \"Giskard\" can even fit into the pocket! Uses .380 rounds."
	icon_state = "giskardcivil"
	caliber = ".380"
	magazine_type = /obj/item/ammo_magazine/m380
	allowed_magazines = list(/obj/item/ammo_magazine/m380)
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/obj/item/gun/projectile/ballistic/giskard/update_icon_state()
	. = ..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "giskardcivil"
	else
		icon_state = "giskardcivil_empty"

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
/obj/item/gun/projectile/ballistic/revolver/consul
	name = "\improper \"Consul\" Revolver"
	desc = "Are you feeling lucky, punk? Uses .44 rounds."
	icon_state = "inspector"
	item_state = "revolver"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/rubber
	handle_casings = CYCLE_CASINGS
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)

/obj/item/gun/projectile/ballistic/revolver/consul/update_overlays()
	. = ..()
	if(loaded.len==0)
		. += "inspector_off"
	else
		. += "inspector_on"

// No idea what this is for.
/obj/item/gun/projectile/ballistic/sol
	name = "\improper \"Sol\" SMG"
	desc = "The FS 9x19mm \"Sol\" is a compact and reliable submachine gun. Uses 9mm rounds."
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BELT
	caliber = "9mm"
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm)
	load_method = MAGAZINE
	multi_aim = 1
	burst_delay = 2
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-15,-15),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/gun/projectile/ballistic/sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.ammo_max
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	add_overlay("smg_[ratio]")

/obj/item/gun/projectile/ballistic/sol/update_icon()
	icon_state = (ammo_magazine)? "SMG-IS" : "SMG-IS-empty"
	cut_overlay()
	update_charge()

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

//------------- Battlerifle -------------
/obj/item/ammo_magazine/m95
	name = "box mag (9.5x40mm)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "battlerifle"
	caliber = "9.5x40mm"
	ammo_type = /obj/item/ammo_casing/a95
	ammo_max = 36
	mag_type = MAGAZINE
	multiple_sprites = 1

/obj/item/ammo_casing/a95
	desc = "A 9.5x40mm bullet casing."
	icon_state = "rifle-casing"
	caliber = "9.5x40mm"
	projectile_type = /obj/projectile/bullet/rifle/a95

/obj/projectile/bullet/rifle/a95
	damage = 40

/obj/item/ammo_magazine/m95/empty
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
