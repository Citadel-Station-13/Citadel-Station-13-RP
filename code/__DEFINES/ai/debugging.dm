//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/// Enable debugging mode. This enables the AI debug interface, but will generally cause a small bit of overhead/lag.
#define AI_DEBUGGING

#ifdef AI_DEBUGGING
	#define AI_DEBUGGING_ENABLED TRUE
#else
	#define AI_DEBUGGING_ENABLED FALSE
#endif
