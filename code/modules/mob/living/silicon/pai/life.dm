/mob/living/silicon/pai/Life(seconds, times_fired)
	if((. = ..()))
		return

	if (src.stat == 2)
		return

	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf_or_move(src.loc)
			for (var/mob/M in viewers(T))
				M.show_message("<font color='red'>The data cable rapidly retracts back into its spool.</font>", 3, "<font color='red'>You hear a click and the sound of wire spooling rapidly.</font>", 2)
			playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

			qdel(src.cable)
			src.cable = null

	handle_regular_hud_updates()
	handle_vision()

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")

	handle_statuses()

	// heal more when "dead" to avoid being down for an incredibly long duration
	if(last_emitter_death != 0)
		heal_overall_damage(2 * emitter_health_regen)
		// after 20 seconds we can come back to life assuming our health is not negative
		if(last_emitter_death + 200 <= world.time && emitter_health > 0)
			last_emitter_death = 0
			visible_message("<span class='danger'>[src]'s holo-emitter flickers back to life!</span>")
	else
		heal_overall_damage(emitter_health_regen)

	if(health <= 0)
		death(null,"gives one shrill beep before falling lifeless.")

/mob/living/silicon/pai/update_health()
	if(status_flags & STATUS_GODMODE)
		health = 100
		emitter_health = emitter_max_health
		last_emitter_death = 0
		set_stat(CONSCIOUS)
	else
		emitter_health = emitter_max_health - (getBruteLoss() + getFireLoss())
		if(emitter_health <= 0)
			if(last_emitter_death == 0)
				close_up()
				last_emitter_death = world.time
				visible_message("<span class='danger'>[src]'s holo-emitter fizzles out!</span>")
