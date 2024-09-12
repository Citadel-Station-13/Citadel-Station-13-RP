//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* emote_class's ; determines who can do what emote *//
//  todo: DEFINE_BITFIELD_NEW

/// all default emotes
#define EMOTE_CLASS_DEFAULT (1<<0)

//* emote_require's ; more freeform classes that should invoke procs *//
//  todo: DEFINE_BITFIELD_NEW

/// has a speaker of some kind
///
/// * implies the speaker isn't mute
#define EMOTE_REQUIRE_SYNTHETIC_SPEAKER (1<<0)
/// can talk coherent words
///
/// * implies the actor isn't mute
#define EMOTE_REQUIRE_COHERENT_SPEECH (1<<1)
/// has a usable hand
///
/// * does not imply the actor isn't stunned
#define EMOTE_REQUIRE_USABLE_HAND (1<<2)
/// has a body to act with
///
/// * so no brains
#define EMOTE_REQUIRE_BODY (1<<3)
/// require being able to make sounds at all
#define EMOTE_REQUIRE_VOCALIZATION (1<<4)

#warn impl all

//* emote arbitrary key-value store key's *//

/// the original parameter string passed in
#define EMOTE_PARAMETER_KEY_ORIGINAL "original"
#define EMOTE_PARAMETER_KEY_TARGET "target"
#define EMOTE_PARAMETER_KEY_CUSTOM "custom"
