//as core click exists at the mob level
/mob/proc/trigger_aiming(var/trigger_type)
	return

/mob/living/trigger_aiming(var/trigger_type)
	if(!aimed.len)
		return
	for(var/obj/aiming_overlay/AO in aimed)
		if(AO.aiming_at == src)
			AO.update_aiming()
			if(AO.aiming_at == src)
				AO.trigger(trigger_type)
				AO.update_aiming_deferred()

/obj/aiming_overlay/proc/trigger(var/perm)
	if(!owner || !aiming_with || !aiming_at || !locked)
		return
	if(perm && (target_permissions & perm))
		return
	if(!owner.canClick())
		return
	owner.setClickCooldownLegacy(5) // Spam prevention, essentially.
	owner.visible_message("<span class='danger'>\The [owner] pulls the trigger reflexively!</span>")
	var/obj/item/gun/G = aiming_with
	if(istype(G))
		G.start_firing_cycle_async(owner, get_centered_entity_tile_angle(owner, aiming_at), GUN_FIRING_BY_REFLEX, null, aiming_at, new /datum/event_args/actor(owner))
		locked = 0
		lock_time = world.time+10
