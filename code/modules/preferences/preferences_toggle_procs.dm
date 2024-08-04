
// todo: god fucking damnit why is this in this file?

/mob/living/carbon/human/verb/toggle_pain_msg()
	set name = "Toggle Pain Messages"
	set category = "OOC"
	set desc = "Toggles pain messages."
	set src = usr

	if(painmsg)
		src.painmsg = 0
	else
		src.painmsg = 1
	to_chat(src,"You will [ (painmsg) ? "now" : "no longer"] see your own pain messages.")

/mob/living/carbon/human/verb/acting()
	set name = "Feign Impairment"
	set category = VERB_CATEGORY_IC
	set desc = "Allows user to manually enable drunkenness, stutter, jitter, etc."
	set src = usr

	var/list/choices = list("Drunkenness", "Stuttering", "Jittering")
	if(src.slurring >= 10 || src.stuttering >= 10 || src.jitteriness >= 100)
		var/disable = alert(src, "Stop performing impairment? (Do NOT abuse this)", "Impairments", "Yes", "No")
		if(disable == "Yes")
			acting_expiry()
			return

	var/impairment = input(src, "Select an impairment to perform:", "Impairments") as null|anything in choices
	if(!impairment)
		return
	var/duration = input(src,"Choose a duration to perform [impairment]. (1 - 60 seconds)","Duration in seconds",25) as num|null
	if(!isnum(duration))
		return
	if(duration > 60 && !check_rights(R_EVENT, 0)) // admins can do as they please
		to_chat(src, "Please choose a duration in seconds between 1 to 60.")
		return
	if(duration >= 1000) // unreachable code for anyone but admins who have set the number very high, logging for my sanity
		message_admins("[src] has set their [impairment] to [duration] via Feign Impairment.")
	if(duration >= 2000)
		to_chat(src, "Please choose a duration less than 2000.")
		return
	if(impairment == "Drunkenness")
		slurring = duration
	if(impairment == "Stuttering")
		stuttering = duration
	if(impairment == "Jittering")
		make_jittery(duration + 100)

	if(duration)
		addtimer(CALLBACK(src, PROC_REF(acting_expiry)), duration SECONDS)
		var/aduration = duration SECONDS / 10
		to_chat(src,"You will now performatively act as if you were experiencing [impairment] for [aduration] seconds. (Do NOT abuse this)")
	feedback_add_details("admin_verb","actimpaired") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/mob/living/carbon/human/proc/acting_expiry()
	to_chat(src,"You are no longer acting impaired.") // tick down from 1 to allow the effects to end 'naturally'
	slurring = 1
	stuttering = 1
	jitteriness = 1
