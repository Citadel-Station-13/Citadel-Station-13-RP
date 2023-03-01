/obj/item/organ/external
	name = "external"
	max_damage = 0
	min_broken_damage = 30
	dir = SOUTH
	organ_tag = "limb"
	decays = FALSE

//! ## STRINGS
	/// Fracture description if any.
	var/broken_description
	/// Modifier used for generating the on-mob damage overlay for this limb.
	var/damage_state = "00"


//! ## DAMAGE VARS
	/// Multiplier for incoming brute damage.
	var/brute_mod = 1
	/// As above for burn.
	var/burn_mod = 1
	/// EMP damage multiplier
	var/emp_mod = 1
	/// Actual current brute damage.
	var/brute_dam = 0
	/// Actual current burn damage.
	var/burn_dam = 0
	/// Used in healing/processing calculations.
	var/last_dam = -1

	/// If damage done to this organ spreads to connected organs.
	var/spread_dam = FALSE
	/// If a needle has a chance to fail to penetrate.
	var/thick_skin = FALSE
	/// If a prosthetic limb is emagged, it will detonate when it fails.
	var/sabotaged = FALSE

	/// Chance of missing.
	var/base_miss_chance = 20


//! ## APPEARANCE VARS
	/// Snowflake warning, reee. Used for slime limbs.
	var/nonsolid
	/// Also for slimes. Used for transparent limbs.
	var/transparent = 0
	/// Icon state base.
	var/icon_name = null
	/// Part flag
	var/body_part = null
	/// Used in mob overlay layering calculations.
	var/icon_position = 0
	/// Used when caching robolimb icons.
	var/model
	/// Used to force override of species-specific limb icons (for prosthetics). Also used for any limbs chopped from a simple mob, and then attached to humans.
	var/force_icon
	/// Used to force the override of the icon-key generated using the species. Must be used in tandem with the above.
	var/force_icon_key
	/// Cached icon for use in mob overlays.
	var/icon/mob_icon
	/// Whether or not the icon state appends a gender.
	var/gendered_icon = FALSE
	/// Skin tone.
	var/s_tone
	/// Skin colour
	var/list/s_col
	/// How the skin colour is applied.
	var/s_col_blend = ICON_ADD
	/// Hair colour
	var/list/h_col
	/// Icon blend for body hair if any.
	var/body_hair
	var/mob/living/applied_pressure
	/// Markings (body_markings) to apply to the icon
	var/list/markings = list()


//! ## STRUCTURAL VARS
	/// Master-limb.
	var/obj/item/organ/external/parent
	/// Sub-limbs.
	var/list/children = list()
	/// Internal organs of this body part
	var/list/internal_organs = list()
	/// Currently implanted objects.
	var/list/implants = list()
	/// Relative size of the organ.
	var/organ_rel_size = 25
	var/atom/movable/splinted


//! ## WOUND VARS
	/// How often wounds should be updated, a higher number means less often
	var/wound_update_accuracy = 1
	/// Wound datum list.
	var/list/wounds = list()
	/// Number of wounds, which is NOT wounds.len!
	var/number_wounds = 0


//! ## JOINT/STATE VARS
	/// It would be more appropriate if these two were named "affects_grasp" and "affects_stand" at this point
	var/can_grasp
	/// Modifies stance tally/ability to stand.
	var/can_stand
	/// Scarred/burned beyond recognition.
	var/disfigured = FALSE
	/// Impossible to amputate.
	var/cannot_amputate
	/// Impossible to fracture.
	var/cannot_break
	/// Impossible to gib, distinct from amputation.
	var/cannot_gib
	/// Descriptive string used in dislocation.
	var/joint = "joint"
	/// Descriptive string used in amputation.
	var/amputation_point
	/// If you target a joint, you can dislocate the limb, impairing it's usefulness and causing pain.
	var/dislocated = FALSE
	/// Needs to be opened with a saw to access the organs.
	var/encased


//! ## SURGERY VARS
	var/open   = FALSE
	var/stage  = FALSE
	var/cavity = FALSE

	/// Surgical repair stage for burn.
	var/burn_stage = 0
	/// Surgical repair stage for brute.
	var/brute_stage = 0

	/// HUD element variable, see organ_icon.dm get_damage_hud_image()
	var/image/hud_damage_image

	/// makes this dumb as fuck mechanic slightly less awful - records queued syringe infections instead of a spawn()
	var/syringe_infection_queued
