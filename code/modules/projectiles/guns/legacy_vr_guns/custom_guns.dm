// For general use
/obj/item/gun/ballistic/automatic/battlerifle
	name = "\improper JSDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	w_class = WEIGHT_CLASS_BULKY
	recoil = 1.5 // The battlerifle was known for its nasty recoil.
	max_shells = 36
	caliber = /datum/ammo_caliber/a9_5mm
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m95
	allowed_magazines = list(/obj/item/ammo_magazine/m95)
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	one_handed_penalty = 60 // The weapon itself is heavy

/obj/item/gun/ballistic/automatic/battlerifle/update_icon()
	. = ..()
	update_worn_icon()

/obj/item/gun/ballistic/automatic/battlerifle/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m95))
		icon_state = "battlerifle"
	else
		icon_state = (ammo_magazine)? "battlerifle" : "battlerifle_empty"

// For general use
/obj/item/gun/ballistic/shotgun/pump/JSDF
	name = "\improper JSDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	ammo_type = /obj/item/ammo_casing/a12g
	max_shells = 12

// For general use
/obj/item/gun/ballistic/automatic/pdw
	name = "personal defense weapon"
	desc = "The X-9MM is a select-fire personal defense weapon designed in-house by Xing Private Security. It was made to compete with the WT550 Saber, but never caught on with Nanotrasen. Uses 9mm rounds."
	icon_state = "pdw"
	item_state = "c20r" // Placeholder
	w_class = WEIGHT_CLASS_NORMAL
	caliber = /datum/ammo_caliber/a9mm
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a9mm/large
	allowed_magazines = list(/obj/item/ammo_magazine/a9mm, /obj/item/ammo_magazine/a9mm/large)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30), dispersion=list(0.0, 0.6, 0.6))
		)

/obj/item/gun/ballistic/automatic/pdw/update_icon()
	. = ..()
	update_worn_icon()

/obj/item/gun/ballistic/automatic/pdw/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/a9mm))
		icon_state = "pdw-short"
	else
		icon_state = (ammo_magazine)? "pdw" : "pdw-empty"

// For general use
/obj/item/gun/energy/imperial
	name = "imperial energy pistol"
	desc = "An elegant weapon developed by the Imperium Auream. Their weaponsmiths have cleverly found a way to make a gun that is only about the size of an average energy pistol, yet with the fire power of a laser carbine."
	icon_state = "ge_pistol"
	item_state = "ge_pistol"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	item_icons = list(SLOT_ID_RIGHT_HAND = 'icons/obj/gun/energy.dmi', SLOT_ID_LEFT_HAND = 'icons/obj/gun/energy.dmi') // WORK YOU FUCKING CUNT PIECE OF SHIT BASTARD STUPID BITCH ITEM ICON AAAAHHHH
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "ge_pistol_r", SLOT_ID_LEFT_HAND = "ge_pistol_l")
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000)
	projectile_type = /obj/projectile/beam/imperial

// For general use
/obj/item/gun/ballistic/automatic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon_state = "stg60"
	item_state = "arifle"
	w_class = WEIGHT_CLASS_BULKY
	max_shells = 30
	caliber = /datum/ammo_caliber/a7_92mm
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_type = /obj/item/ammo_magazine/a7_92mm
	allowed_magazines = list(/obj/item/ammo_magazine/a7_92mm)
	load_method = MAGAZINE

/obj/item/gun/ballistic/automatic/stg/update_icon()
	. = ..()
	update_worn_icon()

/obj/item/gun/ballistic/automatic/stg/update_icon_state()
	. = ..()
	icon_state = (ammo_magazine)? "stg60" : "stg60-e"
	item_state = (ammo_magazine)? "arifle" : "arifle-e"

// ------------ Energy Luger ------------
/obj/item/gun/energy/gun/eluger
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
/obj/item/gun/ballistic/giskard
	name = "\improper \"Giskard\" holdout pistol"
	desc = "The FS HG .380 \"Giskard\" can even fit into the pocket! Uses .380 rounds."
	icon_state = "giskardcivil"
	caliber = /datum/ammo_caliber/a38
	magazine_type = /obj/item/ammo_magazine/a38
	allowed_magazines = list(/obj/item/ammo_magazine/a38)
	load_method = MAGAZINE
	w_class = WEIGHT_CLASS_SMALL
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/obj/item/gun/ballistic/giskard/update_icon_state()
	. = ..()
	if(ammo_magazine && ammo_magazine.amount_remaining())
		icon_state = "giskardcivil"
	else
		icon_state = "giskardcivil_empty"

//Not so civilian gun
/obj/item/gun/ballistic/giskard/olivaw
	name = "\improper \"Olivaw\" holdout burst-pistol"
	desc = "The FS HG .380 \"Olivaw\" is a more advanced version of the \"Giskard\". This one seems to have a two-round burst-fire mode. Uses .380 rounds."
	icon_state = "olivawcivil"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=1.2,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=0.2, move_delay=4,    burst_accuracy=list(0,-15),       dispersion=list(1.2, 1.8)),
		)

/obj/item/gun/ballistic/giskard/olivaw/update_icon_state()
	. = ..()
	if(ammo_magazine && ammo_magazine.amount_remaining())
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"

//Detective gun
/obj/item/gun/ballistic/revolver/consul
	name = "\improper \"Consul\" Revolver"
	desc = "Are you feeling lucky, punk? Uses .44 rounds."
	icon_state = "inspector"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/a44
	ammo_type = /obj/item/ammo_casing/a44/rubber
	handle_casings = CYCLE_CASINGS
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)

/obj/item/gun/ballistic/revolver/consul/update_overlays()
	. = ..()
	if(loaded.len==0)
		. += "inspector_off"
	else
		. += "inspector_on"

// No idea what this is for.
/obj/item/gun/ballistic/automatic/sol
	name = "\improper \"Sol\" SMG"
	desc = "The FS 9x19mm \"Sol\" is a compact and reliable submachine gun. Uses 9mm rounds."
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BELT
	caliber = /datum/ammo_caliber/a9mm
	magazine_type = /obj/item/ammo_magazine/a9mm
	allowed_magazines = list(/obj/item/ammo_magazine/a9mm)
	load_method = MAGAZINE
	multi_aim = 1
	burst_delay = 2
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-15,-15),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/gun/ballistic/automatic/sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.amount_remaining() / ammo_magazine.ammo_max
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	add_overlay("smg_[ratio]")

/obj/item/gun/ballistic/automatic/sol/update_icon()
	icon_state = (ammo_magazine)? "SMG-IS" : "SMG-IS-empty"
	cut_overlay()
	update_charge()

//HoP gun
/obj/item/gun/energy/gun/martin
	name = "holdout energy gun"
	desc = "The FS PDW E \"Martin\" is small holdout e-gun. Don't miss!"
	icon_state = "PDW"
	item_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
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

/obj/item/gun/energy/gun/martin/update_overlays()
	. = ..()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun")
			. += "taser_pdw"
		if("lethal")
			. += "lazer_pdw"

/////////////////////////////////////////////////////
//////////////////// Custom Ammo ////////////////////
/////////////////////////////////////////////////////
//---------------- Beams ----------------
/obj/projectile/beam/eluger
	name = "laser beam"
	icon_state = "xray"
	light_color = "#00FF00"
	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/imperial
	name = "laser beam"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon_state = "darkb"
	light_color = "#8837A3"
	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter

/obj/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	light_color = "#0000FF"
	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni
