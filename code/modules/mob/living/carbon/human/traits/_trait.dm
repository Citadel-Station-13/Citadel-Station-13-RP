/datum/trait
	var/name
	var/desc = "Contact a developer if you see this trait."

	/// Path of the group this trait is affiliated with in TGUI
	/// If unspecified, create a group named after this trait
	/// where this trait is the only member
	var/group = null

	/// If this trait is affiliated with a group, use a shorter name for it in the group UI
	/// Name must still be set (it's used on the overall trait summary page)
	/// For instance, Autohiss (Tajaran) becomes Tajaran
	var/group_short_name = null

	/// String key for sorting this trait in the UI
	/// If this trait creates its own group (group = null), then this is the sort key of
	/// the created group.
	var/sort_key
	/// Extra IC information about this trait that gets placed within the confidential flap of ID cards
	var/extra_id_info
	/// Whether or not this trait can have extra info opted out of
	var/extra_id_info_optional = TRUE

	/// 0 is neutral, negative cost means negative, positive cost means positive.
	var/cost = 0
	/// A list to apply to the custom species vars.
	var/list/var_changes
	/// Store a list of paths of traits to exclude, but done automatically if they change the same vars.
	var/list/excludes
	/// A list of species that CAN take this trait, use this if only a few species can use it. -shark
	var/list/allowed_species
	/// A list of species that CANNOT take this trait
	var/list/excluded_species
	/// Trait only available for custom species.
	var/custom_only = TRUE

	/// If TRUE, show this trait even if it is forbidden.
	/// We use this to blacklist species-level customization that most users would have genuinely no reason to care about.
	var/show_when_forbidden = TRUE

	/// list of TRAIT_*'s to apply, using QUIRK_TRAIT
	var/list/traits

/// Proc can be overridden lower to include special changes, make sure to call up though for the vars changes
/datum/trait/proc/apply(datum/species/S, mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)

	if(istype(H, /mob/observer))
		return

	for(var/trait in traits)
		ADD_TRAIT(H, trait, QUIRK_TRAIT)

	// todo: why does this depend on species? screw you, this is awful
	ASSERT(S)

	// todo: **WHY**?
	if(var_changes)
		for(var/V in var_changes)
			S.vars[V] = var_changes[V]

//Similar to the above, but for removing. Probably won't be called often/ever.
/datum/trait/proc/remove(datum/species/S)
	ASSERT(S)
	return
