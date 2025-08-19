/obj/item/rig_module/basic/pat_module

/obj/item/rig_module/basic/pat_module/proc/boop(var/mob/living/carbon/human/user,var/turf/To,var/turf/Tn)
	if(!istype(user) || !istype(To) || !istype(Tn))
		deactivate() //They were picked up or something, or put themselves in a locker, who knows. Just turn off.
		return

	var/direction = user.dir
	var/turf/current = Tn
	for(var/i = 0; i < range; i++)
		current = get_step(current,direction)
		if(!current) break

		var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in current
		if(!A || !A.density) continue

		if(A.allowed(user) && A.operable())
			A.open()

/obj/item/rig_module/basic/pat_module/engage()
	var/mob/living/carbon/human/H = holder.wearer
	if(!istype(H))
		return 0

	var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in get_step(H,H.dir)

	//Okay, we either found an airlock or we're about to give up.
	if(!A || !A.density || !A.can_open() || !..())
		to_chat(H,"<span class='warning'>Unable to comply! Energy too low, or not facing a working airlock!</span>")
		return 0

	H.visible_message("<span class='warning'>[H] begins overriding the airlock!</span>","<span class='notice'>You begin overriding the airlock!</span>")
	if(do_after(H,6 SECONDS,A) && A.density)
		A.open()

	var/username = FindNameFromID(H) || "Unknown"
	var/message = "[username] has overridden [A] (airlock) in \the [get_area(A)] at [A.x],[A.y],[A.z] with \the [src]."
	GLOB.global_announcer.autosay(message, "Security Subsystem", "Command")
	GLOB.global_announcer.autosay(message, "Security Subsystem", "Security")
	return 1
