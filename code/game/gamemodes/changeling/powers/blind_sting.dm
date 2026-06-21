/datum/power/changeling/blind_sting
	name = "Blind Sting"
	desc = "We silently sting a human, completely blinding them for a short time."
	enhancedtext = "Duration is extended."
	ability_icon_state = "ling_sting_blind"
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_blind_sting

/mob/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(20, TYPE_PROC_REF(/mob, changeling_blind_sting))
	if(!T)
		return 0
	add_attack_logs(src,T,"Blind sting (changeling)")
	to_chat(T, "<span class='danger'>Your eyes burn horrificly!</span>")
	var/duration = 300
	if(src.mind.changeling.recursive_enhancement)
		duration = duration + 150
		to_chat(src, "<span class='notice'>They will be deprived of sight for longer.</span>")
	T.apply_status_effect(/datum/status_effect/sight/blindness, duration)
	T.eye_blurry = duration * 1.2
	SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("Blind sting"))
	return 1
