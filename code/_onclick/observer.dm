/mob/observer/dead/DblClickOn(atom/A, params)
	// if(check_click_intercept(params, A))
	// 	return
	// LEGACY
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	if(can_reenter_corpse && mind?.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse() // (body bag, closet, mech, etc)
			return // seems legit.

	// Things you might plausibly want to follow
	if(ismovable(A))
		ManualFollow(A)

	// Otherwise jump
	else if(A.loc)
		forceMove(get_turf(A))
		// update_parallax_contents() // in a perfect world we would have this

/mob/observer/dead/ClickOn(atom/A, params)
	// if(check_click_intercept(params,A))
	// 	return

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, "shift"))
		if(LAZYACCESS(modifiers, "middle"))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, "ctrl"))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, "middle"))
		MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, "alt"))
		AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, "ctrl"))
		CtrlClickOn(A)
		return

	if(!canClick())
		return
	setClickCooldown(4)
	// You are responsible for checking config_legacy.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

/client/var/inquisitive_ghost = 1
/mob/observer/dead/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, "<span class='notice'>You will now examine everything you click on.</span>")
	else
		to_chat(src, "<span class='notice'>You will no longer examine things you click on.</span>")


// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/observer/dead/user)
	// if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return TRUE
	if(user.client)
		// if(user.gas_scan && atmosanalyzer_scan(user, src))
		// 	return TRUE
		if(IsAdminGhost(user))
			attack_ai(user)
		else if(user.client.inquisitive_ghost)
			user.examinate(src)
	return FALSE

/mob/living/attack_ghost(mob/observer/dead/user)
	// if(user.client && user.health_scan)
	// 	healthscan(user, src, 1, TRUE)
	// if(user.client && user.chem_scan)
	// 	chemscan(user, src)
	return ..()

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu

/obj/machinery/teleport/hub/attack_ghost(mob/observer/dead/user)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	if(com.locked)
		user.loc = get_turf(com.locked)

/obj/effect/portal/attack_ghost(mob/observer/dead/user)
	if(target)
		user.loc = get_turf(target)

/obj/machinery/gateway/centerstation/attack_ghost(mob/observer/dead/user)
	if(awaygate)
		user.loc = awaygate.loc
	else
		to_chat(user, "[src] has no destination.")

/obj/machinery/gateway/centeraway/attack_ghost(mob/observer/dead/user)
	if(stationgate)
		user.loc = stationgate.loc
	else
		to_chat(user, "[src] has no destination.")
