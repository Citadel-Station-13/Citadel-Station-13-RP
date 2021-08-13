// Values for /atom/var/CanFluidPass
/// Same as canatmospass
#define FLUID_PASS_ATMOS	-1
/// No
#define FLUID_PASS_NO		FALSE
/// Yes
#define FLUID_PASS_YES		TRUE
/// Call CanFluidPass()
#define FLUID_PASS_PROC		-2
/// Check density
#define FLUID_PASS_DENSITY	-3

/// Checks if fluids can pass this thing
#define CANFLUIDPASS(A, O)	(A.CanFluidPass == FLUID_PASS_ATMOS? (CANATMOSPASS(A, O)) : (A.CanFluidPass == FLUID_PASS_DENSITY? !A.density : (A.CanFluidPass == FLUID_PASS_PROC? A.CanFluidPass(O) : A.CanFluidPass)))

// Values for /turf/var/fluid_status
/// All fluids entering this turf are destroyed.
#define FLUID_STATUS_NULL		0
/// All fluids cannot enter this turf; If fluids enter anyways, they are destroyed.
#define FLUID_STATUS_BLOCK		1
/// Fluids can enter this turf as normal as long as CANFLUIDPASS returns FLUID_PASS_YES
#define FLUID_STATUS_NORMAL		2

// Values for /atom/var/fluid_processing
/// Do not fluid_act this atom
#define FLUID_PROCESSING_NONE			0
/// fluid_act this atom using subsystem ticking
#define FLUID_PROCESSING_SUBSYSTEM		1
/// fluid_act this atom upon entering a fluid, or having a fluid flow over it only
#define FLUID_PROCESSING_ENTER			2
/// Tracks that an atom has been initially fluid_acted and should not fluid_act again on the next tick - USED WITH FLUID_PROCESSING_SUBSYSTEM! Do not manually assign.
#define FLUID_PROCESSING_STARTED		3
