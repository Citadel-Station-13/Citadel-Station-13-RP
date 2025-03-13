//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// just a bunch of de/serialization helpers to reduce copypaste
// these are meant to add durability to known-migrated systems,
// as errors in expected vs actual value in those systems can
// generally be treated as a mistake somewhere on the part
// of whoever is updating them.

//* Number *//

#define OPTIONALLY_DESERIALIZE_NUMBER(FROM, INTO) \
	if(!isnull(FROM)) { \
		if(isnum(FROM)) { \
			INTO = FROM; \
		} \
		else { \
			stack_trace(#INTO + ": expected number or undefined, got " + text(FROM)); \
		} \
	}

#define REQUIRED_DESERIALIZE_NUMBER(FROM, INTO) \
	if(isnum(FROM)) { \
		INTO = FROM; \
	} \
	else { \
		stack_trace(#INTO + ": expected number, got " + text(FROM)); \
	} \

//* List - Naive *//

#define OPTIONALLY_DESERIALIZE_LIST(FROM, INTO, OTHERWISE) \
	if(!isnull(FROM)) { \
		if(islist(FROM)) { \
			INTO = FROM; \
		} \
		else { \
			stack_trace(#INTO + ": expected number or undefined, got " + text(FROM)); \
		} \
	} \
	else { \
		INTO = OTHERWISE; \
	}

#define REQUIRED_DESERIALIZE_LIST(FROM, INTO) \
	if(islist(FROM)) { \
		INTO = FROM; \
	} \
	else { \
		stack_trace(#INTO + ": expected list, got " + text(FROM)); \
	} \
