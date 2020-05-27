//Vars that will not be copied when using /DuplicateObject
GLOBAL_LIST_INIT(duplicate_forbidden_vars,list(
	"tag", "datum_components", "area", "type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key",
	"power_supply", "contents", "reagents", "stat", "x", "y", "z", "group", "atmos_adjacent_turfs", "comp_lookup"
	))

GLOBAL_LIST_INIT(duplicate_forbidden_vars_by_type, typecacheof_assoc_list(list(
	/obj/item/gun/energy = "ammo_type"
	)))

/proc/DuplicateObject(atom/original, perfectcopy = TRUE, sameloc = FALSE, atom/newloc = null, nerf = FALSE, holoitem = FALSE)
	RETURN_TYPE(original.type)
	if(!original)
		return

	var/atom/O

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(newloc)

	if(perfectcopy && O && original)
		for(var/V in original.vars - GLOB.duplicate_forbidden_vars - GLOB.duplicate_forbidden_vars_by_type[O.type])
			if(islist(original.vars[V]))
				var/list/L = original.vars[V]
				O.vars[V] = L.Copy()
			else if(istype(original.vars[V], /datum))
				continue	// this would reference the original's object, that will break when it is used or deleted.
			else
				O.vars[V] = original.vars[V]

	if(isobj(O))
		var/obj/N = O
		//if(holoitem) //Not included, no magic flags yet
		//	N.resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF // holoitems do not burn

		//if(nerf && isitem(O))
		//	var/obj/item/I = O
		//	I.damtype = STAMINA // thou shalt not

		N.update_icon()
		if(ismachinery(O))
			var/obj/machinery/M = O
			M.power_change()

	//if(holoitem)
	//	O.flags_1 |= HOLOGRAM_1
	return O

//Takes: Area. Optional: If it should copy to areas that don't have plating (default FALSE)
//Returns: Nothing.
//Notes: Attempts to move the contents of one area to another area.
//       Movement based on lower left corner. Tiles that do not fit
//		 into the new area will not be moved.
/area/proc/copy_contents_to(area/A, platingRequired = TRUE, nerf_weapons = FALSE)
	if(!A || !src)
		return FALSE

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 99999
	var/src_min_y = 99999
	var/src_max_x = 0
	var/src_max_y = 0
	var/list/refined_src = list()

	for(var/turf/T in turfs_src)
		src_min_x = min(src_min_x,T.x)
		src_min_y = min(src_min_y,T.y)
		src_max_x = max(src_max_x,T.x)
		src_max_y = max(src_max_y,T.y)
	for(var/turf/T in turfs_src)
		refined_src[T] = "[T.x - src_min_x].[T.y - src_min_y]"

	var/trg_min_x = 99999
	var/trg_min_y = 99999
	var/trg_max_x = 0
	var/trg_max_y = 0
	var/list/refined_trg = list()

	for(var/turf/T in turfs_trg)
		trg_min_x = min(trg_min_x,T.x)
		trg_min_y = min(trg_min_y,T.y)
		trg_max_x = max(trg_max_x,T.x)
		trg_max_y = max(trg_max_y,T.y)

	var/diff_x = round(((src_max_x - src_min_x) - (trg_max_x - trg_min_x))/2)
	var/diff_y = round(((src_max_y - src_min_y) - (trg_max_y - trg_min_y))/2)
	for(var/turf/T in turfs_trg)
		refined_trg["[T.x - trg_min_x + diff_x].[T.y - trg_min_y + diff_y]"] = T

	var/list/toupdate = list()
	var/list/copiedobjs = list()

	for(var/turf/T in refined_src)
		var/coordstring = refined_src[T]
		var/turf/B = refined_trg[coordstring]
		if(!istype(B))
			continue

		if(platingRequired)
			if(istype(B, get_base_turf_by_area(B)))
				continue
			//if(istype(T, /turf/space)) //if(isspaceturf(B))
			//	continue

		var/old_dir1 = T.dir
		var/old_icon_state1 = T.icon_state
		var/old_icon1 = T.icon
		var/old_underlays = T.underlays.Copy() //vorestation specific.

		B = B.ChangeTurf(T.type)
		B.setDir(old_dir1)
		B.icon = old_icon1
		B.icon_state = old_icon_state1
		B.copy_overlays(T, TRUE)
		B.underlays = old_underlays

		for(var/obj/O in T)
			var/obj/O2 = DuplicateObject(O, TRUE, newloc = B, nerf = nerf_weapons) //, holoitem = TRUE)
			if(!O2)
				continue
			copiedobjs += O2.GetAllContents()

		for(var/mob/M in T)
			if(istype(M, /mob/observer/eye)) //if(iscameramob(M))
				continue // If we need to check for more mobs, I'll add a variable
			var/mob/SM = DuplicateObject(M , TRUE, newloc = B) //, holoitem = TRUE)
			copiedobjs += SM.GetAllContents()

		for(var/V in T.vars - GLOB.duplicate_forbidden_vars)
			/*  //Do not update the air.
			if(V == "air")
				var/turf/simulated/O1 = B //x is b, new tile
				var/turf/simulated/O2 = T //old tile
				if(istype(O2) && O2.zone) //is it simulatedturf & has atmos zone?
					if(!O1.air)
						O1.make_air()
					O1.air.copy_from(O2.zone.air)
					//O1.air.copy_from(O2.return_air()) this is the one tg has
					O2.zone.remove(O2)
				continue
			*/
			B.vars[V] = T.vars[V]
		toupdate += B
	/*
	if(toupdate.len)
		for(var/turf/T1 in toupdate)
			CALCULATE_ADJACENT_TURFS(T1)
			SSair.add_to_active(T1, 1)
	*/
	return copiedobjs
