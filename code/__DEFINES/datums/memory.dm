//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* memory content types *//

/// content: raw text
#define MEMORY_CONTENT_TYPE_TEXT "text"
/// context: raw html string
#define MEMORY_CONTENT_TYPE_HTML "html"

//* memory priorities *//

/// stuff like bank accouts, etc; legacy because it's all one blob rn
#define MEMORY_PRIORITY_LEGACY_JOIN_DETAILS -1
#define MEMORY_PRIORITY_DEFAULT 0

//* memory classes *//

/// general
#define MEMORY_CLASS_GENERIC (1<<0)

DEFINE_BITFIELD_NEW("memory-class", list(
	/datum/memory = list(
		NAMEOF_TYPE(/datum/memory, memory_class),
	),
), list(
	BITFIELD_NEW("Generic", MEMORY_CLASS_GENERIC),
))

//* memory constants *//

/// max non-unicode-aware length() player memories can be
#define MEMORY_MAX_USER_LENGTH 8192
/// max linebreaks player memories can be
#define MEMORY_MAX_USER_LINEBREAKS 12
