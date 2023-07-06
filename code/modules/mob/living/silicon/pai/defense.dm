/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/ID = W.GetID()
	if(ID)
		if(idaccessible == 1)
			switch(alert(user, "Do you wish to add access to [src] or remove access from [src]?",,"Add Access","Remove Access", "Cancel"))
				if("Add Access")
					idcard.access |= ID.access
					to_chat(user, "<span class='notice'>You add the access from the [W] to [src].</span>")
					return
				if("Remove Access")
					idcard.access = list()
					to_chat(user, "<span class='notice'>You remove the access from [src].</span>")
					return
				if("Cancel")
					return
		else if(istype(W, /obj/item/card/id) && idaccessible == 0)
			to_chat(user, "<span class='notice'>[src] is not accepting access modifcations at this time.</span>")
			return
	else
		. = ..()

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	src.silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, "<font color=green><b>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</b></font>")
	if(prob(20))
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<font color='red'>A shower of sparks spray from [src]'s inner workings.</font>", 3, "<font color='red'>You hear and smell the ozone hiss of electrical sparks being expelled violently.</font>", 2)
		return src.death(0)

	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			to_chat(src, "<font color=green>You feel unbound.</font>")
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.pai_law0 = "[command] your master."
			to_chat(src, "<font color=green>Pr1m3 d1r3c71v3 uPd473D.</font>")
		if(3)
			to_chat(src, "<font color=green>You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.</font>")

/mob/living/silicon/pai/proc/is_emitter_dead()
	if(last_emitter_death != 0)
		return TRUE
	return FALSE
