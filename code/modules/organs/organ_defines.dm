var/list/organ_cache = list()

/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'


//! ## STRINGS VARS
	/// Unique identifier.
	var/organ_tag = "organ"
	/// The organ holding this object.
	var/parent_organ = BP_TORSO


//! STATUS VARS
	/// Various status flags
	var/status = 0
	/// Lose a vital limb, die immediately.
	var/vital
	/// Current damage to the organ
	var/damage = 0
	/// What kind of robotic organ, if valid.
	var/robotic = 0
	/// If true, this organ can't feel pain.
	var/stapled_nerves = FALSE


//! ##REFERENCE VARS
	/// Current mob owning the organ.
	var/mob/living/carbon/human/owner
	/// Transplant match data.
	var/list/transplant_data
	/// Trauma data for forensics.
	var/list/autopsy_data = list()
	/// Traces of chemicals in the organ.
	var/list/trace_chemicals = list()
	/// Original DNA.
	var/datum/dna/dna
	/// Original species.
	var/datum/species/species
	var/s_base


//! ## DAMAGE VARS
	/// Damage before considered bruised
	var/min_bruised_damage = 10
	/// Damage before becoming broken
	var/min_broken_damage = 30
	/// Damage cap
	var/max_damage
	/// Can this organ reject?
	var/can_reject = TRUE
	/// Is this organ already being rejected?
	var/rejecting
	/// Can this organ decay at all?
	var/decays = TRUE
	/// decay rate
	var/decay_rate = ORGAN_DECAY_PER_SECOND_DEFAULT

//! ## LANGUAGE VARS - For organs that assist with certain languages.
	var/list/will_assist_languages = list()
	var/list/datum/language/assists_languages = list()


//! ## VERB VARS
	/// Verbs added by the organ when present in the body.
	var/list/organ_verbs
	/// Is the parent supposed to be organic, robotic, assisted?
	var/list/target_parent_classes = list()
	/// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.
	var/forgiving_class = TRUE

	/// Can we butcher this organ.
	var/butcherable = TRUE
	/// What does butchering, if possible, make?
	var/meat_type
