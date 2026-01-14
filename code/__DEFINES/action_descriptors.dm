//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* --------------------------------- What is this? ------------------------------------   *//
//* Many actions should emit a message that the user is doing something.                   *//
//* This is needed to make, well, the world more exciting.                                 *//
//* But, alas, we live in the world of open source, where metagaming runs wild!            *//
//* Thus this file is born - this is a standard set of message-emit-formatters             *//
//* that lessens the ability to tell what specifically is going on from the message alone. *//

#define ACTION_DESCRIPTOR_FMT_FOR_EXAMINE(ENTITY_TAG, TARGET_TAG) \
	SPAN_TINYNOTICE("<b>%%" + ENTITY_TAG + "%%</b> looks at %%" + TARGET_TAG + "%%.")
/proc/action_descriptor_for_examine(entity, target)
	return SPAN_TINYNOTICE("<b>[entity]</b> looks at [target].")
