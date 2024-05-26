
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
	cell_initial = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	charge_meter = 0

/obj/item/gun/projectile/energy/staff/special_check(var/mob/user)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(usr, "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>")
		return 0

	return ..()

/obj/item/gun/projectile/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)
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

/obj/item/gun/projectile/energy/dakkalaser
	name = "suppression gun"
	desc = "Coined 'Sparkers' by Tyrmalin dissidents on Larona upon it's inception, the HI-LLG is an energy-based suppression system, used to overwhelm the opposition in a hail of laser blasts."
	icon_state = "dakkalaser"
	item_state = "dakkalaser"
	wielded_item_state = "dakkalaser-wielded"
	w_class = ITEMSIZE_HUGE
	heavy = TRUE
	charge_cost = 24 // 100 shots, it's a spray and pray (to RNGesus) weapon.
	projectile_type = /obj/projectile/energy/blue_pellet
	cell_initial = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	accuracy = 75 // Suppressive weapons don't work too well if there's no risk of being hit.
	burst_delay = 1 // Burst faster than average.
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 6, TECH_ILLEGAL = 6)
	one_handed_penalty = 60

	firemodes = list(
		list(mode_name="single shot", burst = 1, burst_accuracy = list(75), dispersion = list(0), charge_cost = 24),
		list(mode_name="five shot burst", burst = 5, burst_accuracy = list(75,75,75,75,75), dispersion = list(1,1,1,1,1)),
		list(mode_name="ten shot burst", burst = 10, burst_accuracy = list(75,75,75,75,75,75,75,75,75,75), dispersion = list(2,2,2,2,2,2,2,2,2,2)),
		)

/obj/item/gun/projectile/energy/maghowitzer
	name = "portable MHD howitzer"
	desc = "A massive weapon designed to destroy fortifications with a stream of molten tungsten."
	description_fluff = "A weapon designed by joint cooperation of Nanotrasen, Hephaestus, and SCG scientists. Everything else is red tape and black highlighters."
	description_info = "This weapon requires a wind-up period before being able to fire. Clicking on a target will create a beam between you and its turf, starting the timer. Upon completion, it will fire at the designated location."
	icon_state = "mhdhowitzer"
	item_state = "mhdhowitzer"
	wielded_item_state = "mhdhowitzer-wielded"
	w_class = ITEMSIZE_HUGE
	heavy = TRUE

	charge_cost = 10000 // Uses large cells, can at max have 3 shots.
	projectile_type = /obj/projectile/beam/tungsten
	cell_initial = /obj/item/cell/high
	accept_cell_initial = /obj/item/cell

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

/obj/item/gun/projectile/energy/maghowitzer/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/atom/A = target
	if(power_cycle)
		to_chat(user, "<span class='notice'>\The [src] is already powering up!</span>")
		return
	var/turf/target_turf = get_turf(A)
	var/beameffect = user.Beam(target_turf,icon_state="sat_beam",icon='icons/effects/beam.dmi',time=31, maxdistance=10,beam_type=/obj/effect/ebeam)
	if(beameffect)
		user.visible_message("<span class='cult'>[user] aims \the [src] at \the [A].</span>")
	if(power_supply && power_supply.charge >= charge_cost) //Do a delay for pointblanking too.
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
			handle_click_empty(user)
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
	fire_delay = 12
	fire_sound = 'sound/weapons/eluger.ogg'

	projectile_type = /obj/projectile/beam/medigun

	accept_cell_initial = /obj/item/cell
	cell_initial = /obj/item/cell/high
	charge_cost = 2500

/datum/firemode/energy/puzzle_key
	projectile_type = /obj/projectile/beam/emitter
	charge_cost = 800
	fire_delay = 1 SECONDS

/obj/item/gun/projectile/energy/puzzle_key
	name = "Key of Anak-Hun-Tamuun"
	desc = "An arcane stave that fires a powerful energy blast. Why was this just left laying around here?"
	fire_sound = 'sound/magic/staff_change.ogg'
	icon = 'icons/obj/gun/magic.dmi'
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	damage_force = 5
	charge_meter = 0
	firemodes = list(/datum/firemode/energy/puzzle_key)
	cell_initial = /obj/item/cell/device/weapon/recharge/captain
	battery_lock = 1
	one_handed_penalty = 0

/obj/item/gun/projectile/energy/jezzail
	name = "Microfission Jezzail"
	desc = "Deceptively primitive in appearance, this finely tuned rifle uses an onboard reactor to stimulate the growth of an anomalous crystal. Fragments of this crystal are utilized as ammunition by the weapon."
	icon_state = "warplockgun"
	item_state = "huntrifle"
	projectile_type = /obj/projectile/bullet/cyanideround/jezzail
	fire_delay = 20
	charge_cost = 600
	cell_initial = /obj/item/cell/device/weapon
	battery_lock = 1
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	one_handed_penalty = 60
