//? lathe_type bitfield

#define LATHE_TYPE_AUTOLATHE (1<<0)
#define LATHE_TYPE_PROTOLATHE (1<<1)
#define LATHE_TYPE_CIRCUIT (1<<2)
#define LATHE_TYPE_PROSTHETICS (1<<3)
#define LATHE_TYPE_MECHA (1<<4)
#define LATHE_TYPE_BIOPRINTER (1<<5)

DEFINE_BITFIELD(lathe_type, list(
	BITFIELD(LATHE_TYPE_AUTOLATHE),
	BITFIELD(LATHE_TYPE_PROTOLATHE),
	BITFIELD(LATHE_TYPE_CIRCUIT),
	BITFIELD(LATHE_TYPE_PROSTHETICS),
	BITFIELD(LATHE_TYPE_MECHA),
	BITFIELD(LATHE_TYPE_BIOPRINTER),
))

//? design_unlock bitfield

/// any lathe that can print us should have us always
#define DESIGN_UNLOCK_INTRINSIC (1<<0)
/// any lathe that can print us can have us uploaded
#define DESIGN_UNLOCK_UPLOAD (1<<1)

//? design_flags bitfield

/// do not scale with efficiency
#define DESIGN_NO_SCALE (1<<0)
