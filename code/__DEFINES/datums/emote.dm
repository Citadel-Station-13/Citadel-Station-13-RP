//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* emote invocation output *//

/// no emote found
#define EMOTE_INVOKE_INVALID 0
/// the emote finished
#define EMOTE_INVOKE_FINISHED 1
/// the emote errored
#define EMOTE_INVOKE_ERRORED 2
/// the emote is running
#define EMOTE_INVOKE_SLEEPING 3

//* emote_class's ; determines who can do what emote *//
//* -- This is broadphase, effectively.              *//
//  todo: DEFINE_BITFIELD_NEW

/// require body
/// * so no brains
#define EMOTE_CLASS_IS_BODY (1<<0)
/// requires humanoid body
/// * so no four legged animals
#define EMOTE_CLASS_IS_HUMANOID (1<<1)

GLOBAL_REAL_LIST(emote_class_bit_descriptors) = list(
	"requires body",
	"requires humanoid",
)

//* emote_require's ; more freeform classes that should invoke procs *//
//* -- This is narrowphase and doesn't exclude emotes from listings, *//
//*    generally.                                                    *//
//  todo: DEFINE_BITFIELD_NEW

/// has a speaker of some kind
/// * implies `EMOTE_REQUIRE_VOCALIZATION`
#define EMOTE_REQUIRE_SYNTHETIC_SPEAKER (1<<0)
/// can talk coherent words
/// * implies `EMOTE_REQUIRE_VOCALIZATION`
#define EMOTE_REQUIRE_COHERENT_SPEECH (1<<1)
/// has a free hand
/// * does not imply the actor isn't stunned
#define EMOTE_REQUIRE_FREE_HAND (1<<2)
/// require being able to make sounds at all
#define EMOTE_REQUIRE_VOCALIZATION (1<<3)

GLOBAL_REAL_LIST(emote_require_bit_descriptors) = list(
	"requires synthetic speaker",
	"requires coherent speech",
	"requires free hand",
	"requires vocalization",
)

//* emote arbitrary key-value store key's *//

/// the original parameter string passed in.
#define EMOTE_PARAMETER_KEY_ORIGINAL "original"
/// the target. hard reference. don't hold onto it for too long.
#define EMOTE_PARAMETER_KEY_TARGET "target"
/// for basic emotes; custom parameter, as tokens
#define EMOTE_PARAMETER_KEY_CUSTOM_TOKENS "custom-tokens"
/// resolved target as /atom ref
#define EMOTE_PARAMETER_KEY_TARGET_RESOLVED "target-resolved"
