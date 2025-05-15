/obj/item/gun/projectile/energy/ionrifle
	name = "ion rifle"
	desc = "The NT Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. Not the best of its type."
	icon_state = "ionrifle"
	item_state = "ionrifle"
	wielded_item_state = "ionrifle-wielded"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = WEIGHT_CLASS_BULKY
	damage_force = 10
	slot_flags = SLOT_BACK
	heavy = TRUE
	projectile_type = /obj/projectile/ion
	one_handed_penalty = 15
	worth_intrinsic = 500

/obj/item/gun/projectile/energy/ionrifle/emp_act(severity)
	..(max(severity, 4)) //so it doesn't EMP itself, I guess

/obj/item/gun/projectile/energy/ionrifle/pistol
	name = "ion pistol"
	desc = "The NT Mk63 EW Pan is a man portable anti-armor weapon designed to disable mechanical threats, produced by NT. This model sacrifices capacity for portability."
	icon_state = "ionpistol"
	item_state = null
	w_class = WEIGHT_CLASS_NORMAL
	damage_force = 5
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	heavy = FALSE
	charge_cost = 480
	projectile_type = /obj/projectile/ion/pistol

/obj/item/gun/projectile/energy/ionrifle/weak
	projectile_type = /obj/projectile/ion/small

/obj/item/gun/projectile/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	item_state = "decloner"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_POWER = 3)
	projectile_type = /obj/projectile/energy/declone

/obj/item/gun/projectile/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "floramut"
	projectile_type = /obj/projectile/energy/floramut
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	modifystate = "floramut"
	cell_type = /obj/item/cell/device/weapon/recharge
	no_pin_required = 1
	legacy_battery_lock = 1
	var/singleton/plantgene/gene = null

	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/projectile/energy/floramut, modifystate="floramut"),
		list(mode_name="increase yield", projectile_type=/obj/projectile/energy/florayield, modifystate="florayield"),
		list(mode_name="induce specific mutations", projectile_type=/obj/projectile/energy/floramut/gene, modifystate="floramut"),
		)

/obj/item/gun/projectile/energy/floragun/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	//allow shooting into adjacent hydrotrays regardless of intent
	if((clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		start_firing_cycle_async(user, get_centered_entity_tile_angle(user, target), NONE, null, target, new /datum/event_args/actor(user))
		return
	..()

/obj/item/gun/projectile/energy/floragun/verb/select_gene()
	set name = "Select Gene"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	var/genemask = input("Choose a gene to modify.") as null|anything in SSplants.plant_gene_datums

	if(!genemask)
		return

	gene = SSplants.plant_gene_datums[genemask]

	to_chat(usr, "<span class='info'>You set the [src]'s targeted genetic area to [genemask].</span>")

/obj/item/gun/projectile/energy/floragun/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()
	var/obj/projectile/energy/floramut/gene/G = .
	if(istype(G))
		G.gene = gene

/obj/item/gun/projectile/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	projectile_type = /obj/projectile/meteor
	cell_type = /obj/item/cell/potato
	charge_cost = 100
	self_recharge = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0
	one_handed_penalty = 20

/obj/item/gun/projectile/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = WEIGHT_CLASS_TINY
	heavy = FALSE
	slot_flags = SLOT_BELT
	one_handed_penalty = 0


/obj/item/gun/projectile/energy/mindflayer
	name = "mind flayer"
	desc = "A custom-built weapon of some kind."
	icon_state = "xray"
	projectile_type = /obj/projectile/beam/mindflayer
	one_handed_penalty = 15

/obj/item/gun/projectile/energy/toxgun
	name = "phoron pistol"
	desc = "A failed experiment in anti-personnel weaponry from the onset of the Syndicate Wars. The Mk.1 NT-P uses an internal resevoir of phoron gas, excited into a photonic state with a standard weapon cell, to fire lethal bolts of phoron-based plasma."
	icon_state = "toxgun"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	projectile_type = /obj/projectile/energy/phoron

/* Staves */

/obj/item/gun/projectile/energy/staff
	name = "staff of change"
	desc = "An artifact that spits bolts of coruscating energy which cause the target's very form to reshape itself."
	icon = 'icons/obj/wizard.dmi'
	item_icons = null
	icon_state = "staff"
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	charge_cost = 480
	projectile_type = /obj/projectile/change
	origin_tech = null
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	charge_meter = 0

/obj/item/gun/projectile/energy/staff/special_check(var/mob/user)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(usr, "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>")
		return 0

	return ..()

/obj/item/gun/projectile/energy/staff/default_click_empty(datum/gun_firing_cycle/cycle)
	// if this runtimes, too fucking bad
	var/mob/user = cycle.firing_actor.performer
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, /datum/soundbyte/sparks, 100, 1)

/*
/obj/item/gun/projectile/energy/staff/animate
	name = "staff of animation"
	desc = "An artifact that spits bolts of life force, which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/projectile/animate
	charge_cost = 240
*/
/obj/item/gun/projectile/energy/staff/focus
	name = "mental focus"
	desc = "An artifact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	slot_flags = SLOT_BACK
	projectile_type = /obj/projectile/forcebolt
	/*
	attack_self(mob/living/user as mob)
		if(projectile_type == "/obj/projectile/forcebolt")
			charge_cost = 400
			to_chat(user, "<span class='warning'>The [src.name] will now strike a small area.</span>")
			projectile_type = "/obj/projectile/forcebolt/strong"
		else
			charge_cost = 200
			to_chat(user, "<span class='warning'>The [src.name] will now strike only a single person.</span>")
			projectile_type = "/obj/projectile/forcebolt"
	*/

/datum/firemode/energy/dakkalaser
	burst_delay = 0.1 SECONDS

/datum/firemode/energy/dakkalaser/one
	name = "1-shot"
	burst_amount = 1
	legacy_direct_varedits = list(dispersion = list(0), charge_cost = 24)

/datum/firemode/energy/dakkalaser/five
	name = "5-burst"
	burst_amount = 5
	legacy_direct_varedits = list(burst_accuracy = list(75,75,75,75,75), dispersion = list(1,1,1,1,1))

/datum/firemode/energy/dakkalaser/ten
	name = "10-burst"
	burst_amount = 10
	legacy_direct_varedits = list(burst_accuracy = list(75,75,75,75,75,75,75,75,75,75), dispersion = list(2,2,2,2,2,2,2,2,2,2))

/obj/item/gun/projectile/energy/dakkalaser
	name = "suppression gun"
	desc = "Coined 'Sparkers' by Tyrmalin dissidents on Larona upon it's inception, the HI-LLG is an energy-based suppression system, used to overwhelm the opposition in a hail of laser blasts."
	icon_state = "dakkalaser"
	item_state = "dakkalaser"
	wielded_item_state = "dakkalaser-wielded"
	w_class = WEIGHT_CLASS_HUGE
	heavy = TRUE
	charge_cost = 24 // 100 shots, it's a spray and pray (to RNGesus) weapon.
	projectile_type = /obj/projectile/energy/blue_pellet
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	accuracy = 75 // Suppressive weapons don't work too well if there's no risk of being hit.
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 6, TECH_ILLEGAL = 6)
	one_handed_penalty = 60

	firemodes = list(
		/datum/firemode/energy/dakkalaser/one,
		/datum/firemode/energy/dakkalaser/five,
		/datum/firemode/energy/dakkalaser/ten,
	)

/obj/item/gun/projectile/energy/maghowitzer
	name = "portable MHD howitzer"
	desc = "A massive weapon designed to destroy fortifications with a stream of molten tungsten."
	description_fluff = "A weapon designed by joint cooperation of Nanotrasen, Hephaestus, and SCG scientists. Everything else is red tape and black highlighters."
	description_info = "This weapon requires a wind-up period before being able to fire. Clicking on a target will create a beam between you and its turf, starting the timer. Upon completion, it will fire at the designated location."
	icon_state = "mhdhowitzer"
	item_state = "mhdhowitzer"
	wielded_item_state = "mhdhowitzer-wielded"
	w_class = WEIGHT_CLASS_HUGE
	heavy = TRUE

	charge_cost = 10000 // Uses large cells, can at max have 3 shots.
	projectile_type = /obj/projectile/beam/tungsten
	cell_type = /obj/item/cell/high
	cell_system_legacy_use_device = FALSE

	accuracy = 75
	charge_meter = 0
	one_handed_penalty = 30

	var/power_cycle = FALSE

/obj/item/gun/projectile/energy/maghowitzer/proc/pick_random_target(var/turf/T)
	var/foundmob = FALSE
	var/foundmobs = list()
	for(var/mob/living/L in T.contents)
		foundmob = TRUE
		foundmobs += L
	if(foundmob)
		var/return_target = pick(foundmobs)
		return return_target
	return FALSE

/obj/item/gun/projectile/energy/maghowitzer/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/atom/A = target
	if(power_cycle)
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")
		return
	var/turf/target_turf = get_turf(A)
	var/beameffect = user.Beam(target_turf,icon_state="sat_beam",icon='icons/effects/beam.dmi',time=31, maxdistance=10,beam_type=/obj/effect/ebeam)
	if(beameffect)
		user.visible_message("<span class='cult'>[user] aims \the [src] at \the [A].</span>")
	if(obj_cell_slot.cell && obj_cell_slot.cell.charge >= charge_cost) //Do a delay for pointblanking too.
		power_cycle = TRUE
		if(do_after(user, 30))
			if(A.loc == target_turf)
				return ..()
			else
				var/rand_target = pick_random_target(target_turf)
				if(rand_target)
					return ..()
				else
					return ..()
		else
			if(beameffect)
				qdel(beameffect)
		power_cycle = FALSE
	else
		return ..()

/obj/item/gun/projectile/energy/maghowitzer/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(power_cycle)
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")
		return 0

	var/turf/target_turf = get_turf(target)

	var/beameffect = user.Beam(target_turf,icon_state="sat_beam",icon='icons/effects/beam.dmi',time=31, maxdistance=10,beam_type=/obj/effect/ebeam)

	if(beameffect)
		user.visible_message("<span class='cult'>[user] aims \the [src] at \the [target].</span>")

	if(!power_cycle)
		power_cycle = TRUE
		if(do_after(user, 30))
			if(target.loc == target_turf)
				return ..()
			else
				var/rand_target = pick_random_target(target_turf)
				// overwrite param in argument list, which is passed through ..() by default if not overridden.
				target = rand_target || target
				return ..()
		else
			if(beameffect)
				qdel(beameffect)
			var/datum/gun_firing_cycle/cycle = new
			cycle.firing_actor = new /datum/event_args/actor(user)
			post_empty_fire(cycle)
		power_cycle = FALSE
	else
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")

/obj/item/gun/projectile/energy/medigun //Adminspawn/ERT etc
	name = "directed restoration system"
	desc = "The BL-3 'Phoenix' is an adaptation on the ML-3 'Medbeam' design that channels the power of the beam into a single healing laser. It is highly energy-inefficient, but its medical power cannot be denied."
	damage_force = 5
	icon_state = "medbeam"
	item_state = "medbeam"
	icon = 'icons/obj/gun/energy.dmi'
	slot_flags = SLOT_BELT
	accuracy = 100
	firemodes = /datum/firemode/energy{
		cycle_cooldown = 1.2 SECONDS;
	}
	fire_sound = 'sound/weapons/eluger.ogg'

	projectile_type = /obj/projectile/beam/medigun

	cell_system_legacy_use_device = FALSE
	cell_type = /obj/item/cell/high
	charge_cost = 2500

/obj/item/gun/projectile/energy/puzzle_key
	name = "Key of Anak-Hun-Tamuun"
	desc = "An arcane stave that fires a powerful energy blast. Why was this just left laying around here?"
	fire_sound = 'sound/magic/staff_change.ogg'
	icon = 'icons/obj/gun/magic.dmi'
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	damage_force = 5
	charge_meter = 0
	firemodes = /datum/firemode/energy{
		projectile_type = /obj/projectile/beam/emitter;
		cycle_cooldown = 1 SECONDS;
		charge_cost = 2400 / 3;
	}
	cell_type = /obj/item/cell/device/weapon/recharge/captain
	legacy_battery_lock = 1
	one_handed_penalty = 0

/obj/item/gun/projectile/energy/ermitter
	name = "Ermitter rifle"
	desc = "A industrial energy projector turned into a crude, portable weapon - the Tyrmalin answer to armored hardsuits used by pirates. What it lacks in precision, it makes up for in firepower. The 'Ermitter' rifle cell receptacle has been heavily modified."
	icon_state = "ermitter_gun"
	item_state = "pulse"
	projectile_type = /obj/projectile/beam/emitter
	firemodes = /datum/firemode/energy{
		cycle_cooldown = 2 SECONDS;
	}
	charge_cost = 900
	cell_type = /obj/item/cell
	cell_system_legacy_use_device = FALSE
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	one_handed_penalty = 50

/obj/item/gun/projectile/energy/ionrifle/pistol/tyrmalin
	name = "botbuster pistol"
	desc = "These jury-rigged pistols are sometimes fielded by Tyrmalin facing synthetic pirates or malfunctioning machinery. Capable of discharging a single ionized bolt before needing to recharge, they're often treated as holdout or ambush weapons."
	icon_state = "botbuster"
	charge_cost = 1300
	projectile_type = /obj/projectile/ion/pistol

/obj/item/gun/projectile/energy/jezzail
	name = "Microfission Jezzail"
	desc = "Deceptively primitive in appearance, this finely tuned rifle uses an onboard reactor to stimulate the growth of an anomalous crystal. Fragments of this crystal are utilized as ammunition by the weapon."
	icon_state = "warplockgun"
	item_state = "huntrifle"
	firemodes = /datum/firemode/energy{
		projectile_type = /obj/projectile/bullet/cyanideround/jezzail;
		cycle_cooldown = 2 SECONDS;
		charge_cost = 2400 / 4;
	}
	cell_type = /obj/item/cell/device/weapon
	legacy_battery_lock = 1
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	one_handed_penalty = 60

// todo: nuke plasma weapons from orbit and rework
/datum/firemode/energy/plasma
	cycle_cooldown = 2 SECONDS

/datum/firemode/energy/plasma/normal
	name = "standard"
	legacy_direct_varedits = list(projectile_type=/obj/projectile/plasma, charge_cost = 350)

/datum/firemode/energy/plasma/high
	name = "high power"
	legacy_direct_varedits = list(projectile_type=/obj/projectile/plasma/hot, charge_cost = 370)

//Plasma Guns Plasma Guns!
/obj/item/gun/projectile/energy/plasma
	name = "\improper Balrog plasma rifle"
	desc = "This bulky weapon, the experimental NT-PLR-EX 'Balrog', fires magnetically contained balls of plasma at high velocity. Due to the volatility of the round, the weapon is known to overheat and fail catastrophically if fired too frequently."
	icon_state = "prifle"
	item_state = null
	projectile_type = /obj/projectile/plasma
	charge_cost = 400
	cell_type = /obj/item/cell/device/weapon
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	origin_tech = list(TECH_COMBAT = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 2000)
	one_handed_penalty = 50
	var/overheating = 0

	firemodes = list(
		/datum/firemode/energy/plasma/normal,
		/datum/firemode/energy/plasma/high,
	)

/obj/item/gun/projectile/energy/plasma/update_icon_state()
	icon_state = "[initial(icon_state)][overheating ? "_overheat" : ""]"
	return ..()

/obj/item/gun/projectile/energy/plasma/pistol
	name = "\improper Wyrm plasma pistol"
	desc = "This scaled down NT-PLP-EX 'Wyrm' plasma pistol fires magnetically contained balls of plasma at high velocity. Due to the volatility of the round, the weapon is known to overheat and fail catastrophically if fired too frequently."
	icon_state = "ppistol"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = WEIGHT_CLASS_NORMAL
	heavy = FALSE
	damage_force = 5
	origin_tech = list(TECH_COMBAT = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 8000, MAT_GLASS = 2000)
	one_handed_penalty = 10
