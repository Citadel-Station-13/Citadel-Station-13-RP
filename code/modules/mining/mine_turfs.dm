CREATE_STANDARD_TURFS(/turf/simulated/mineral)
/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls/natural.dmi'
	icon_state = "preview"
	base_icon_state = "wall"
	opacity = 1
	density = 1
	blocks_air = 1
	can_dirty = FALSE
	has_resources = 1
	color = COLOR_ASTEROID_ROCK

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_MINERAL_WALLS)
	canSmoothWith = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS)

	var/sand_icon = 'icons/turf/flooring/asteroid.dmi'
	var/rock_side_icon_state = "rock_side"
	var/sand_icon_state = "asteroid"
	var/rock_icon_state = "rock"
	var/random_icon = 0

	var/datum/ore/mineral
	var/sand_dug
	var/mined_ore = 0
	var/last_act = 0
	var/overlay_detail

	var/arch_icon = 'icons/turf/walls.dmi'
	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/last_find
	var/datum/artifact_find/artifact_find
	var/ignore_mapgen
	var/ignore_oregen = FALSE
	var/ignore_cavegen = FALSE

/turf/simulated/mineral/floor
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	density = 0
	opacity = 0
	blocks_air = 0
	can_build_into_floor = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/mineral/rich)
/turf/simulated/mineral/rich

CREATE_STANDARD_TURFS(/turf/simulated/mineral/ignore_oregen)
/turf/simulated/mineral/ignore_oregen
	ignore_oregen = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/mineral/floor/ignore_oregen)
/turf/simulated/mineral/floor/ignore_oregen
	ignore_oregen = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/mineral/ignore_cavegen)
/turf/simulated/mineral/ignore_cavegen
	ignore_cavegen = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/mineral/floor/ignore_cavegen)
/turf/simulated/mineral/floor/ignore_cavegen
	ignore_cavegen = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/mineral/floor/ignore_cavegen)
/turf/simulated/mineral/floor/ignore_cavegen/has_air
	initial_gas_mix = GAS_STRING_STP

CREATE_STANDARD_TURFS(/turf/simulated/mineral/icerock/ignore_cavegen)
/turf/simulated/mineral/icerock/ignore_cavegen
	ignore_cavegen = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/mineral/icerock/floor/ignore_cavegen)
/turf/simulated/mineral/icerock/floor/ignore_cavegen
	ignore_cavegen = TRUE

// Alternative rock wall sprites.
/turf/simulated/mineral/light
	icon_state = "rock-light"
	rock_side_icon_state = "rock_side-light"
	sand_icon_state = "sand-light"
	rock_icon_state = "rock-light"
	random_icon = 1

/turf/simulated/mineral/icerock
	name = "icerock"
	color = "#78a3b8"
	random_icon = 1

/turf/simulated/mineral/icerock/airmix
	initial_gas_mix = GAS_STRING_STP

/turf/unsimulated/wall/mineral/icerock
	name = "impassable icerock"
	icon = 'icons/turf/walls.dmi'
	base_icon_state = "wall"
	density = 1
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS )
	canSmoothWith = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS )
	color = COLOR_OFF_WHITE

/turf/simulated/mineral/ignore_mapgen
	ignore_mapgen = 1

//Alternative sand floor sprite.
/turf/simulated/mineral/floor/light
	icon_state = "sand-light"
	sand_icon_state = "sand-light"

/turf/simulated/mineral/floor/light_border
	icon_state = "sand-light-border"
	sand_icon_state = "sand-light-border"

/turf/simulated/mineral/floor/light_nub
	icon_state = "sand-light-nub"
	sand_icon_state = "sand-light-nub"

/turf/simulated/mineral/floor/light_corner
	icon_state = "sand-light-corner"
	sand_icon_state = "sand-light-corner"

/turf/simulated/mineral/floor/ignore_mapgen
	ignore_mapgen = 1

/turf/simulated/mineral/floor/icerock
	name = "ice"
	icon_state = "ice"
	sand_icon_state = "ice"

/turf/simulated/mineral/floor/icerock/airmix
	initial_gas_mix = GAS_STRING_STP

// todo: don't make this the same /turf path, it doesn't make semantic sense
/turf/simulated/mineral/proc/make_floor()
	if(!density && !opacity)
		return
	density = FALSE
	opacity = FALSE
	recalc_atom_opacity()
	reconsider_lights()
	regenerate_ao()
	blocks_air = FALSE
	can_build_into_floor = TRUE
	//SSplanets.addTurf(src)	// Thank you Silicons, this was causing underground areas to have weather effects in them	- Bloop
	queue_zone_update()
	smoothing_groups = null
	canSmoothWith = null
	if(atom_flags & ATOM_INITIALIZED)
		SETUP_SMOOTHING()
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	update_icon()
	if(SSair.initialized)
		queue_zone_update()

// todo: don't make this the same /turf path, it doesn't make semantic sense
/turf/simulated/mineral/proc/make_wall()
	if(density && opacity)
		return
	density = TRUE
	opacity = TRUE
	recalc_atom_opacity()
	reconsider_lights()
	regenerate_ao()
	blocks_air = TRUE
	can_build_into_floor = FALSE
	//SSplanets.removeTurf(src)	// Thank you Silicons, this was causing underground areas to have weather effects in them as well -Bloop
	queue_zone_update()
	smoothing_groups = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_MINERAL_WALLS)
	canSmoothWith = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MINERAL_WALLS)
	if(atom_flags & ATOM_INITIALIZED)
		SETUP_SMOOTHING()
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	update_icon()

/turf/simulated/mineral/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module)
			for(var/obj/item/storage/bag/ore/O in list(R.module_state_1, R.module_state_2, R.module_state_3))
				O.autoload(R)
				return

/turf/simulated/mineral/Initialize(mapload)
	. = ..()
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"
	if(mineral)
		update_icon()
		if(density)
			MineralSpread()

/* custom smoothing code */
/turf/simulated/mineral/find_type_in_direction(direction)
	var/turf/T = get_step(src, direction)
	if(!T)
		return NULLTURF_BORDER
	return T.density? ADJ_FOUND : NO_ADJ_FOUND

/turf/simulated/mineral/update_icon()
	cut_overlays()
	. = ..()

	var/list/to_add = list()
	//We are a wall (why does this system work like this??)
	// todo: refactor this shitheap because this is pants on fucking head awful
	if(density)
		if(mineral)
			name = "[mineral.display_name] deposit"
		else
			name = "rock"

		icon = 'icons/turf/walls/natural.dmi'
//		icon_state = rock_icon_state

		if(archaeo_overlay)
			to_add += mutable_appearance(arch_icon, archaeo_overlay)
		if(excav_overlay)
			to_add += mutable_appearance(arch_icon, excav_overlay)
		if(mineral)
			var/image/mineral_overlay = image('icons/modules/mining/ore_overlay.dmi', "rock_[mineral.name]")
			mineral_overlay.appearance_flags = KEEP_APART | RESET_COLOR
			to_add += mineral_overlay

	//We are a sand floor
	else
		name = "sand"
		icon = sand_icon // So that way we can source from other files.
		icon_state = sand_icon_state

		if(sand_dug)
			to_add += mutable_appearance(icon, "dug_overlay")
		if(overlay_detail)
			to_add += mutable_appearance('icons/turf/flooring/decals.dmi', overlay_detail)

	if(length(to_add))
		add_overlay(to_add)

/turf/simulated/mineral/legacy_ex_act(severity)

	switch(severity)
		if(2.0)
			if (prob(70))
				mined_ore = 1 //some of the stuff gets blown up
				GetDrilled()
		if(1.0)
			mined_ore = 2 //some of the stuff gets blown up
			GetDrilled()

	if(severity <= 2) // Now to expose the ore lying under the sand.
		spawn(1) // Otherwise most of the ore is lost to the explosion, which makes this rather moot.
			for(var/ore in resources)
				var/amount_to_give = rand(CEILING(resources[ore]/2, 1), resources[ore])  // Should result in at least one piece of ore.
				if(GLOB.ore_types[ore])
					for(var/i=1, i <= amount_to_give, i++)
						var/oretype = GLOB.ore_types[ore]
						new oretype(src)
				resources[ore] = 0

/turf/simulated/mineral/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	if(proj.excavation_amount)
		var/newDepth = excavation_level + proj.excavation_amount // Used commonly below
		if(newDepth >= 200) // first, if the turf is completely drilled then don't bother checking for finds and just drill it
			GetDrilled(0)
			return

		//destroy any archaeological finds
		if(finds && finds.len)
			var/datum/find/F = finds[1]
			if(newDepth > F.excavation_required) // Digging too deep with something as clumsy or random as a blaster will destroy artefacts
				finds.Remove(finds[1])
				if(prob(50))
					artifact_debris()

		excavation_level += proj.excavation_amount
		update_archeo_overlays(proj.excavation_amount)

/turf/simulated/mineral/Bumped(AM)

	. = ..()

	if(!density)
		return .

	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		var/obj/item/pickaxe/P = H.get_inactive_held_item()
		if(istype(P) && P.active)
			src.attackby(P, H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/pickaxe))
			attackby(R.module_active,R)

	else if(istype(AM,/obj/vehicle/sealed/mecha))
		var/obj/vehicle/sealed/mecha/M = AM
		if(istype(M.selected,/obj/item/vehicle_module/tool/drill))
			M.selected.action(src)

/turf/simulated/mineral/proc/MineralSpread()
	if(mineral && mineral.spread)
		for(var/trydir in GLOB.cardinal)
			if(prob(mineral.spread_chance))
				var/turf/simulated/mineral/target_turf = get_step(src, trydir)
				if(istype(target_turf) && target_turf.density && !target_turf.mineral)
					target_turf.mineral = mineral
					target_turf.update_icon()
					target_turf.MineralSpread()

//Not even going to touch this pile of spaghetti
/turf/simulated/mineral/attackby(obj/item/W as obj, mob/user as mob)

	if (!(user.IsAdvancedToolUser() || SSticker) && SSticker.mode.name != "monkey")
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if(!density)

		var/valid_tool = 0
		var/grave_digger = 0
		var/digspeed = 40
/*
		var/list/usable_tools = list(
			/obj/item/shovel,
			/obj/item/pickaxe/diamonddrill,
			/obj/item/pickaxe/drill,
			/obj/item/pickaxe/borgdrill
			)
*/
		if(istype(W, /obj/item/shovel))
			var/obj/item/shovel/S = W
			valid_tool = 1
			grave_digger = 1
			digspeed = S.digspeed

		if(istype(W, /obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			if(P.sand_dig && P.active)
				valid_tool = 1
				digspeed = P.digspeed

		if(valid_tool)
			if(sand_dug)
				if(grave_digger)
					var/grave_type = /obj/structure/closet/grave
					if(do_after(user, 60))
						to_chat(user, "<span class='warning'>You deepen the hole.</span>")
						new grave_type(get_turf(src))
						return
				else
					to_chat(user, "<span class='warning'>This area has already been dug.</span>")
					return

			var/turf/T = user.loc
			if(!(istype(T)))
				return

			// to_chat(user, "<span class='notice'>You start digging.</span>")
			playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

			if(!do_after(user,digspeed))
				return

			// to_chat(user, "<span class='notice'>You dug a hole.</span>")
			GetDrilled()

		else if(istype(W, /obj/item/stack/rods))
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return
			var/obj/item/stack/rods/R = W
			if (R.use(1))
				to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				new /obj/structure/lattice(get_turf(src))

		else if(istype(W, /obj/item/stack/tile/floor))
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				var/obj/item/stack/tile/floor/S = W
				if (S.get_amount() < 1)
					return
				qdel(L)
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				PlaceOnTop(/turf/simulated/floor/plating, flags = CHANGETURF_INHERIT_AIR)
				S.use(1)
				return
			else
				to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")
				return

	else
		if (istype(W, /obj/item/core_sampler))
			var/obj/item/core_sampler/C = W
			C.sample_item(src, user)
			return

		if (istype(W, /obj/item/depth_scanner))
			var/obj/item/depth_scanner/C = W
			C.scan_atom(user, src)
			return

		if (istype(W, /obj/item/measuring_tape))
			var/obj/item/measuring_tape/P = W
			user.visible_message("<span class='notice'>\The [user] extends \a [P] towards \the [src].</span>","<span class='notice'>You extend \the [P] towards \the [src].</span>")
			if(do_after(user, 15))
				to_chat(user, "<span class='notice'>\The [src] has been excavated to a depth of [excavation_level]cm.</span>")
			return

		if(istype(W, /obj/item/xenoarch_multi_tool))
			var/obj/item/xenoarch_multi_tool/C = W
			if(C.mode) //Mode means scanning
				C.depth_scanner.scan_atom(user, src)
			else
				user.visible_message("<span class='notice'>\The [user] extends \the [C] over \the [src], a flurry of red beams scanning \the [src]'s surface!</span>", "<span class='notice'>You extend \the [C] over \the [src], a flurry of red beams scanning \the [src]'s surface!</span>")
				if(do_after(user, 15))
					to_chat(user, "<span class='notice'>\The [src] has been excavated to a depth of [excavation_level]cm.</span>")
			return

		if (istype(W, /obj/item/pickaxe))
			if(!istype(user.loc, /turf))
				return

			var/obj/item/pickaxe/P = W
			if(P.active)
				if(last_act + P.digspeed > world.time)//prevents message spam
					return
				last_act = world.time

				playsound(user, P.drill_sound, 20, 1)
				var/newDepth = excavation_level + P.excavation_amount // Used commonly below

				//handle any archaeological finds we might uncover
				var/fail_message = ""
				if(finds && finds.len)
					var/datum/find/F = finds[1]
					if(newDepth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
						fail_message = "<b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"
					wreckfinds(P.destroy_artefacts)
				if(fail_message)
					to_chat(user, "<span class='notice'>[fail_message].</span>")

				if(do_after(user,P.digspeed))

					if(finds && finds.len)
						var/datum/find/F = finds[1]
						if(newDepth == F.excavation_required) // When the pick hits that edge just right, you extract your find perfectly, it's never confined in a rock
							excavate_find(1, F)
						else if(newDepth > F.excavation_required - F.clearance_range) // Not quite right but you still extract your find, the closer to the bottom the better, but not above 80%
							excavate_find(prob(80 * (F.excavation_required - newDepth) / F.clearance_range), F)

					//to_chat(user, "<span class='notice'>You finish [P.drill_verb] \the [src].</span>")

					if(newDepth >= 200) // This means the rock is mined out fully
						if(P.destroy_artefacts)
							GetDrilled(0)
						else
							excavate_turf()
						return

					excavation_level += P.excavation_amount
					update_archeo_overlays(P.excavation_amount)

					//drop some rocks
					next_rock += P.excavation_amount
					while(next_rock > 50)
						next_rock -= 50
						new /obj/item/stack/ore(src)
				return
			else
				return

		if (istype(W, /obj/item/melee/thermalcutter))
			if(!istype(user.loc, /turf))
				return

			var/obj/item/melee/thermalcutter/T = W
			if(T.active)
				if(last_act + T.digspeed > world.time)//prevents message spam
					return
				last_act = world.time

				playsound(user, 'sound/items/Welder.ogg', 20, 1)
				var/newDepth = excavation_level + T.excavation_amount // Used commonly below

				//handle any archaeological finds we might uncover
				var/fail_message = ""
				if(finds && finds.len)
					var/datum/find/F = finds[1]
					if(newDepth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
						fail_message = "<b>[pick("There is a crunching noise","[W] collides with some different rock","Part of the rock face crumbles away","Something breaks under [W]")]</b>"
					wreckfinds(T.destroy_artefacts)
				if(fail_message)
					to_chat(user, "<span class='notice'>[fail_message].</span>")

				if(do_after(user,T.digspeed))

					if(finds && finds.len)
						var/datum/find/F = finds[1]
						if(newDepth == F.excavation_required) // When the pick hits that edge just right, you extract your find perfectly, it's never confined in a rock
							excavate_find(1, F)
						else if(newDepth > F.excavation_required - F.clearance_range) // Not quite right but you still extract your find, the closer to the bottom the better, but not above 80%
							excavate_find(prob(80 * (F.excavation_required - newDepth) / F.clearance_range), F)

					//to_chat(user, "<span class='notice'>You finish [P.drill_verb] \the [src].</span>")

					if(newDepth >= 200) // This means the rock is mined out fully
						if(T.destroy_artefacts)
							GetDrilled(0)
						else
							excavate_turf()
						return

					excavation_level += T.excavation_amount
					update_archeo_overlays(T.excavation_amount)

					//drop some rocks
					next_rock += T.excavation_amount
					while(next_rock > 50)
						next_rock -= 50
						var/obj/item/stack/ore/O = new(src)
						O.geologic_data = geologic_data
				return
			else
				return

	return ..()

/turf/simulated/mineral/proc/wreckfinds(var/destroy = FALSE)
	if(!destroy && prob(90)) //nondestructive methods have a chance of letting you step away to not trash things
		if(prob(25))
			excavate_find(prob(5), finds[1])
	else if(prob(50) || destroy) //destructive methods will always destroy finds, no bowls menacing with spikes for you
		finds.Remove(finds[1])
		if(prob(50))
			artifact_debris()

/turf/simulated/mineral/proc/update_archeo_overlays(var/excavation_amount = 0)
	var/updateIcon = 0

	//archaeo overlays
	if(!archaeo_overlay && finds && finds.len)
		var/datum/find/F = finds[1]
		if(F.excavation_required <= excavation_level + F.view_range)
			cut_overlay(archaeo_overlay)
			archaeo_overlay = "overlay_archaeo[rand(1,3)]"
			add_overlay(archaeo_overlay)

	else if(archaeo_overlay && (!finds || !finds.len))
		cut_overlay(archaeo_overlay)
		archaeo_overlay = null

	//there's got to be a better way to do this
	var/update_excav_overlay = 0
	if(excavation_level >= 150)
		if(excavation_level - excavation_amount < 150)
			update_excav_overlay = 1
	else if(excavation_level >= 100)
		if(excavation_level - excavation_amount < 100)
			update_excav_overlay = 1
	else if(excavation_level >= 50)
		if(excavation_level - excavation_amount < 50)
			update_excav_overlay = 1

	//update overlays displaying excavation level
	if( !(excav_overlay && excavation_level > 0) || update_excav_overlay )
		var/excav_quadrant = round(excavation_level / 25) + 1
		if(excav_quadrant > 5)
			excav_quadrant = 5
		cut_overlay(excav_overlay)
		excav_overlay = "overlay_excv[excav_quadrant]_[rand(1,3)]"
		add_overlay(excav_overlay)

	if(updateIcon)
		update_appearance()

/turf/simulated/mineral/proc/DropMineral(amount)
	if(!mineral)
		return
	var/obj/item/stack/ore/O = new mineral.ore(src, amount)
	return O

/turf/simulated/mineral/proc/excavate_turf()
	var/obj/structure/boulder/B
	if(artifact_find)
		if( excavation_level > 0 || prob(15) )
			//boulder with an artifact inside
			B = new(src)
			if(artifact_find)
				B.artifact_find = artifact_find
		else
			artifact_debris(1)
	else if(prob(5))
		//empty boulder
		B = new(src)

	if(B)
		GetDrilled(0)
	else
		GetDrilled(1)

/turf/simulated/mineral/proc/GetDrilled(var/artifact_fail = 0)

	if(!density)
		if(!sand_dug)
			sand_dug = 1
			new/obj/item/stack/ore/glass(src,5)
			QUEUE_SMOOTH(src)
		return

	if (mineral && mineral.result_amount)
		//if the turf has already been excavated, some of it's ore has been removed
		DropMineral(mineral.result_amount - mined_ore)
		mineral = null

	//destroyed artifacts have weird, unpleasant effects
	//make sure to destroy them before changing the turf though
	if(artifact_find && artifact_fail)
		var/pain = 0
		if(prob(50))
			pain = 1
		for(var/mob/living/M in range(src, 200))
			to_chat(M, "<span class='danger'>[pick("A high-pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!</span>")
			if(pain)
				flick("pain",M.pain)
				if(prob(50))
					M.adjustBruteLoss(5)
			else
				M.flash_eyes()
				if(prob(50))
					M.afflict_stun(20 * 5)
		new /obj/item/artifact_shards(src, 1000, rand(0.5 MINUTES, 3 MINUTES), RAD_FALLOFF_ANOMALY_SHARDS)
		if(prob(25))
			excavate_find(prob(5), finds[1])
	else if(rand(1,500) == 1)
		visible_message("<span class='notice'>An old dusty crate was buried within!</span>")
		new /obj/structure/closet/crate/secure/loot(src)

	make_floor()

/obj/item/artifact_shards
	name = "sickening fragments"
	icon = 'icons/obj/shards.dmi'
	icon_state = "splinterslarge"
	desc = "Looking at this makes you feel sick. You should probably get away from it."

/obj/item/artifact_shards/Initialize(mapload, intensity = 1000, half_life = rand(0.5 MINUTES, 3 MINUTES), falloff = RAD_FALLOFF_ANOMALY_SHARDS)
	. = ..()
	AddComponent(/datum/component/radioactive, intensity, half_life, falloff = falloff)

/turf/simulated/mineral/proc/excavate_find(var/is_clean = 0, var/datum/find/F)
	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	var/obj/item/X
	if(is_clean)
		X = new /obj/item/archaeological_find(src, F.find_type)
	else
		X = new /obj/item/strangerock(src, F.find_type)
		var/obj/item/strangerock/SR = X
		SR.geologic_data = geologic_data

	//some find types delete the /obj/item/archaeological_find and replace it with something else, this handles when that happens
	//yuck
	var/display_name = "Something"
	if(!X)
		X = last_find
	if(X)
		display_name = X.name

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S)
			if(X)
				visible_message("<span class='danger'>\The [pick("[display_name] crumbles away into dust","[display_name] breaks apart")].</span>")
				qdel(X)

	finds.Remove(F)

/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented not-fucking-stupid overhaul!

	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				new /obj/item/stack/rods(src, rand(5,25))
			if(2)
				new /obj/item/stack/material/plasteel(src, rand(5,25))
			if(3)
				new /obj/item/stack/material/steel(src, rand(5,25))
			if(4)
				new /obj/item/stack/material/plasteel(src, rand(5,25))
			if(5)
				for(var/i=1 to rand(1,3))
					new /obj/item/material/shard(src)
			if(6)
				for(var/i=1 to rand(1,3))
					new /obj/item/material/shard/phoron(src)
			if(7)
				new /obj/item/stack/material/uranium(src, rand(5,25))

/turf/simulated/mineral/proc/make_ore(rare_ore)
	if(mineral || ignore_mapgen || ignore_oregen)
		return

	var/mineral_name = standard_mineral_roll(rare_ore)

	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		if(atom_flags & ATOM_INITIALIZED)
			update_icon()
