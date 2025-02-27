// For general use
/obj/item/gun/projectile/ballistic/automatic/battlerifle
	name = "\improper JSDF service rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I have brought this motivational device! Uses 9.5x40mm rounds."
	icon_state = "battlerifle"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "battlerifle_i"
	item_icons = null
	w_class = WEIGHT_CLASS_BULKY
	recoil = 1.5 // The battlerifle was known for its nasty recoil.
	caliber = /datum/ammo_caliber/a9_5mm
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	magazine_preload = /obj/item/ammo_magazine/m95
	magazine_restrict = /obj/item/ammo_magazine/m95
	fire_sound = 'sound/weapons/battlerifle.ogg'
	slot_flags = SLOT_BACK
	one_handed_penalty = 60 // The weapon itself is heavy

/obj/item/gun/projectile/ballistic/automatic/battlerifle/update_icon()
	. = ..()
	update_worn_icon()

// todo: new render system
/obj/item/gun/projectile/ballistic/automatic/battlerifle/update_icon_state()
	. = ..()
	icon_state = magazine? "battlerifle" : "battlerifle_empty"

// For general use
/obj/item/gun/projectile/ballistic/shotgun/pump/JSDF
	name = "\improper JSDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun/ballistic.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	internal_magazine_size = 12
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g

// For general use
/obj/item/gun/projectile/ballistic/automatic/pdw
	name = "personal defense weapon"
	desc = "The X-9MM is a select-fire personal defense weapon designed in-house by Xing Private Security. It was made to compete with the WT550 Saber, but never caught on with Nanotrasen. Uses 9mm rounds."
	icon_state = "pdw"
	item_state = "c20r" // Placeholder
	w_class = WEIGHT_CLASS_NORMAL
	caliber = /datum/ammo_caliber/a9mm
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	magazine_preload = /obj/item/ammo_magazine/a9mm/large
	magazine_restrict = /obj/item/ammo_magazine/a9mm

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30), dispersion=list(0.0, 0.6, 0.6))
		)

/obj/item/gun/projectile/ballistic/automatic/pdw/update_icon()
	. = ..()
	update_worn_icon()

/obj/item/gun/projectile/ballistic/automatic/pdw/update_icon_state()
	. = ..()
	if(istype(magazine, /obj/item/ammo_magazine/a9mm))
		icon_state = "pdw-short"
	else
		icon_state = magazine? "pdw" : "pdw-empty"

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
	w_class = WEIGHT_CLASS_NORMAL
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000)
	projectile_type = /obj/projectile/beam/imperial

// For general use
/obj/item/gun/projectile/ballistic/automatic/stg
	name = "\improper Sturmgewehr"
	desc = "An STG-560 built by RauMauser. Experience the terror of the Siegfried line, redone for the 26th century! The Kaiser would be proud. Uses unique 7.92x33mm Kurz rounds."
	icon_state = "stg60"
	item_state = "arifle"
	w_class = WEIGHT_CLASS_BULKY
	caliber = /datum/ammo_caliber/a7_92mm
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 6)
	magazine_preload = /obj/item/ammo_magazine/a7_92mm
	magazine_restrict = /obj/item/ammo_magazine/a7_92mm

/obj/item/gun/projectile/ballistic/automatic/stg/update_icon()
	. = ..()
	update_worn_icon()

/obj/item/gun/projectile/ballistic/automatic/stg/update_icon_state()
	. = ..()
	icon_state = magazine? "stg60" : "stg60-e"
	item_state = magazine? "arifle" : "arifle-e"

/datum/firemode/energy/eluger
	cycle_cooldown = 0.4 SECONDS

/datum/firemode/energy/eluger/stun
	name = "stun"
	legacy_direct_varedits = list(charge_cost=120,projectile_type=/obj/projectile/beam/stun, modifystate="elugerstun", fire_sound='sound/weapons/Taser.ogg')

/datum/firemode/energy/eluger/lethal
	name = "lethal"
	legacy_direct_varedits = list(charge_cost=240,projectile_type=/obj/projectile/beam/eluger, modifystate="elugerkill", fire_sound='sound/weapons/eluger.ogg')

// ------------ Energy Luger ------------
/obj/item/gun/projectile/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser. Although its battery cannot be removed, its ergonomic design makes it easy to shoot, allowing for rapid follow-up shots. It also has the ability to toggle between stun and kill."
	icon_state = "elugerstun100"
	item_state = "gun"
	legacy_battery_lock = 1 // In exchange for balance, you cannot remove the battery. Also there's no sprite for that and I fucking suck at sprites. -Ace
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	modifystate = "elugerstun"
	fire_sound = 'sound/weapons/Taser.ogg'
	firemodes = list(
		/datum/firemode/energy/eluger/stun,
		/datum/firemode/energy/eluger/lethal,
	)

//Civilian gun
/obj/item/gun/projectile/ballistic/giskard
	name = "\improper \"Giskard\" holdout pistol"
	desc = "The FS HG .380 \"Giskard\" can even fit into the pocket! Uses .380 rounds."
	icon_state = "giskardcivil"
	caliber = /datum/ammo_caliber/a38
	magazine_preload = /obj/item/ammo_magazine/a38
	magazine_restrict = /obj/item/ammo_magazine/a38
	w_class = WEIGHT_CLASS_SMALL
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/obj/item/gun/projectile/ballistic/giskard/update_icon_state()
	. = ..()
	if(magazine && magazine.get_amount_remaining())
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
	if(magazine && magazine.get_amount_remaining())
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"

//Detective gun
/obj/item/gun/projectile/ballistic/revolver/consul
	name = "\improper \"Consul\" Revolver"
	desc = "Are you feeling lucky, punk? Uses .44 rounds."
	icon_state = "inspector"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/a44
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44/rubber
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)

/obj/item/gun/projectile/ballistic/revolver/consul/update_overlays()
	. = ..()
	if(get_ammo_remaining())
		. += "inspector_off"
	else
		. += "inspector_on"

/datum/firemode/sol_smg
	burst_delay = 0.2 SECONDS

/datum/firemode/sol_smg/one
	name = "semi-automatic"
	burst_amount = 1
	legacy_direct_varedits = list()

/datum/firemode/sol_smg/three
	name = "3-round bursts"
	burst_amount = 3

// No idea what this is for.
/obj/item/gun/projectile/ballistic/automatic/sol
	name = "\improper \"Sol\" SMG"
	desc = "The FS 9x19mm \"Sol\" is a compact and reliable submachine gun. Uses 9mm rounds."
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BELT
	caliber = /datum/ammo_caliber/a9mm
	magazine_preload = /obj/item/ammo_magazine/a9mm
	magazine_restrict = /obj/item/ammo_magazine/a9mm
	multi_aim = 1
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	firemodes = list(
		/datum/firemode/sol_smg/one,
		/datum/firemode/sol_smg/three,
	)
	burst_accuracy=list(0,-15,-15)
	dispersion=list(0.0, 0.6, 1.0)

/obj/item/gun/projectile/ballistic/automatic/sol/proc/update_charge()
	if(!magazine)
		return
	var/ratio = magazine.get_amount_remaining() / magazine.ammo_max
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	add_overlay("smg_[ratio]")

/obj/item/gun/projectile/ballistic/automatic/sol/update_icon()
	icon_state = magazine? "SMG-IS" : "SMG-IS-empty"
	cut_overlay()
	update_charge()

//HoP gun
/obj/item/gun/projectile/energy/gun/martin
	name = "holdout energy gun"
	desc = "The FS PDW E \"Martin\" is small holdout e-gun. Don't miss!"
	icon_state = "PDW"
	item_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
	projectile_type = /obj/projectile/beam/stun
	charge_cost = 1200
	charge_meter = 0
	modifystate = null
	legacy_battery_lock = 1
	fire_sound = 'sound/weapons/Taser.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', charge_cost = 600),
		list(mode_name="lethal", projectile_type=/obj/projectile/beam, fire_sound='sound/weapons/Laser.ogg', charge_cost = 1200),
		)

/obj/item/gun/projectile/energy/gun/martin/update_overlays()
	. = ..()
	switch(firemode.name)
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
	legacy_muzzle_type = /obj/effect/projectile/muzzle/xray
	legacy_tracer_type = /obj/effect/projectile/tracer/xray
	legacy_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/imperial
	name = "laser beam"
	fire_sound = 'sound/weapons/mandalorian.ogg'
	icon_state = "darkb"
	light_color = "#8837A3"
	legacy_muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	legacy_tracer_type = /obj/effect/projectile/tracer/darkmatter
	legacy_impact_type = /obj/effect/projectile/impact/darkmatter

/obj/projectile/beam/stun/kin21
	name = "kinh21 stun beam"
	icon_state = "omnilaser"
	light_color = "#0000FF"
	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
	legacy_impact_type = /obj/effect/projectile/impact/laser_omni
