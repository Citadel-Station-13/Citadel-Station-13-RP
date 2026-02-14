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
//* The #define + string_format() variants are in __DEFINES/action_descriptors.dm          *//

/proc/action_descriptor_for_examine(entity, target)
	return SPAN_TINYNOTICE_CONST("<b>[entity]</b> looks at [target].")
