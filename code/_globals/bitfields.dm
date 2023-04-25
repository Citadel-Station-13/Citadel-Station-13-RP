GLOBAL_LIST_INIT(bitfields, generate_bitfields())

/datum/bitfield
	/// An associative list of the readable flag and its true value
	var/list/flags

/datum/bitfield/single
	/// The variable name that contains the bitfield
	var/variable

/datum/bitfield/multi
	/// our variable names
	var/list/variables

/// Turns /datum/bitfield subtypes into a list for use in debugging
/proc/generate_bitfields()
	var/list/bitfields = list()
	for (var/_bitfield in subtypesof(/datum/bitfield/single))
		var/datum/bitfield/single/bitfield = new _bitfield
		bitfields[bitfield.variable] = bitfield.flags
	for (var/_bitfield in subtypesof(/datum/bitfield/multi))
		var/datum/bitfield/multi/bitfield = new _bitfield
		for(var/n in bitfield.variables)
			bitfields[n] = bitfield.flags
	// sue me i haven't slept in 18 hours
	// tl;dr convert these into DEFINE_BITFIELD's later
#define FLAG(flag) "[#flag]" = flag
	return bitfields + list(
	"appearance_flags" = list(
		"LONG_GLIDE" = LONG_GLIDE,
		"RESET_COLOR" = RESET_COLOR,
		"RESET_ALPHA" = RESET_ALPHA,
		"RESET_TRANSFORM" = RESET_TRANSFORM,
		"NO_CLIENT_COLOR" = NO_CLIENT_COLOR,
		"KEEP_TOGETHER" = KEEP_TOGETHER,
		"KEEP_APART" = KEEP_APART,
		"PLANE_MASTER" = PLANE_MASTER,
		"TILE_BOUND" = TILE_BOUND,
		"PIXEL_SCALE" = PIXEL_SCALE,
		"PASS_MOUSE" = PASS_MOUSE,
		"TILE_MOVER" = TILE_MOVER
		),
	"mob_class" = list(
		FLAG(MOB_CLASS_PLANT),
		FLAG(MOB_CLASS_ANIMAL),
		FLAG(MOB_CLASS_HUMANOID),
		FLAG(MOB_CLASS_SYNTHETIC),
		FLAG(MOB_CLASS_SLIME),
		FLAG(MOB_CLASS_ABERRATION),
		FLAG(MOB_CLASS_DEMONIC),
		FLAG(MOB_CLASS_BOSS),
		FLAG(MOB_CLASS_ILLUSION),
		FLAG(MOB_CLASS_PHOTONIC)
		),
	"reagents_holder_flags" = list(
		"INJECTABLE" = INJECTABLE,
		"DRAWABLE" = DRAWABLE,
		"REFILLABLE" = REFILLABLE,
		"DRAINABLE" = DRAINABLE,
		"TRANSPARENT" = TRANSPARENT,
		"AMOUNT_VISIBLE" = AMOUNT_VISIBLE,
		"NO_REACT" = NO_REACT,
		),
	"sight" = list(
		"SEE_INFRA" = SEE_INFRA,
		"SEE_SELF" = SEE_SELF,
		"SEE_MOBS" = SEE_MOBS,
		"SEE_OBJS" = SEE_OBJS,
		"SEE_TURFS" = SEE_TURFS,
		"SEE_PIXELS" = SEE_PIXELS,
		"SEE_THRU" = SEE_THRU,
		"SEE_BLACKNESS" = SEE_BLACKNESS,
		"BLIND" = BLIND
		),

	)

#undef FLAG
