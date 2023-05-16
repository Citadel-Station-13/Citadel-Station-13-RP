/mob/observer/dead/DblClickOn(atom/A, params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return

	// Things you might plausibly want to follow
	if(ismovable(A))
		ManualFollow(A)

	// Otherwise jump
	else if(A.loc)
		forceMove(get_turf(A))
//		update_parallax_contents()

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

/mob/observer/dead/ClickOn(var/atom/A, var/params)
	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["middle"])
		ShiftMiddleClickOn(A)
		return
	if(!canClick()) return
	setClickCooldown(4)
	// You are responsible for checking config_legacy.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/observer/dead/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user)
	// TODO: main ai interact bay code fucking disgusts me wtf
	if(IsAdminGhost(user))		// admin AI interact
		AdminAIInteract(user)
		return
	if(user.client && user.client.inquisitive_ghost)
		user.examinate(src)

// defaults to just attack_ai
/atom/proc/AdminAIInteract(mob/user)
	return attack_ai(user)

// ---------------------------------------
// And here are some good things for free:
// Now you can click through portals, wormholes, gateways, and teleporters while observing. -Sayu
/*
/obj/machinery/tele_pad/attack_ghost(mob/user as mob)
	var/atom/l = loc
	var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(l.x - 2, l.y, l.z))
	 if(com.locked)
		user.loc = get_turf(com.locked)
*/
/obj/effect/portal/attack_ghost(mob/user)
	. = ..()
	if(target)
		user.forceMove(get_turf(target))

/obj/machinery/gateway/centerstation/attack_ghost(mob/user)
	. = ..()
	if(awaygate)
		user.forceMove(awaygate.loc)
	else
		to_chat(user, "[src] has no destination.")

/obj/machinery/gateway/centeraway/attack_ghost(mob/user)
	. = ..()
	if(stationgate)
		user.forceMove(stationgate.loc)
	else
		to_chat(user, "[src] has no destination.")

// -------------------------------------------
// This was supposed to be used by adminghosts
// I think it is a *terrible* idea
// but I'm leaving it here anyway
// commented out, of course.
/*
/atom/proc/attack_admin(mob/user as mob)
	if(!user || !user.client || !user.client.holder)
		return
	attack_hand(user)

*/

//! ## VR FILE MERGE ## !//
/obj/item/paicard/attack_ghost(mob/user)
	. = ..()
	if(src.pai != null) //Have a person in them already?
		user.examinate(src)
		return
	var/choice = input(user, "You sure you want to inhabit this PAI?") in list("Yes", "No")
	var/pai_name = input(user, "Choose your character's name", "Character Name") as text
	var/actual_pai_name = sanitize_species_name(pai_name)
	var/pai_key
	if (isnull(pai_name))
		return
	if(choice == "Yes")
		pai_key = user.key
	else
		return
	var/turf/location = get_turf(src)
	var/obj/item/paicard/card = new(location)
	var/mob/living/silicon/pai/pai = new(card)
	qdel(src)
	pai.key = pai_key
	card.setPersonality(pai)
	pai.SetName(actual_pai_name)
