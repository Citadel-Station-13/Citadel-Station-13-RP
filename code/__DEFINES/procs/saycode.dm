//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/// works as long as can see
#define SAYCODE_TYPE_VISIBLE 1
/// works as long as can hear
#define SAYCODE_TYPE_AUDIBLE 2
/// works as long as conscious
#define SAYCODE_TYPE_CONSCIOUS 3
/// works as long as alive
#define SAYCODE_TYPE_LIVING 4
/// it just works
#define SAYCODE_TYPE_ALWAYS 5
/// special
///
/// * runtime / stack traces if used in actual saycode
/// * used in emotes for automatically generating both visible and audible messages
#define SAYCODE_TYPE_AUTO 6
