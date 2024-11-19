//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Saycode Packet Flags *//

/// sent from active player
///
/// * used by things like ghosts to filter out unwanted messages
#define SAYCODE_PACKET_CONSIDERED_PLAYER (1<<0)

//* Saycode Types *//

/// works as long as can see
#define SAYCODE_TYPE_VISIBLE (1<<0)
/// works as long as can hear
#define SAYCODE_TYPE_AUDIBLE (1<<1)
/// works as long as conscious
#define SAYCODE_TYPE_CONSCIOUS (1<<2)
/// works as long as alive
#define SAYCODE_TYPE_LIVING (1<<3)
/// it just works
#define SAYCODE_TYPE_ALWAYS (1<<4)

/// saycode type filters for generic listening objects
#define SAYCODE_TYPE_FILTER_FOR_OBJECT (ALL)
/// saycode type filters for living
#define SAYCODE_TYPE_FILTER_FOR_LIVING (ALL)
/// saycode type filters for observers
#define SAYCODE_TYPE_FILTER_FOR_OBSERVER (ALL)

//* Saycode Origins *//

/// from say()
#define SAYCODE_ORIGIN_SAY (1<<0)
/// from whisper()
#define SAYCODE_ORIGIN_WHISPER (1<<1)
/// from me()
#define SAYCODE_ORIGIN_EMOTE (1<<2)
/// from subtle()
#define SAYCODE_ORIGIN_SUBTLE (1<<3)
/// from subtler()
#define SAYCODE_ORIGIN_SUBTLER (1<<4)

/// special: pass directly to emote system invocation
#define SAYCODE_ORIGIN_REDIRECT_TO_EMOTE (1<<23)

/// all of these are 'redirect' origins
#define SAYCODE_ORIGINS_FOR_REDIRECT (SAYCODE_ORIGIN_REDIRECT_TO_EMOTE)

//* Saycode Decorators (speech bubbles use this) *//

/// is a statement
#define SAYCODE_DECORATOR_STATEMENT "say"
/// is a question
#define SAYCODE_DECORATOR_QUESTION "ask"
/// is exclaiming
#define SAYCODE_DECORATOR_EXCLAIM "exclaim"
/// is yelling
#define SAYCODE_DECORATOR_YELL "yell"
