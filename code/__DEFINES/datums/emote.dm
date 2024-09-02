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

#warn impl all
