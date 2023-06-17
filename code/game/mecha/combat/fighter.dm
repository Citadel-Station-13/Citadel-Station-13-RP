#define NOGRAV_FIGHTER_DAMAGE 20

/obj/mecha/combat/fighter
	name = "Delete me, nerd!!"
	desc = "The base type of fightercraft. Don't spawn this one!"

	var/datum/effect_system/ion_trail_follow/ion_trail
	var/landing_gear_raised = FALSE //If our anti-space-drift is on
	var/ground_capable = FALSE //If we can fly over normal turfs and not just space

	icon = 'icons/mecha/fighters64x64.dmi' //See ATTRIBUTIONS.md for details on license

	icon_state = ""
	initial_icon = ""

	dir_in = null //Don't reset direction when empty

	step_in = 2 //Fast

	integrity = 400
	integrity_max = 400

	infra_luminosity = 6

	opacity = FALSE

	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	stomp_sound = 'sound/mecha/fighter/engine_mid_fighter_move.ogg'
	swivel_sound = 'sound/mecha/fighter/engine_mid_boost_01.ogg'

	bound_height = 64
	bound_width = 64

	max_hull_equip = 2
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 1
	max_special_equip = 1

/obj/mecha/combat/fighter/Initialize(mapload)
	. = ..()
	ion_trail = new /datum/effect_system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.stop()

/obj/mecha/combat/fighter/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000

/obj/mecha/combat/fighter/moved_inside(var/mob/living/carbon/human/H)
	. = ..()
	consider_gravity()

/obj/mecha/combat/fighter/go_out()
	. = ..()
	consider_gravity()

//We don't get lost quite as easy.
/obj/mecha/combat/fighter/touch_map_edge()
	//No overmap enabled or no driver to choose
	if(!(LEGACY_MAP_DATUM).use_overmap || !occupant || !can_ztravel())
		return ..()

	var/obj/effect/overmap/visitable/our_ship = get_overmap_sector(z)

	//We're not on the overmap
	if(!our_ship)
		return ..()

	//Stored for safety checking after user input
	var/this_x = x
	var/this_y = y
	var/this_z = z
	var/this_occupant = occupant

	var/what_edge

	var/new_x
	var/new_y
	var/new_z

	if(x <= TRANSITIONEDGE)
		what_edge = WEST
		new_x = world.maxx - TRANSITIONEDGE - 2
		new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (x >= (world.maxx - TRANSITIONEDGE + 1))
		what_edge = EAST
		new_x = TRANSITIONEDGE + 1
		new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (y <= TRANSITIONEDGE)
		what_edge = SOUTH
		new_y = world.maxy - TRANSITIONEDGE -2
		new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	else if (y >= (world.maxy - TRANSITIONEDGE + 1))
		what_edge = NORTH
		new_y = TRANSITIONEDGE + 1
		new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	var/list/choices = list()
	for(var/obj/effect/overmap/visitable/V in range(1, our_ship))
		choices[V.name] = V

	var/choice = input("Choose an overmap destination:", "Destination", null) as null|anything in choices
	if(!choice)
		var/backwards = turn(what_edge, 180)
		forceMove(get_step(src,backwards)) //Move them back a step, then.
		setDir(backwards)
		return
	else
		var/obj/effect/overmap/visitable/V = choices[choice]
		if(occupant != this_occupant || this_x != x || this_y != y || this_z != z || get_dist(V,our_ship) > 1) //Sanity after user input
			to_chat(occupant, "<span class='warning'>You or they appear to have moved!</span>")
			return
		var/list/levels = V.get_space_zlevels()
		if(!levels.len)
			to_chat(occupant, "<span class='warning'>You don't appear to be able to get there from here!</span>")
			return
		new_z = pick(levels)
	var/turf/destination = locate(new_x, new_y, new_z)
	if(!destination || destination.density)
		to_chat(occupant, "<span class='warning'>You don't appear to be able to get there from here! Is it blocked?</span>")
		return
	else
		forceMove(destination)

//Modified phazon code
/obj/mecha/combat/fighter/Topic(href, href_list)
	..()
	if (href_list["toggle_landing_gear"])
		landing_gear_raised = !landing_gear_raised
		send_byjax(src.occupant,"exosuit.browser","landing_gear_command","[landing_gear_raised?"Lower":"Raise"] landing gear")
		src.occupant_message("<span class='notice'>Landing gear [landing_gear_raised? "raised" : "lowered"].</span>")
		return

/obj/mecha/combat/fighter/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_landing_gear=1'><span id="landing_gear_command">[landing_gear_raised?"Raise":"Lower"] landing gear</span></a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/fighter/can_ztravel()
	return (landing_gear_raised && has_charge(step_energy_drain))

// No space drifting
// This doesnt work but I actually dont want it to anyways, so I'm not touching it at all. Space drifting is cool.
/obj/mecha/combat/fighter/check_for_support()
	if (landing_gear_raised)
		return 1

	return ..()

// No falling if we've got our boosters on
/obj/mecha/combat/fighter/can_fall()
	if(landing_gear_raised && has_charge(step_energy_drain))
		return FALSE
	else
		return TRUE


/obj/mecha/combat/fighter/proc/consider_gravity(var/moved = FALSE)
	var/gravity = has_gravity()
	if (gravity && !landing_gear_raised)
		playsound(src, 'sound/effects/roll.ogg', 50, 1)
	else if(gravity && ground_capable && occupant)
		start_hover()
	else if((!gravity && ground_capable) || !occupant)
		stop_hover()
	else if(moved && gravity && !ground_capable)
		occupant_message("Collision alert! Vehicle not rated for use in gravity!")
		take_damage_legacy(NOGRAV_FIGHTER_DAMAGE, "brute")
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)

/obj/mecha/combat/fighter/get_step_delay()
    . = ..()
    if(has_gravity() && !landing_gear_raised)
        . += 4

/obj/mecha/combat/fighter/handle_equipment_movement()
	. = ..()
	consider_gravity(TRUE)

/obj/mecha/combat/fighter/proc/start_hover()
	if(!ion_trail.on) //We'll just use this to store if we're floating or not
		ion_trail.start()
		var/amplitude = 2 //maximum displacement from original position
		var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

		var/top = get_standard_pixel_y_offset() + amplitude
		var/bottom = get_standard_pixel_y_offset() - amplitude
		var/half_period = period / 2
		var/quarter_period = period / 4

		animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
		animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
		animate(pixel_y = get_standard_pixel_y_offset(), time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/obj/mecha/combat/fighter/proc/stop_hover()
	if(ion_trail.on)
		ion_trail.stop()
		animate(src, pixel_y = get_standard_pixel_y_offset(), time = 5, easing = SINE_EASING | EASE_IN) //halt animation

/obj/mecha/combat/fighter/check_for_support()
	if (has_charge(step_energy_drain) && landing_gear_raised)
		return 1

	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille) in things || locate(/obj/structure/lattice) in things || locate(/turf/simulated) in things || locate(/turf/unsimulated) in things)
		return 1
	else
		return 0


/obj/mecha/combat/fighter/play_entered_noise(var/mob/who)
	if(hasInternalDamage())
		who << sound('sound/mecha/fighter_entered_bad.ogg',volume=50)
	else
		who << sound('sound/mecha/fighter_entered.ogg',volume=50)

//causes damage when running into objects
/obj/mecha/combat/fighter/Bump(atom/obstacle)
	. = ..()
	// this isn't defined becuase this is shitcode anyways and i'm just patching it
	// todo: why the fuck are you guys doing snowflake collision code??
	if(TIMER_COOLDOWN_CHECK(src, "fighter_collision"))
		return
	if(istype(obstacle, /obj) || istype(obstacle, /turf))
		TIMER_COOLDOWN_START(src, "fighter_collision", 5 SECONDS)
		occupant_message("<B><FONT COLOR=red SIZE=+1>Collision Alert!</B></FONT>")
		take_damage_legacy(20, "brute")
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)

////////////// Gunpod //////////////

/obj/mecha/combat/fighter/gunpod
	name = "\improper Gunpod"
	desc = "Small mounted weapons platform capable of space and surface combat. More like a flying tank than a dedicated fightercraft."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "gunpod"
	initial_icon = "gunpod"

	catalogue_data = list(/datum/category_item/catalogue/technology/gunpod)
	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	step_in = 3 //Slightly slower than others

	ground_capable = TRUE

	// Paint colors! Null if not set.
	var/stripe1_color
	var/stripe2_color
	var/image/stripe1_overlay
	var/image/stripe2_overlay

/obj/mecha/combat/fighter/gunpod/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/mecha/combat/fighter/gunpod/recon
	name = "\improper Reconnaissance Gunpod"
	desc = "Small mounted weapons platform capable of space and surface combat. More like a flying tank than a dedicated fightercraft. This stripped down model is used for long range reconnaissance ."

/obj/mecha/combat/fighter/gunpod/recon/Initialize(mapload) //Blinky
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)

/obj/mecha/combat/fighter/gunpod/update_icon()
	cut_overlays()
	..()

	if(stripe1_color)
		stripe1_overlay = image("gunpod_stripes1")
		stripe1_overlay.color = stripe1_color
		add_overlay(stripe1_overlay)
	if(stripe2_color)
		stripe2_overlay = image("gunpod_stripes2")
		stripe2_overlay.color = stripe2_color
		add_overlay(stripe2_overlay)

/obj/mecha/combat/fighter/gunpod/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool) && state == 1)
		var/new_paint_location = input("Please select a target zone.", "Paint Zone", null) as null|anything in list("Fore Stripe", "Aft Stripe", "CANCEL")
		if(new_paint_location && new_paint_location != "CANCEL")
			var/new_paint_color = input("Please select a paint color.", "Paint Color", null) as color|null
			if(new_paint_color)
				switch(new_paint_location)
					if("Fore Stripe")
						stripe1_color = new_paint_color
					if("Aft Stripe")
						stripe2_color = new_paint_color

		update_icon()
	else ..()

/obj/effect/decal/mecha_wreckage/gunpod
	name = "Gunpod wreckage"
	desc = "Remains of some unfortunate gunpod. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "gunpod-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/gunpod
	name = "Voidcraft - Gunpod"
	desc = "This is a small space-capable fightercraft that has an arrowhead design. Can hold up to one pilot, \
	and sometimes one or two passengers, with the right modifications made. \
	Typically used as small fighter craft, the gunpod can't carry much of a payload, though it's still capable of holding it's own."
	value = CATALOGUER_REWARD_MEDIUM


////////////// Baron //////////////

/obj/mecha/combat/fighter/baron
	name = "\improper Baron"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron"
	initial_icon = "baron"

	catalogue_data = list(/datum/category_item/catalogue/technology/baron)
	wreckage = /obj/effect/decal/mecha_wreckage/baron

	ground_capable = FALSE

/obj/mecha/combat/fighter/baron/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/omni_shield
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/baron
	name = "Baron wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron-broken"
	bound_width = 64
	bound_height = 64

/obj/mecha/combat/fighter/baron/sec
	name = "\improper Baron-SV"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations. The Baron-SV (Security Variant) is frequently used by NT Security forces during EVA patrols."

/obj/mecha/combat/fighter/baron/sec/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/phase
	ME.attach(src)

/datum/category_item/catalogue/technology/baron
	name = "Voidcraft - Baron"
	desc = "This is a small space fightercraft that has an arrowhead design. Can hold up to one pilot. \
	Unlike some fighters, this one is not designed for atmospheric operation, and is only capable of performing \
	maneuvers in the vacuum of space. Attempting flight while in an atmosphere is not recommended."
	value = CATALOGUER_REWARD_MEDIUM


////////////// Duke //////////////

/obj/mecha/combat/fighter/duke
	name = "\improper Duke"
	desc = "The Duke Heavy Fighter is designed and manufactured by Hephaestus Industries as a bulky craft built to punch above its weight. This one comes painted in Nanotrasen's blue white and black color scheme straight out of the fabricator, catering to security team's need for friendly identification. It makes up for the minimal hull upgrade space with a stronger chassis, and multiple mounting points for missiles, bombs, and lasers. It's incapable of Atmospheric flight."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke"
	initial_icon = "duke"

	step_in = 3 //slightly slower than a baron (this shit doesnt actually work atm, likely due to the whole equipment weight nonsense)

	health = 800
	maxhealth = 800 //double baron HP, only room for one defensive upgrade. No specials(cloaking, speed, ect) or universals.

	max_hull_equip = 1
	max_weapon_equip = 4
	max_utility_equip = 2
	max_universal_equip = 0
	max_special_equip = 0

	catalogue_data = list(/datum/category_item/catalogue/technology/duke)
	wreckage = /obj/effect/decal/mecha_wreckage/duke

	ground_capable = FALSE

/obj/mecha/combat/fighter/duke/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/mecha/combat/fighter/duke/db
	name = "\improper Duke \"Deep Blue\""
	desc = "A Duke heavy fighter decorated with the common 'Deep Blue' customization kit, both designed and sold by Hephaestus Industries. This paint scheme pays homage to one of the first supercomputing systems that dared to push the boundaries of what it meant to think. Think 40 steps ahead of your enemy with these colorations, just as Deep Blue did so many years ago."
	icon_state = "duke_db"
	initial_icon = "duke_db"
	wreckage = /obj/effect/decal/mecha_wreckage/duke/db

/obj/mecha/combat/fighter/duke/db/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/mecha/combat/fighter/duke/cw
	name = "\improper Duke \"Clockwork\""
	desc = "A Duke heavy fighter decorated with the rare 'Clockwork' customization kit, both designed and sold by Hephaestus Industries. Textured paint with accurate colorations and reflectiveness to brass makes this Duke Heavy Fighter stand out amongst the competition in any conflict."
	icon_state = "duke_cw"
	initial_icon = "duke_cw"
	wreckage = /obj/effect/decal/mecha_wreckage/duke/cw

/obj/mecha/combat/fighter/duke/cw/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/duke
	name = "Duke wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke-broken"
	bound_width = 64
	bound_height = 64

/obj/effect/decal/mecha_wreckage/duke/db
	name = "Duke wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke_db-broken"
	bound_width = 64
	bound_height = 64

/obj/effect/decal/mecha_wreckage/duke/cw
	name = "Duke wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke_cw-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/duke
	name = "Voidcraft - Duke"
	desc = "The Duke Heavy Fighter is designed and manufactured by Hephaestus Industries as a bulky craft built to punch above its weight. Primarily armed with missiles, bombs, or similar large payloads, this fighter packs a punch against most at the cost of room for minimul hull modifications, which is almost always reserved for much-needed armor inserts instead of a shield. It's incapable of atmospheric flight."
	value = CATALOGUER_REWARD_MEDIUM


////////////// Scoralis //////////////

/obj/mecha/combat/fighter/scoralis
	name = "\improper Scoralis"
	desc = "An imported space fighter with integral cloaking device. Beware the power consumption, though. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "scoralis"
	initial_icon = "scoralis"

	catalogue_data = list(/datum/category_item/catalogue/technology/scoralis)
	wreckage = /obj/effect/decal/mecha_wreckage/scoralis

	ground_capable = FALSE

/obj/mecha/combat/fighter/scoralis/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/cloak
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/scoralis
	name = "scoralis wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "scoralis-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/scoralis
	name = "Voidcraft - Scoralis"
	desc = "An import model fightercraft, this one contains an integral cloaking device that renders the fighter invisible \
	to the naked eye. Still detectable on thermal sensors, the craft can maneuver in close to ill-equipped foes and strike unseen. \
	Not rated for atmospheric travel, this craft excels at hit and run tactics, as it will likely need to recharge batteries between each 'hit'."
	value = CATALOGUER_REWARD_MEDIUM

////////////// Allure //////////////

/obj/mecha/combat/fighter/allure
	name = "\improper Allure"
	desc = "A fighter of Skrellian design. Its angular shape and wide overhead cross-section is made up for by it's stout armor and carefully crafted hull paint."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure"
	initial_icon = "allure"

	catalogue_data = list(/datum/category_item/catalogue/technology/allure)
	wreckage = /obj/effect/decal/mecha_wreckage/allure

	ground_capable = FALSE

	integrity = 500
	integrity_max = 500

/obj/mecha/combat/fighter/allure/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/cloak
	ME.attach(src)

/obj/mecha/combat/fighter/allure/royalty
	name = "\improper Allure \"Royalty\""
	desc = "A limited edition purple design with gold inlay that embodies the same colorations and pattern designs of royalty skrellian during the time of the Allure's initial release."
	icon_state = "allure_royalty"
	initial_icon = "allure_royalty"
	wreckage = /obj/effect/decal/mecha_wreckage/allure/royalty

/obj/mecha/combat/fighter/allure/royalty/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/cloak
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/allure
	name = "allure wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure-broken"
	bound_width = 64
	bound_height = 64

/obj/effect/decal/mecha_wreckage/allure/royalty
	icon_state = "allure_royalty-broken"

/datum/category_item/catalogue/technology/allure
	name = "Voidcraft - Allure"
	desc = "A space superiority fighter of Skrellian design. Its angular shape and wide overhead cross-section is made up for by it's stout armor and carefully crafted hull paint. \
	Import craft like this one often ship with no weapons, though the Skrell saw fit to integrate a cloaking device."
	value = CATALOGUER_REWARD_MEDIUM

////////////// Pinnace //////////////

/obj/mecha/combat/fighter/pinnace
	name = "\improper Pinnace"
	desc = "A cramped ship's boat, capable of atmospheric and space flight. Not capable of mounting traditional weapons. Capable of fitting one pilot and one passenger."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace"
	initial_icon = "pinnace"

	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 1
	max_universal_equip = 0
	max_special_equip = 1

	catalogue_data = list(/datum/category_item/catalogue/technology/pinnace)
	wreckage = /obj/effect/decal/mecha_wreckage/pinnace

	ground_capable = TRUE

/obj/mecha/combat/fighter/pinnace/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/pinnace
	name = "pinnace wreckage"
	desc = "Remains of some unfortunate ship's boat. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/pinnace
	name = "Voidcraft - Pinnace"
	desc = "A very small boat, usually used as a tender at very close ranges. The lack of a bluespace \
	drive means that it can't get too far from it's parent ship. Though the pinnace is typically unarmed, \
	it is capable of atmospheric flight and escaping most pursuing fighters by diving into the atmosphere of \
	nearby planets to seek cover."
	value = CATALOGUER_REWARD_MEDIUM


////////////// Cludge //////////////

/obj/mecha/combat/fighter/cludge
	name = "\improper Cludge"
	desc = "A heater, nozzle, and fuel tank strapped together. There are exposed wires strewn about it."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "cludge"
	initial_icon = "cludge"

	integrity = 100
	integrity_max = 100

	max_hull_equip = 0
	max_weapon_equip = 0
	max_utility_equip = 0
	max_universal_equip = 0
	max_special_equip = 0

	catalogue_data = list(/datum/category_item/catalogue/technology/cludge)
	wreckage = /obj/effect/decal/mecha_wreckage/cludge

	ground_capable = TRUE

/obj/effect/decal/mecha_wreckage/cludge
	name = "Cludge wreckage"
	desc = "It doesn't look much different than it normally does. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "cludge-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/cludge
	name = "Voidcraft - Cludge"
	desc = "A collection of parts strapped together in an attempt to make a flying vessel. Such vessels are fragile, unstable \
	and very easily break apart, due to their roughshod engineering. These vessels commonly are built without critical components \
	such as life support, or armor plating."
	value = CATALOGUER_REWARD_MEDIUM

#undef NOGRAV_FIGHTER_DAMAGE
