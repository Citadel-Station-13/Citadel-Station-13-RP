/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/list/code = list()
	var/list/lastattempt = list()
	var/attempts = 10
	var/codelen = 4
	locked = 1

/obj/structure/closet/crate/secure/loot/Initialize(mapload)
	. = ..()
	var/list/digits = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")

	for(var/i in 1 to codelen)
		code += pick(digits)
		digits -= code[code.len]

	generate_loot()

/obj/structure/closet/crate/secure/loot/proc/generate_loot()
	var/datum/prototype/loot_table/table = SSrepository.fetch(/datum/prototype/loot_table/abandoned_crate)
	table.instantiate(src, 1)

/obj/structure/closet/crate/secure/loot/togglelock(mob/user as mob)
	if(!locked)
		return

	to_chat(user, "<span class='notice'>The crate is locked with a Deca-code lock.</span>")
	var/input = input(usr, "Enter [codelen] digits. All digits must be unique.", "Deca-Code Lock", "") as text
	if(!Adjacent(user))
		return
	var/list/sanitised = list()
	var/sanitycheck = 1
	for(var/i=1,i<=length(input),i++) //put the guess into a list
		sanitised += text2num(copytext(input,i,i+1))
	for(var/i=1,i<=(length(input)-1),i++) //compare each digit in the guess to all those following it
		for(var/j=(i+1),j<=length(input),j++)
			if(sanitised[i] == sanitised[j])
				sanitycheck = null //if a digit is repeated, reject the input

	if(input == null || sanitycheck == null || length(input) != codelen)
		to_chat(user, "<span class='notice'>You leave the crate alone.</span>")
	else if(check_input(input))
		to_chat(user, "<span class='notice'>The crate unlocks!</span>")
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		set_locked(0)
	else
		visible_message("<span class='warning'>A red light on \the [src]'s control panel flashes briefly.</span>")
		attempts--
		if (attempts == 0)
			to_chat(user, "<span class='danger'>The crate's anti-tamper system activates!</span>")
			var/turf/T = get_turf(src.loc)
			explosion(T, 0, 0, 1, 2)
			qdel(src)

/obj/structure/closet/crate/secure/loot/emag_act(var/remaining_charges, var/mob/user)
	if (locked)
		to_chat(user, "<span class='notice'>The crate unlocks!</span>")
		locked = 0

/obj/structure/closet/crate/secure/loot/proc/check_input(var/input)
	if(length(input) != codelen)
		return 0

	. = 1
	lastattempt.Cut()
	for(var/i in 1 to codelen)
		var/guesschar = copytext(input, i, i+1)
		lastattempt += guesschar
		if(guesschar != code[i])
			. = 0

/obj/structure/closet/crate/secure/loot/attackby(obj/item/W as obj, mob/user as mob)
	if(locked)
		if (istype(W, /obj/item/multitool)) // Greetings Urist McProfessor, how about a nice game of cows and bulls?
			to_chat(user, "<span class='notice'>DECA-CODE LOCK ANALYSIS:</span>")
			if (attempts == 1)
				to_chat(user, "<span class='warning'>* Anti-Tamper system will activate on the next failed access attempt.</span>")
			else
				to_chat(user, "<span class='notice'>* Anti-Tamper system will activate after [src.attempts] failed access attempts.</span>")
			if(lastattempt.len)
				var/bulls = 0
				var/cows = 0

				var/list/code_contents = code.Copy()
				for(var/i in 1 to codelen)
					if(lastattempt[i] == code[i])
						++bulls
					else if(lastattempt[i] in code_contents)
						++cows
					code_contents -= lastattempt[i]
				var/previousattempt = null //convert back to string for readback
				for(var/i in 1 to codelen)
					previousattempt = addtext(previousattempt, lastattempt[i])
				to_chat(user, "<span class='notice'>Last code attempt, [previousattempt], had [bulls] correct digits at correct positions and [cows] correct digits at incorrect positions.</span>")
			return
	..()
