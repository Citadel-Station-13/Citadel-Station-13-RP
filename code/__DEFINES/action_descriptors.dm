//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

//* --------------------------------- What is this? ------------------------------------   *//
//* Many actions should emit a message that the user is doing something.                   *//
//* This is needed to make, well, the world more exciting.                                 *//
//* But, alas, we live in the world of open source, where metagaming runs wild!            *//
//* Thus this file is born - this is a standard set of message-emit-formatters             *//
//* that lessens the ability to tell what specifically is going on from the message alone. *//
//*                                                                                        *//
//* Furthermore, these are procs because some of them may have logic.                      *//
//* The proc variants are in __HELPERS/action_descriptors.dm                               *//

#define ACTION_DESCRIPTOR_FOR_EXAMINE_FMTSTR(ENTITY_TAG, TARGET_TAG) \
	SPAN_TINYNOTICE("<b>%%[ENTITY_TAG]%%</b> looks at %%[TARGET_TAG]%%.")
#define ACTION_DESCRIPTOR_FOR_EXAMINE_FMTSTR_CONST(ENTITY_TAG, TARGET_TAG) \
	SPAN_TINYNOTICE_CONST("<b>%%" + ENTITY_TAG + "%%</b> looks at %%" + TARGET_TAG + "%%.")
