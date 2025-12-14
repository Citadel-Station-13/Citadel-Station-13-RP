//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//? lathe_type bitfield

#define LATHE_TYPE_AUTOLATHE (1<<0)
#define LATHE_TYPE_PROTOLATHE (1<<1)
#define LATHE_TYPE_CIRCUIT (1<<2)
#define LATHE_TYPE_PROSTHETICS (1<<3)
#define LATHE_TYPE_MECHFAB (1<<4)
#define LATHE_TYPE_BIOPRINTER (1<<5)

DEFINE_BITFIELD(lathe_type, list(
	BITFIELD(LATHE_TYPE_AUTOLATHE),
	BITFIELD(LATHE_TYPE_PROTOLATHE),
	BITFIELD(LATHE_TYPE_CIRCUIT),
	BITFIELD(LATHE_TYPE_PROSTHETICS),
	BITFIELD(LATHE_TYPE_MECHFAB),
	BITFIELD(LATHE_TYPE_BIOPRINTER),
))
