/obj/item/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	origin_tech = list(TECH_MAGNET = 2)
	matter = list(MAT_STEEL = 1000, MAT_GLASS = 500)

	wires = WIRE_PULSE

	secured = FALSE

	/// on or off?
	var/on = FALSE
	/// visible beam?
	var/visible = FALSE
	/// head of beam
	var/obj/effect/beam/i_beam/head
	/// range of beam - capped to 100
	var/range = 8
	/// requires rebuild?
	var/dirty = FALSE
	/// current atom listening to
	var/atom/movable/listening
	var/hearing_range = 3

/obj/item/assembly/infra/activate()
	. = ..()
	if(!.)
		return
	if(on)
		turn_off()
	else
		turn_on()

/obj/item/assembly/infra/toggle_secure()
	secured = !secured
	if(!secured)
		turn_off()
	return secured

/obj/item/assembly/infra/proc/turn_on()
	if(!secured)
		turn_off()
		return
	if(on)
		return
	on = TRUE
	Rebuild()
	update_icon()
	START_PROCESSING(SSfastprocess, src)

/obj/item/assembly/infra/proc/turn_off()
	if(!on)
		return
	if(listening)
		UnregisterSignal(listening, COMSIG_MOVABLE_MOVED)
		listening = null
	on = FALSE
	Rebuild()
	update_icon()
	STOP_PROCESSING(SSfastprocess, src)

/obj/item/assembly/infra/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(on)
		overlays += "infrared_on"
		attached_overlays += "infrared_on"
	if(holder)
		holder.update_icon()

/obj/item/assembly/infra/proc/toggle_visible()
	visible = !visible
	head?.SetVisible(visible)

/obj/item/assembly/infra/setDir()
	var/old = dir
	. = ..()
	if(old == dir)
		return
	Queue()

/obj/item/assembly/infra/proc/Queue()
	dirty = TRUE

/obj/item/assembly/infra/proc/Rebuild()
	if(head)
		if(!QDELETED(head))
			QDEL_NULL(head)
		head = null
	if(!on || QDELETED(src))
		return
	if(!loc)
		return
	if(ismovable(loc)) // register listener
		if(listening)
			UnregisterSignal(listening, COMSIG_MOVABLE_MOVED)
		listening = loc
		RegisterSignal(loc, COMSIG_MOVABLE_MOVED, .proc/Queue)
	if(!isturf(loc) && !isturf(loc.loc))	// only allow nesting 1 deep
		return
	// spread
	var/obj/effect/beam/i_beam/I = new(loc, src, range - 1, visible, null)
	I.density = TRUE
	I.setDir(dir)
	step(I, I.dir)
	// did it work?
	if(QDELETED(I))
		// nope
		return
	else
		head = I
		head.density = FALSE
		head.Propagate()
	dirty = FALSE

/obj/item/assembly/infra/process(delta_time)
	if(!on || QDELETED(src))
		Rebuild()
		return PROCESS_KILL
	if(QDELETED(head) || dirty)
		Rebuild()
		return
	head.Refresh()

/obj/item/assembly/infra/Move()
	var/old_dir = dir
	. = ..()
	setDir(old_dir)
	Queue()

/obj/item/assembly/infra/doMove()
	. = ..()
	Queue()

/obj/item/assembly/infra/holder_movement()
	if(!holder)
		return FALSE
	setDir(holder.dir)
	Queue()
	return TRUE

/obj/item/assembly/infra/Moved(atom/oldloc)
	. = ..()
	if(listening)
		UnregisterSignal(listening, COMSIG_MOVABLE_MOVED)
	if(on && ismovable(loc))
		RegisterSignal(loc, COMSIG_MOVABLE_MOVED, .proc/Queue)
		listening = loc

/obj/item/assembly/infra/proc/trigger_beam()
	if((!secured)||(!on)||(cooldown > 0))
		return FALSE
	pulse(0)
	if(!holder)
		audible_message(SPAN_INFOPLAIN("[icon2html(src, hearers(src))] *beep* *beep* *beep*"), null, hearing_range)
		for(var/mob/hearing_mob in get_hearers_in_view(hearing_range, src))
			hearing_mob.playsound_local(get_turf(src), 'sound/machines/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)
	cooldown = 2
	addtimer(CALLBACK(src, /obj/item/assembly/proc/process_cooldown), 10)

/obj/item/assembly/infra/ui_interact(mob/user, datum/tgui/ui)
	if(!secured)
		to_chat(user, SPAN_WARNING("[src] is unsecured!"))
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AssemblyInfrared", name)
		ui.open()

/obj/item/assembly/infra/ui_data(mob/user)
	var/list/data = ..()

	data["on"] = on
	data["visible"] = visible

	return data

/obj/item/assembly/infra/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("state")
			activate()
			return TRUE
		if("visible")
			visible = !visible
			for(var/ibeam in head)
				var/obj/effect/beam/i_beam/I = ibeam
				I.visible = visible
				CHECK_TICK
			return TRUE

/obj/item/assembly/infra/verb/rotate_clockwise()
	set name = "Rotate Infrared Laser Clockwise"
	set category = "Object"
	set src in usr

	setDir(turn(dir, 90))

/***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ibeam"
	anchored = TRUE
	pass_flags = PASSTABLE|PASSGLASS|PASSGRILLE
	/// the next beam
	var/obj/effect/beam/i_beam/next
	/// the previous beam
	var/obj/effect/beam/i_beam/prev
	/// master assembly
	var/obj/item/assembly/infra/master
	/// are we visible?
	var/visible = FALSE
	/// beam segments left, excluding this one
	var/propagate = 0

/obj/effect/beam/i_beam/Initialize(mapload, _master, _propagate, _visible, _prev)
	. = ..()
	if(_propagate)
		src.propagate = min(100, _propagate)
	if(_master)
		src.master = _master
	if(_visible)
		visible = _visible
	if(_prev)
		prev = _prev
	invisibility = visible? 0 : 101

/obj/effect/beam/i_beam/Destroy()
	master = null
	if(next)
		if(!QDELETED(next))
			qdel(next)
		next = null
	if(prev)
		if(prev.next == src)
			prev.next = null
	return ..()

/**
 * Both handles beam propagation, and triggering if the beam suddenly finds itself on an dense atom.
 */
/obj/effect/beam/i_beam/proc/Propagate()
	propagate = min(100, propagate)
	if(next)
		if(!QDELETED(next))
			qdel(next)
		next = null
	if(!loc || !master)
		if(!QDELETED(src))
			qdel(src)
		return
	if(propagate <= 0)
		return
	if(!next)
		// spread
		var/obj/effect/beam/i_beam/I = new type(loc, master, propagate - 1, visible, src)
		I.density = TRUE
		I.setDir(dir)
		step(I, I.dir)
		// did it work?
		if(QDELETED(I))
			// nope
			return
		else
			next = I
			next.density = FALSE
			next.Propagate()

/obj/effect/beam/i_beam/proc/Refresh()
	if(!next)
		if(propagate > 0)
			Propagate()
		return
	// propagate vis and force rest to checks
	invisibility = visible? 0 : 101
	if(next)
		next.visible = visible
		next.Refresh()

/obj/effect/beam/i_beam/proc/SetVisible(new_vis)
	visible = new_vis
	Refresh()

/obj/effect/beam/i_beam/proc/Trigger(atom/A)
	if(master)
		master.trigger_beam()
	qdel(src)

/obj/effect/beam/i_beam/Bump(atom/movable/AM)
	. = ..()
	qdel(src)

// only useful during Propagate() since density is TRUE there.
/obj/effect/beam/i_beam/Bumped(atom/movable/AM)
	. = ..()
	Trigger(AM)

// we need to refactor this at some point holy shit, infrared grids are so awful right now.
/obj/effect/beam/i_beam/Crossed(atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal())
		return
	if(istype(AM, /obj/effect/beam))
		return
	if(isobserver(AM))
		return
	Trigger(AM)
