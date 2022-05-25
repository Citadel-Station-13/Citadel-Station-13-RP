/obj/item/material/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterflyknife"
	item_state = null
	hitsound = null
	var/active = 0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("patted", "tapped")
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'

/obj/item/material/butterfly/update_force()
	if(active)
		edge = 1
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		hitsound = 'sound/weapons/bladeslice.ogg'
		icon_state += "_open"
		w_class = ITEMSIZE_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	else
		force = 3
		edge = 0
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/material/butterfly/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	icon_state = "switchblade"

/obj/item/material/butterfly/butterfly_golden
	name = "gold-plated balisong"
	desc = "An exquisite, gold-plated butterfly knife. The centerpiece of any aspiring knife collector's showcase."
	icon_state = "butterflyknife_gold"
	applies_material_colour = 0

/obj/item/material/butterfly/butterfly_wooden
	name = "wood-handled butterfly knife"
	desc = "A concealable butterlfly knife with an ornate, wooden handle. Requires far too much care to use more than once."
	icon_state = "butterflyknife_wooden"
	applies_material_colour = 0

/obj/item/material/butterfly/boxcutter
	name = "box cutter"
	desc = "A thin, inexpensive razor-blade knife designed to open cardboard boxes."
	icon_state = "boxcutter"
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.2 // 4 when thrown with weight 20 (steel)

/obj/item/material/butterfly/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>You flip out \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")
	update_force()
	add_fingerprint(user)

/*
 * Kitchen knives
 */
/obj/item/material/knife
	name = "kitchen knife"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife"
	desc = "A general purpose Chef's Knife made by SpaceCook Incorporated. Guaranteed to stay sharp for years to come."
	sharp = 1
	edge = 1
	force_divisor = 0.15 // 9 when wielded with hardness 60 (steel)
	matter = list(MAT_STEEL = 12000)
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] throat with \the [src]! It looks like [TU.hes] trying to commit suicide.</span>", \
	                      "<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.hes] trying to commit seppuku.</span>"))
	return (BRUTELOSS)

// These no longer inherit from hatchets.
/obj/item/material/knife/tacknife
	name = "tactical knife"
	desc = "You'd be killing loads of people if this was Medal of Valor: Heroes of Space."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.20 //12 when hardness 60 (steel)
	attack_verb = list("stabbed", "chopped", "cut")
	applies_material_colour = 1

/obj/item/material/knife/tacknife/combatknife
	name = "combat knife"
	desc = "If only you had a boot to put it in."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "buckknife"
	item_state = "knife"
	force_divisor = 0.25 // 15 with hardness 60 (steel)
	thrown_force_divisor = 1.75 // 20 with weight 20 (steel)
	attack_verb = list("sliced", "stabbed", "chopped", "cut")
	applies_material_colour = 1

/obj/item/material/knife/stiletto
	name = "stiletto knife"
	desc = "A fancy-looking, thin bladed dagger designed to be stashed somewhere close to the body. Very lethal. Very illegal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stiletto"
	item_state = "knife"
	edge = 0 //Shouldn't be able to remove limbs
	force_divisor = 0.1 //6 when hardness 60 (steel)
	attack_verb = list("stabbed", "shanked", "punctured", "impaled", "skewered")
	applies_material_colour = 1

/obj/item/material/knife/tacknife/combatknife/bone
	icon_state = "boneknife"
	default_material = "bone"

// Identical to the tactical knife but nowhere near as stabby.
// Kind of like the toy esword compared to the real thing.
/obj/item/material/knife/tacknife/boot
	name = "boot knife"
	desc = "A small fixed-blade knife for putting inside a boot."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "tacknife"
	item_state = "knife"
	force_divisor = 0.15
	applies_material_colour = 0

/obj/item/material/knife/hook
	name = "meat hook"
	desc = "A sharp, metal hook what sticks into things."
	icon_state = "hook_knife"

/obj/item/material/knife/ritual
	name = "ritual knife"
	desc = "The unearthly energies that once powered this blade are now dormant."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	applies_material_colour = 0

/obj/item/material/knife/butch
	name = "butcher's cleaver"
	icon_state = "butch"
	desc = "A huge thing used for chopping and chopping up meat. This includes clowns and clown-by-products."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	attack_verb = list("cleaved", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/material/knife/machete
	name = "machete"
	desc = "A sharp machete often found in survival kits."
	icon_state = "machete"
	force_divisor = 0.3 // 18 when hardness 60 (steel)
	attack_verb = list("slashed", "chopped", "gouged", "ripped", "cut")
	can_cleave = TRUE //Now hatchets inherit from the machete, and thus knives. Tables turned.
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	default_material = "plasteel"
/obj/item/material/knife/machete/armblade
	name = "arm-mounted blade"
	desc = "A long, machete-like blade, mounted to your arm. The size and location of it lends itself to parrying blows in melee."
	icon_state = "armblade"
	item_state = "armblade"
	force_divisor = 0.5 // long and arm-mounted but you gotta use a suit for it
	slot_flags = null
	unbreakable = TRUE
	can_dull = FALSE

/obj/item/material/knife/machete/armblade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(33))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return TRUE
	return FALSE

/obj/item/material/knife/machete/armblade/rig
	default_material = MAT_STEEL
	canremove = FALSE
	var/obj/item/rig_module/armblade/storing_module

/obj/item/material/knife/machete/armblade/rig/dropped(mob/user)
	. = ..()
	if(storing_module)
		src.forceMove(storing_module)
		user.visible_message(
			"<span class='notice'>[user] retracts [src], folding it away with a click and a hiss.</span>",
			"<span class='notice'>You retract [src], folding it away with a click and a hiss.</span>",
			"<span class='notice'>You hear a threatening click and a hiss.</span>"
			)
		playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)
	else
		to_chat(user, "Something fucked up and the armblade got out of a module. Please report this bug.")
		qdel(src)

/obj/item/material/knife/tacknife/survival
	name = "streamlined survival knife"
	desc = "A hunting grade survival knife. The bulky storage handle has been replaced with a sleek grip and the ability to easily upgrade the blade."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "survivalknife"
	item_state = "knife"
	applies_material_colour = FALSE
	default_material = "plasteel"
	toolspeed = 2 // Use a real axe if you want to chop logs.

/obj/item/material/knife/tacknife/survival/bone
	name = "primitive survival knife"
	desc = "A hunting grade survival knife with a sleek leather grip."
	applies_material_colour =TRUE
	default_material = "bone"
/obj/item/material/knife/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "machetedx"
	item_state = "machete"

//The Return of the Data Knife
/obj/item/material/knife/tacknife/dataknife
	name = "data knife"
	desc = "A special operations close combat weapon. Its razor sharp blade is inlaid with complex circuitry capable of hacking a variety of electronics."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "dataknife"
	item_state = "knife"
	applies_material_colour = FALSE
	default_material = "plasteel"
	toolspeed = 2 // Use a real axe if you want to chop logs.
	var/gps_tag = "DAT&#%F0"
	var/emped = FALSE
	var/tracking = TRUE		// Will not show other signals or emit its own signal if false.
	var/long_range = FALSE		// If true, can see farther, depending on get_map_levels().
	var/local_mode = TRUE		// If true, only GPS signals of the same Z level are shown.
	var/hide_signal = TRUE	// If true, signal is not visible to other GPS devices.
	var/can_hide_signal = TRUE	// If it can toggle the above var.

/obj/item/material/knife/tacknife/dataknife/is_multitool()
	return TRUE

/obj/item/material/knife/tacknife/dataknife/AltClick(mob/user)
	toggletracking(user)

/obj/item/material/knife/tacknife/dataknife/proc/toggletracking(mob/living/user)
	if(!istype(user))
		return
	if(emped)
		to_chat(user, "It's busted!")
		return
	if(tracking)
		to_chat(user, "[src] is no longer tracking, or visible to GPS devices.")
		tracking = FALSE
		update_icon()
	else
		to_chat(user, "[src] is now tracking, and visible to GPS devices.")
		tracking = TRUE
		update_icon()

/obj/item/material/knife/tacknife/dataknife/emp_act(severity)
	if(emped) // Without a fancy callback system, this will have to do.
		return
	var/severity_modifier = severity ? severity : 4 // In case emp_act gets called without any arguments.
	var/duration = 5 MINUTES / severity_modifier
	emped = TRUE
	update_icon()

	spawn(duration)
		emped = FALSE
		update_icon()
		visible_message("\The [src] appears to be functional again.")

/obj/item/material/knife/tacknife/dataknife/attack_self(mob/user)
	display(user)

/obj/item/material/knife/tacknife/dataknife/proc/display_list()
	var/list/dat = list()

	var/turf/curr = get_turf(src)
	var/area/my_area = get_area(src)

	dat["my_area_name"] = my_area.name
	dat["curr_x"] = curr.x
	dat["curr_y"] = curr.y
	dat["curr_z"] = curr.z
	dat["curr_z_name"] = GLOB.using_map.get_zlevel_name(curr.z)
	var/list/gps_list = list()
	dat["gps_list"] = gps_list
	dat["z_level_detection"] = GLOB.using_map.get_map_levels(curr.z, long_range)

	for(var/obj/item/gps/G in GLOB.GPS_list - src)
		if(!G.tracking || G.emped || G.hide_signal)
			continue

		var/turf/T = get_turf(G)
		if(local_mode && curr.z != T.z)
			continue
		if(!(T.z in dat["z_level_detection"]))
			continue

		var/list/gps_data[0]
		gps_data["ref"] = G
		gps_data["gps_tag"] = G.gps_tag

		var/area/A = get_area(G)
		gps_data["area_name"] = A.name
		if(istype(A, /area/submap))
			gps_data["area_name"] = "Unknown Area" // Avoid spoilers.

		gps_data["z_name"] = GLOB.using_map.get_zlevel_name(T.z)
		gps_data["direction"] = get_adir(curr, T)
		gps_data["degrees"] = round(Get_Angle(curr,T))
		gps_data["distX"] = T.x - curr.x
		gps_data["distY"] = T.y - curr.y
		gps_data["distance"] = get_dist(curr, T)
		gps_data["local"] = (curr.z == T.z)
		gps_data["x"] = T.x
		gps_data["y"] = T.y
		gps_list[++gps_list.len] = gps_data

	return dat

/obj/item/material/knife/tacknife/dataknife/proc/display(mob/user)
	if(!tracking)
		to_chat(user, "The device is off. Alt-click it to turn it on.")
		return
	if(emped)
		to_chat(user, "It's busted!")
		return

	var/list/dat = list()
	var/list/gps_data = display_list()

	dat += "Current location: [gps_data["my_area_name"]] <b>([gps_data["curr_x"]], [gps_data["curr_y"]], [gps_data["curr_z_name"]])</b>"
	dat += "[hide_signal ? "Tagged" : "Broadcasting"] as '[gps_tag]'. <a href='?src=\ref[src];tag=1'>\[Change Tag\]</a> \
	<a href='?src=\ref[src];range=1'>\[Toggle Scan Range\]</a> \
	[can_hide_signal ? "<a href='?src=\ref[src];hide=1'>\[Toggle Signal Visibility\]</a>":""]"

	var/list/gps_list = gps_data["gps_list"]
	if(gps_list.len)
		dat += "Detected signals;"
		for(var/gps in gps_data["gps_list"])
			if(istype(gps_data["ref"], /obj/item/gps/internal/poi))
				dat += "    [gps["gps_tag"]]: [gps["area_name"]] - [gps["local"] ? "[gps["direction"]] Dist: [round(gps["distance"], 10)]m" : "in \the [gps["z_name"]]"]"
			else
				dat += "    [gps["gps_tag"]]: [gps["area_name"]], ([gps["x"]], [gps["y"]]) - [gps["local"] ? "[gps["direction"]] Dist: [gps["distX"] ? "[abs(round(gps["distX"], 1))]m [(gps["distX"] > 0) ? "E" : "W"], " : ""][gps["distY"] ? "[abs(round(gps["distY"], 1))]m [(gps["distY"] > 0) ? "N" : "S"]" : ""]" : "in \the [gps["z_name"]]"]"
	else
		dat += "No other signals detected."

	var/result = dat.Join("<br>")
	to_chat(user, result)

/obj/item/material/knife/tacknife/dataknife/Topic(var/href, var/list/href_list)
	if(..())
		return 1

	if(href_list["tag"])
		var/a = input("Please enter desired tag.", name, gps_tag) as text
		a = uppertext(copytext(sanitize(a), 1, 11))
		if(in_range(src, usr))
			gps_tag = a
			name = "data knife"
			to_chat(usr, "You set the data knife's tag to '[gps_tag]'.")

	if(href_list["range"])
		local_mode = !local_mode
		to_chat(usr, "You set the signal receiver to [local_mode ? "'NARROW'" : "'BROAD'"].")

	if(href_list["hide"])
		if(!can_hide_signal)
			return
		hide_signal = !hide_signal
		to_chat(usr, "You set the device to [hide_signal ? "not " : ""]broadcast a signal while scanning for other signals.")

// Knife Material Variants
/obj/item/material/butterfly/plasteel
	default_material = "plasteel"

/obj/item/material/butterfly/durasteel
	default_material = "durasteel"

/obj/item/material/butterfly/switchblade/plasteel
	default_material = "plasteel"

/obj/item/material/butterfly/switchblade/durasteel
	default_material = "durasteel"

/obj/item/material/butterfly/boxcutter/plasteel
	default_material = "plasteel"

/obj/item/material/butterfly/boxcutter/durasteel
	default_material = "durasteel"

/obj/item/material/knife/tacknife/plasteel
	default_material = "plasteel"

/obj/item/material/knife/tacknife/durasteel
	default_material = "durasteel"

/obj/item/material/knife/tacknife/combatknife/plasteel
	default_material = "plasteel"

/obj/item/material/knife/tacknife/combatknife/durasteel
	default_material = "durasteel"

/obj/item/material/knife/hook/plasteel
	default_material = "plasteel"

/obj/item/material/knife/hook/durasteel
	default_material = "durasteel"

/obj/item/material/knife/ritual/plasteel
	default_material = "plasteel"

/obj/item/material/knife/ritual/durasteel
	default_material = "durasteel"

/obj/item/material/knife/butch/plasteel
	default_material = "plasteel"

/obj/item/material/knife/butch/durasteel
	default_material = "durasteel"

/obj/item/material/knife/machete/durasteel
	default_material = "durasteel"

/obj/item/material/knife/machete/deluxe/durasteel
	default_material = "durasteel"

/obj/item/material/knife/tacknife/survival/durasteel
	default_material = "durasteel"
