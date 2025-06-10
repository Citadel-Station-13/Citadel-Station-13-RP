//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//? damage types

//* direct damage types; maps to most systems in the game *//

#define DAMAGE_TYPE_BRUTE "brute"
#define DAMAGE_TYPE_BURN "burn"

//* special damage types; only relevant for certain biologies *//
//* most of these will be reworked in brainmed update         *//

/// body toxins / systems instability
#define DAMAGE_TYPE_TOX "tox"
/// oxygen deprivation
#define DAMAGE_TYPE_OXY "oxy"
/// dna damage
#define DAMAGE_TYPE_CLONE "clone"
/// pain
/// todo: stamina vs pain
#define DAMAGE_TYPE_HALLOSS "halloss"

//* special hybrid types; processed specially depending on type *//

/// bioacid ; toxins for organics, acid for synthetics
/// todo: better hybrid type handling
#define DAMAGE_TYPE_BIOACID "bioacid"
/// searing; half brute, half bur
/// todo: better hybrid type handling
#define DAMAGE_TYPE_SEARING "searing"

/proc/damage_type_to_visualized_color(damage_type)
	var/alist/lookup = alist(
		DAMAGE_TYPE_BRUTE = "#ff0000",
		DAMAGE_TYPE_BURN = "#ffff00",
		DAMAGE_TYPE_TOX = "#00ff00",
		DAMAGE_TYPE_OXY = "#0000ff",
		DAMAGE_TYPE_CLONE = "#ff00ff",
		DAMAGE_TYPE_HALLOSS = "#00ffff",
	)
	return lookup[damage_type]

//? damage_mode bitfield ?//

/// sharp weapons like knives, spears, etc
#define DAMAGE_MODE_SHARP (1<<0)
/// weapons with an edge, like knives, being used as such. without this, sharp = pierce
#define DAMAGE_MODE_EDGE (1<<1)
/// pulse lasers, etc, basically blows a crater
#define DAMAGE_MODE_ABLATING (1<<2)
/// specifically highly-piercing weapons like bullets, even worse than sharp.
///
/// * for pierce-ness checks, 'sharp withot edge' is fine. having this flag is pretty much second tier of piercing.
#define DAMAGE_MODE_PIERCE (1<<3)
/// messy, shredded wounds instead of a clean cut / pierce. strong.
#define DAMAGE_MODE_SHRED (1<<4)
/// disallow bone breaks, ablation, etc; used for gradual sources like depressurization
#define DAMAGE_MODE_GRADUAL (1<<5)
/// coming from internal; used to flag that something isn't coming through the skin. certain defenses don't work if this is set.
#define DAMAGE_MODE_INTERNAL (1<<6)
/// if zone doesn't exist / etc, allow redirection
#define DAMAGE_MODE_REDIRECT (1<<7)
/// temporary - re-evaluate when health is reworked. prevents damage from overflowing caps.
#define DAMAGE_MODE_NO_OVERFLOW (1<<8)

/// config: request armor / shieldcalls apply randomization.
/// * disabled by default by not having this be an opt-out rather than opt-in flag.
/// * disabled by default so non-determinism is controlled instead of innate.
#define DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION (1<<22)
/// config: request armor damping of dangerous damage modes like pierce / shred
/// * disabled by default by not having this be an opt-out rather than opt-in flag.
/// * disabled by default so non-determinism is controlled instead of innate.
#define DAMAGE_MODE_REQUEST_ARMOR_BLUNTING (1<<23)

#define DAMAGE_MODES_BLUNTED_BY_ARMOR ( \
	DAMAGE_MODE_SHARP | \
	DAMAGE_MODE_EDGE | \
	DAMAGE_MODE_ABLATING | \
	DAMAGE_MODE_PIERCE | \
	DAMAGE_MODE_SHRED \
)
