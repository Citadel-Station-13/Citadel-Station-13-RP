/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	opacity = FALSE
	lifetime = 15 //300 <- old, ((300/10)/2) new
	pass_flags = PASSTABLE | PASSGRILLE | PASSGLASS //PASSGLASS is fine here, it's just so the visual effect can "flow" around glass

/obj/effect/effect/smoke/chem/Initialize()
	. = ..()
	create_reagents(500) //create_reagents(500, NONE, NO_REAGENTS_VALUE)
	return

/obj/effect/effect/smoke/chem/process()
	if(..())
		var/turf/T = get_turf(src)
		var/fraction = 1 / initial(lifetime)
		for(var/atom/movable/AM in T)
			if(AM.type == src.type)
				continue
			if(AM.level == 1) // [T.intact && ] hidden under the floor
				continue
			//reagents.reaction(AM, TOUCH, fraction)
			reagents.trans_to(AM, fraction) //TOUCH is default
		//reagents.reaction(T, TOUCH, fraction)
		reagents.trans_to(T, fraction)
		return TRUE

/obj/effect/effect/smoke/chem/smoke_mob(mob/living/carbon/M)
	if(!..())
		return FALSE
	if(lifetime < 1)
		return FALSE
	if(!istype(M))
		return FALSE
	var/mob/living/carbon/C = M
	if(C.internal != null)// || C.has_smoke_protection())
		return FALSE
	var/fraction = 1 / initial(lifetime)
	//reagents.copy_to(C, fraction * reagents.total_volume)
	//reagents.reaction(M, INGEST, fraction)
	reagents.trans_to(C, fraction * reagents.total_volume, copy = TRUE)
	reagents.trans_to_mob(M, fraction, CHEM_INGEST) //copy then tranfter
	return TRUE


/datum/effect_system/smoke_spread/chem
	var/obj/chemholder
	effect_type = /obj/effect/effect/smoke/chem

/datum/effect_system/smoke_spread/chem/New()
	..()
	chemholder = new /obj()
	chemholder.create_reagents(500)

/datum/effect_system/smoke_spread/chem/Destroy()
	QDEL_NULL(chemholder)
	return ..()

/datum/effect_system/smoke_spread/chem/set_up(datum/reagents/carry = null, radius = 1, loca, silent = FALSE)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	amount = radius
	carry.trans_to(chemholder, carry.total_volume, copy = TRUE)
	//carry.copy_to(chemholder, carry.total_volume)

	if(!silent)
		var/contained = carry.get_reagents() //english list
		if(contained)
			contained = "\[[contained]\]"

		var/where = "[AREACOORD(location)]"
		if(carry.my_atom && carry.my_atom.fingerprintslast)
			var/mob/M = get_mob_by_key(carry.my_atom.fingerprintslast)
			var/more = ""
			if(M)
				more = "[ADMIN_LOOKUPFLW(M)] "
			message_admins("Smoke: ([ADMIN_VERBOSEJMP(location)])[contained]. Key: [more ? more : carry.my_atom.fingerprintslast].")
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last touched by [carry.my_atom.fingerprintslast].")
		else
			message_admins("Smoke: ([ADMIN_VERBOSEJMP(location)])[contained]. No associated key.")
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. No associated key.")

/datum/effect_system/smoke_spread/chem/start()
	var/mixcolor = chemholder.reagents.get_color()//mix_color_from_reagents(chemholder.reagents.reagent_list)
	if(holder)
		location = get_turf(holder)
	var/obj/effect/effect/smoke/chem/S = new effect_type(location)

	if(chemholder.reagents.total_volume > 1) // can't split 1 very well
		//chemholder.reagents.copy_to(S, chemholder.reagents.total_volume)
		chemholder.reagents.trans_to(S, chemholder.reagents.total_volume, copy = TRUE)
	if(mixcolor)
		S.add_atom_colour(mixcolor, FIXED_COLOUR_PRIORITY) // give the smoke color, if it has any to begin with
	S.amount = amount
	if(S.amount)
		S.spread_smoke() //calling process right now so the smoke immediately attacks mobs.

/datum/effect_system/smoke_spread/chem/spores
	var/datum/seed/seed

/datum/effect_system/smoke_spread/chem/spores/set_up(datum/reagents/carry = null, radius = 1, loca, silent = FALSE)
	silent = TRUE //force to be silent
	..()

/datum/effect_system/smoke_spread/chem/spores/New(seed_name)
	if(seed_name && plant_controller)
		seed = plant_controller.seeds[seed_name]
	if(!seed) //not found? D I E
		qdel(src)
		return //don't bother continuing (building the chem holder)
	..()
/*
//this solution is evil and i don't like it
/datum/effect_system/smoke_spread/chem/spores/start()	
	var/mixcolor = chemholder.reagents.get_color()//mix_color_from_reagents(chemholder.reagents.reagent_list)
	if(holder)
		location = get_turf(holder)
	var/obj/effect/effect/smoke/chem/S = new effect_type(location) 
	S.name = "cloud of [seed.seed_name] [seed.seed_noun]"

	if(chemholder.reagents.total_volume > 1) // can't split 1 very well
		//chemholder.reagents.copy_to(S, chemholder.reagents.total_volume)
		chemholder.reagents.trans_to(S, chemholder.reagents.total_volume, copy = TRUE)
	if(mixcolor)
		S.add_atom_colour(mixcolor, FIXED_COLOUR_PRIORITY) // give the smoke color, if it has any to begin with
	S.amount = amount
	if(S.amount)
		S.spread_smoke() //calling process right now so the smoke immediately attacks mobs.
*/
