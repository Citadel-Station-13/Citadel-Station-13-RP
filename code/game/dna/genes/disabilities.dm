/**
 *! DISABILITY GENES
 *
 * These activate either a mutation, disability, or sdisability.
 *
 * Gene is always activated.
 */
/datum/gene/disability
	name="DISABILITY"

	/// Mutation to give (or 0)
	var/mutation=0

	/// Disability to give (or 0)
	var/disability=0

	/// SDisability to give (or 0)
	var/sdisability=0

	/// Activation message
	var/activation_message=""

	/// Yay, you're no longer growing 3 arms
	var/deactivation_message=""

/datum/gene/disability/can_activate(mob/M, flags)
	return TRUE // Always set!

/datum/gene/disability/activate(mob/M, connected, flags)
	if(mutation && !(mutation in M.mutations))
		M.mutations.Add(mutation)
	if(disability)
		M.disabilities|=disability
	if(sdisability)
		M.sdisabilities|=sdisability
	if(activation_message)
		to_chat(M, SPAN_WARNING("[activation_message]"))
	else
		testing("[name] has no activation message.")

/datum/gene/disability/deactivate(mob/M, connected, flags)
	if(mutation && (mutation in M.mutations))
		M.mutations.Remove(mutation)
	if(disability)
		M.disabilities &= (~disability)
	if(sdisability)
		M.sdisabilities &= (~sdisability)
	if(deactivation_message)
		to_chat(M, SPAN_WARNING("[deactivation_message]"))
	else
		testing("[name] has no deactivation message.")

/// Note: Doesn't seem to do squat, at the moment.
/datum/gene/disability/hallucinate
	name = "Hallucinate"
	activation_message = "Your mind says 'Hello'."
	mutation = mHallucination

/datum/gene/disability/hallucinate/New()
	block = HALLUCINATIONBLOCK

/datum/gene/disability/epilepsy
	name = "Epilepsy"
	activation_message = "You get a headache."
	disability = EPILEPSY

/datum/gene/disability/epilepsy/New()
	block = HEADACHEBLOCK

/datum/gene/disability/cough
	name = "Coughing"
	activation_message = "You start coughing."
	disability = COUGHING

/datum/gene/disability/cough/New()
	block = COUGHBLOCK

/datum/gene/disability/clumsy
	name = "Clumsiness"
	activation_message = "You feel lightheaded."
	mutation = CLUMSY

/datum/gene/disability/clumsy/New()
	block = CLUMSYBLOCK

/datum/gene/disability/tourettes
	name = "Tourettes"
	activation_message = "You twitch."
	disability = TOURETTES

/datum/gene/disability/tourettes/New()
	block = TWITCHBLOCK

/datum/gene/disability/nervousness
	name = "Nervousness"
	activation_message = "You feel nervous."
	disability = NERVOUS

/datum/gene/disability/nervousness/New()
	block = NERVOUSBLOCK

/datum/gene/disability/blindness
	name = "Blindness"
	activation_message = "You can't seem to see anything."
	sdisability = BLIND

/datum/gene/disability/blindness/New()
	block=BLINDBLOCK

/datum/gene/disability/deaf
	name = "Deafness"
	activation_message = "It's kinda quiet."
	sdisability = DEAF

/datum/gene/disability/deaf/New()
	block = DEAFBLOCK

/datum/gene/disability/deaf/activate(mob/M, connected, flags)
	..(M,connected,flags)
	M.ear_deaf = TRUE

/datum/gene/disability/nearsighted
	name = "Nearsightedness"
	activation_message = "Your eyes feel weird..."
	disability = NEARSIGHTED

/datum/gene/disability/nearsighted/New()
	block = GLASSESBLOCK
