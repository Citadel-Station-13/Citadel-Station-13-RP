// /atom/var/CanAtmosPass
/// Air can never pass through us. This is different from air_status, use AIR_STATUS_BLOCK for walls and stuff on turfs, this just halts airflow.
#define ATMOS_PASS_NO			0
/// Air can always pass through us.
#define ATMOS_PASS_YES			1
/// Ask CanAtmosPass() if we should let air pass.
#define ATMOS_PASS_PROC			-1
/// Air can pass if we're not dense.
#define ATMOS_PASS_DENSITY		-2

/// Define for checking if air can pass from source to destination when destination is get_step(src, cardinal)
#define CANATMOSPASS(A, O) ( A.CanAtmosPass == ATMOS_PASS_PROC ? A.CanAtmosPass(O) : ( A.CanAtmosPass == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPass ) )
/// MultiZ define for checking if air can pass from source to destination when destination is get_step(src, UP or DOWN) rather than a cardinal.
#define CANVERTICALATMOSPASS(A, O) ( A.CanAtmosPassVertical == ATMOS_PASS_PROC ? A.CanAtmosPass(O, TRUE) : ( A.CanAtmosPassVertical == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPassVertical ) )

